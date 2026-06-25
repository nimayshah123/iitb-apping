# Roundcube webmail adapter (webmail.iitb.ac.in)

DOM facts proven to work on IITB's Roundcube (Elastic skin). Used by `scripts/compose.ps1`.

## Session & compose
- kimi-webbridge session name: `iitb-mail`
- Open a fresh compose **inside the main tab** (the popup-window compose is a separate browser window the extension can't see):
  `navigate` → `https://webmail.iitb.ac.in/?_task=mail&_action=compose`
- Wait until ready: `typeof tinymce!=='undefined' && !!tinymce.activeEditor && !!document.querySelector('.recipient-input input')`

## Fields
- **To** — a recipient *widget*, not a plain input. `fill` fails on it. Instead type into the visible input inside `.recipient-input`, set value via the native setter, dispatch `input` + Enter `keydown` + `blur` to commit it into a recipient chip. The committed value lands in the hidden `textarea#_to`.
- **Subject** — `input[name=_subject]` (a.k.a. `#compose-subject`). Set value + dispatch `change`.
- **Body** — Roundcube HTML mode uses **TinyMCE**, editor id `composebody`. Set rich content with:
  `tinymce.activeEditor.setContent(<html>)` — this is how bold/bullets render.
- **Attachments** — file input is `#uploadformInput` (`name="_attachments[]"`, hidden, multiple).
  ⚠️ **Programmatic upload is blocked** — `DOM.setFileInputFiles` returns CDP error `-32000 "Not allowed"`, even with the input made visible. **The user must click Attach and pick files manually.** Do not promise auto-attach.
- **Send** — the toolbar Send button. Robust click via evaluate (matches a clickable whose text/title is exactly "Send"):
  ```js
  (()=>{const els=[...document.querySelectorAll('a,button')];const b=els.find(e=>/^\s*send\s*$/i.test((e.textContent||'')+ (e.title||'')) || /\bsend\b/i.test(e.className));if(b){b.click();return 'clicked';}return 'send-not-found';})()
  ```
  Always confirm with the user before clicking Send.

## Recommended per-email flow
1. `compose.ps1 -To … -Subject … -BodyHtmlPath …` (fills everything)
2. Verify the printed `to`/`subj`.
3. Ask user to attach CV + transcript.
4. On confirmation, click Send (or let the user click it).
