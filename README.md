# iitb-apping

A **Claude skill** that finds professors at any university in a given field and sends personalized research/internship cold-emails **from your IITB Roundcube webmail** (`webmail.iitb.ac.in`) — using your own Claude chat and your own logged-in browser. No API keys, no servers, no per-email cost beyond your Claude subscription.

It automates the tedious parts (finding faculty, verifying emails from official pages, drafting tailored emails, filling the compose window) while keeping **you** in control of every send.

## Install (one command)

```bash
npx github:nimayshah123/iitb-apping
```

That copies the skill into `~/.claude/skills/iitb_apping/`. To update later, re-run with `--force`. To remove it, run with `--uninstall`.

> Requires **Node 16.7+** (only to run the installer) and **Claude Code**.

## What it does
1. You give it a **field** and a **university**.
2. It finds relevant professors and **verifies their emails from official faculty pages** (never guesses an address).
3. You give it your **CV + transcript**.
4. It **drafts a personalized email** for each professor, with a hook referencing their actual research.
5. It opens each email in your webmail; you **attach your files** and it sends on your confirmation — one at a time.

## Requirements
- **Claude Code** (or Claude with skills support).
- **[kimi-webbridge](https://www.kimi.com/features/webbridge)** installed and running (local daemon + browser extension) — this is what lets Claude drive your browser.
- Logged into **https://webmail.iitb.ac.in** in that browser.

## Platform support
- **Windows only** for now. The browser-automation helpers (`scripts/compose.ps1`, `scripts/send.ps1`) are PowerShell. Mac/Linux support (Node port of the helpers) is planned — PRs welcome.

## Usage
After installing, in Claude Code run **`/iitb_apping`**, or just say:
> "use iitb_apping to find professors at \<university\> in \<field\> and email them for a research internship"

## Limitations
- **Attachments are manual** — browsers block programmatic file uploads, so you click "Attach" and pick your CV/transcript yourself before sending. Everything else is filled for you.
- **Roundcube only** (built for IITB webmail). Other providers need their own adapter in `references/`.
- Requires kimi-webbridge to be healthy (the skill checks this first).

## What gets installed
```
~/.claude/skills/iitb_apping/
├── SKILL.md                       # the playbook Claude follows
├── references/
│   ├── finding-professors.md      # how to find + verify emails (no hallucinated addresses)
│   ├── email-templates.md         # base template, hooks, follow-ups
│   └── webmail-roundcube.md        # proven Roundcube DOM selectors + the attachment caveat
└── scripts/
    ├── compose.ps1                # fills To/Subject/HTML-body via the kimi-webbridge daemon
    └── send.ps1                   # clicks Send (only after your confirmation)
```

## Ethics
Use it for genuine, personalized outreach. Verify emails, keep volumes reasonable, and never misrepresent your experience. It's a productivity tool, not a spam cannon.

## License
MIT
