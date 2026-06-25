# iitb_apping

A **Claude skill** that helps you find professors at any university in a given field and send personalized research/internship cold-emails **from your IITB Roundcube webmail** (`webmail.iitb.ac.in`) — using your own Claude chat and your own logged-in browser. No API keys, no servers, no per-email cost beyond your Claude subscription.

It automates the tedious parts (finding faculty, verifying emails, drafting tailored emails, filling the compose window) while keeping you in control of every send.

## What it does
1. You give it a **field** and a **university**.
2. It finds relevant professors and **verifies their emails from official faculty pages**.
3. You give it your **CV + transcript**.
4. It **drafts a personalized email** for each professor (with a hook referencing their actual research).
5. It opens each email in your webmail, you **attach your files**, and it sends on your confirmation.

## Requirements
- **Claude Code** (or Claude with skills support).
- **[kimi-webbridge](https://www.kimi.com/features/webbridge)** installed and running (local daemon + browser extension) — this is what lets Claude drive your browser.
- You must be **logged into https://webmail.iitb.ac.in** in that browser.

## Install
One command (requires Node 16.7+):
```bash
npx github:nimayshah123/iitb-apping
```
This copies the skill into `~/.claude/skills/iitb_apping/`. Then in Claude, say: **"use iitb_apping to find professors at <university> in <field> and email them"** (or `/iitb_apping`).

## Limitations
- **Attachments are manual** — browsers block programmatic file uploads, so you click "Attach" and pick your CV/transcript yourself before sending. Everything else is filled for you.
- **Roundcube only** for now (built for IITB webmail). Other webmail providers need their own adapter in `references/`.
- Requires kimi-webbridge to be healthy (the skill checks this first).

## Layout
```
iitb_apping/
├── SKILL.md                       # the playbook Claude follows
├── references/
│   ├── finding-professors.md      # how to find + verify emails (no hallucinated addresses)
│   ├── email-templates.md         # base template, hooks, follow-ups
│   └── webmail-roundcube.md       # proven Roundcube DOM selectors + the attachment caveat
└── scripts/
    └── compose.ps1                # fills To/Subject/HTML-body via the kimi-webbridge daemon
```

## Ethics
Use it for genuine, personalized outreach. Verify emails, keep volumes reasonable, and never misrepresent your experience. It's a productivity tool, not a spam cannon.
