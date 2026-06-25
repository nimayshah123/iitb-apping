<#
  compose.ps1 — open a fresh Roundcube compose and fill To / Subject / HTML body
  via the kimi-webbridge daemon. Does NOT send. Attachments must be added by the
  user (the browser blocks programmatic uploads).

  All three fields are passed to the page as base64 and decoded in JS, so any
  characters (quotes, &, <>, unicode, em-dashes, emoji, newlines) are safe.

  Usage:
    powershell -File compose.ps1 -To "prof@univ.edu" -Subject "..." -BodyHtmlPath "C:\path\body.html"
#>
param(
  [Parameter(Mandatory=$true)][string]$To,
  [Parameter(Mandatory=$true)][string]$Subject,
  [Parameter(Mandatory=$true)][string]$BodyHtmlPath,
  [string]$ComposeUrl = "https://webmail.iitb.ac.in/?_task=mail&_action=compose",
  [string]$Session    = "iitb-mail",
  [string]$Daemon     = "http://127.0.0.1:10086/command"
)
$ErrorActionPreference = "Stop"

function Invoke-WB($obj){
  $json = $obj | ConvertTo-Json -Depth 8 -Compress
  try {
    $r = Invoke-RestMethod -Uri $Daemon -Method Post -ContentType 'application/json' -Body $json -TimeoutSec 30
  } catch {
    throw "kimi-webbridge daemon not reachable at $Daemon. Is it running ('kimi-webbridge status')? $($_.Exception.Message)"
  }
  if($r.ok -ne $true){ throw "webbridge error: $($r.error.message)" }
  return $r
}
function B64([string]$s){ return [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes([string]$s)) }

# Roundcube arms a beforeunload "discard unsaved changes?" prompt; that native dialog
# blocks programmatic navigation (and freezes CDP). This JS suppresses it so we can
# open a fresh compose repeatedly without the tab getting stuck.
$DISARM = "window.onbeforeunload=null; if(!window.__iitbApDisarm){window.addEventListener('beforeunload',function(e){e.stopImmediatePropagation(); e.returnValue=undefined;}, true); window.__iitbApDisarm=true;} 'disarmed'"
function Disarm-Safe(){ try { Invoke-WB @{ action='evaluate'; args=@{ code=$DISARM }; session=$Session } | Out-Null } catch {} }

if(-not (Test-Path $BodyHtmlPath)){ throw "Body HTML file not found: $BodyHtmlPath" }
$html = [IO.File]::ReadAllText($BodyHtmlPath)   # avoids Get-Content note-property quirk
if([string]::IsNullOrWhiteSpace($html)){ throw "Body HTML file is empty: $BodyHtmlPath" }

# 0) best-effort: disarm any unsaved-changes prompt on the current page first
Disarm-Safe

# 1) open a fresh compose. Reuse the session tab if present; otherwise open a new tab
#    (navigating a session with no tab returns a 502/no-tab error).
try {
  Invoke-WB @{ action='navigate'; args=@{ url=$ComposeUrl }; session=$Session } | Out-Null
} catch {
  Invoke-WB @{ action='navigate'; args=@{ url=$ComposeUrl; newTab=$true }; session=$Session } | Out-Null
}

# 2) wait until the compose UI + TinyMCE are ready
$ready = $false
for($i=0; $i -lt 24; $i++){
  Start-Sleep -Milliseconds 500
  try {
    $r = Invoke-WB @{ action='evaluate'; args=@{ code="(typeof tinymce!=='undefined' && !!tinymce.activeEditor && !!document.querySelector('.recipient-input input') && !!document.querySelector('input[name=_subject], #compose-subject, textarea[name=_subject]'))" }; session=$Session }
    if($r.data.value -eq $true){ $ready = $true; break }
  } catch {}
}
if(-not $ready){ throw "Compose window did not become ready (is the user logged into webmail.iitb.ac.in?)" }

# disarm this fresh compose's unsaved-changes prompt so the NEXT navigation isn't blocked
Disarm-Safe

# 3) fill recipient (recipient-widget) + subject  (base64 -> decode in JS)
$toB   = B64 $To
$subB  = B64 $Subject
$codeMeta = @"
(function(){
  var dec=function(b){return new TextDecoder().decode(Uint8Array.from(atob(b),function(c){return c.charCodeAt(0)}));};
  var to=dec('$toB'), subj=dec('$subB');
  var r=document.querySelector('.recipient-input');
  var cands=[].slice.call(r.querySelectorAll('input')).filter(function(e){return e.offsetParent!==null;});
  var inp=cands.length?cands[0]:r.querySelector('input');
  var set=Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype,'value').set;
  set.call(inp,to);
  inp.dispatchEvent(new Event('input',{bubbles:true}));
  inp.dispatchEvent(new KeyboardEvent('keydown',{key:'Enter',keyCode:13,which:13,bubbles:true}));
  inp.dispatchEvent(new KeyboardEvent('keyup',{key:'Enter',keyCode:13,which:13,bubbles:true}));
  inp.dispatchEvent(new Event('blur',{bubbles:true}));
  var s=document.querySelector('input[name=_subject], #compose-subject, textarea[name=_subject]');
  if(s){ set.call(s,subj); s.dispatchEvent(new Event('input',{bubbles:true})); s.dispatchEvent(new Event('change',{bubbles:true})); }
  return JSON.stringify({to:(document.getElementById('_to')?document.getElementById('_to').value:''),subj:(s?s.value:'')});
})()
"@
$meta = Invoke-WB @{ action='evaluate'; args=@{ code=$codeMeta }; session=$Session }

# 4) set HTML body in TinyMCE  (base64 -> decode in JS)
$bodyB = B64 $html
$codeBody = "(function(){var dec=function(b){return new TextDecoder().decode(Uint8Array.from(atob(b),function(c){return c.charCodeAt(0)}));};var ed=tinymce.get('composebody')||tinymce.activeEditor;ed.setContent(dec('$bodyB'));return 'bodyLen='+ed.getContent().length;})()"
$bodyRes = Invoke-WB @{ action='evaluate'; args=@{ code=$codeBody }; session=$Session }
if($bodyRes.data.value -notmatch 'bodyLen=[1-9]'){ throw "Body did not populate (got: $($bodyRes.data.value))" }

Write-Output ("COMPOSED -> " + $meta.data.value + " | " + $bodyRes.data.value)
Write-Output "Next: user attaches CV + transcript, then send."
