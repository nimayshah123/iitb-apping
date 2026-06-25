<#
  send.ps1 — click the Send button in the current Roundcube compose via kimi-webbridge.
  Call ONLY after the user has confirmed the recipient/body are correct and (if needed)
  attached their files. Sending is irreversible — the skill must confirm first.

  Usage: powershell -File send.ps1
#>
param(
  [string]$Session = "iitb-mail",
  [string]$Daemon  = "http://127.0.0.1:10086/command"
)
$ErrorActionPreference = "Stop"

function Invoke-WB($obj){
  $json = $obj | ConvertTo-Json -Depth 8 -Compress
  $r = Invoke-RestMethod -Uri $Daemon -Method Post -ContentType 'application/json' -Body $json -TimeoutSec 30
  if($r.ok -ne $true){ throw "webbridge error: $($r.error.message)" }
  return $r
}

$code = @'
(function(){
  var els=[].slice.call(document.querySelectorAll('a,button,input[type=button],input[type=submit]'));
  var b=els.filter(function(e){
    if(e.offsetParent===null) return false;
    var t=((e.textContent||'')+' '+(e.title||'')+' '+(e.value||'')).replace(/\s+/g,' ').trim();
    return /^send$/i.test(t) || /(^|\s)send($|\s)/i.test(e.className);
  })[0];
  if(b){ b.click(); return 'clicked'; }
  return 'send-not-found';
})()
'@
$r = Invoke-WB @{ action='evaluate'; args=@{ code=$code }; session=$Session }
if($r.data.value -ne 'clicked'){ throw "Could not find the Send button (got: $($r.data.value))" }
Write-Output "SENT (Send button clicked)."
