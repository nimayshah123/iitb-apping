# iitb_apping

A **Claude skill** that finds professors at any university in a given field and sends
personalized research/internship cold-emails **from your IITB Roundcube webmail**
(`webmail.iitb.ac.in`) — using your own Claude chat and your own logged-in browser.
No API keys, no servers, no per-email cost beyond your Claude subscription.

It automates the tedious parts — finding faculty, verifying emails from official pages,
drafting a tailored email per professor, and filling the compose window — while keeping
**you in control of every send**.

---

## What it does
1. You give it a **field** and a **university**.
2. It finds relevant professors and **verifies their emails from official faculty pages** (never guesses).
3. It reads your **CV** and writes a **personalized email per professor** — a hook referencing their actual research plus three real project bullets from your CV.
4. It opens each email in your webmail, you **attach your files**, and it sends on your confirmation.

The emails follow a proven format: a tight intro, a one-line hook, three bolded project
bullets, a soft ask, and a clean LinkedIn | GitHub signature. See a real example in
`references/email-templates.md`.

---

## Customize it first (one-time, ~2 minutes)
Open **`references/applicant-config.md`** and fill in the `<< ... >>` blanks:
- **Identity** — your name, institute, the exact degree line, and the credential (e.g. CPI) shown in the intro.
- **Links** — your LinkedIn and GitHub URLs (they go in every signature).
- **Attachments** — paths to your CV and transcript. Keep multiple CVs (e.g. an ML CV and a hardware CV) and tag each with the fields it suits; the skill picks the best match per professor.
- **Preferences** — the subject's intern label, the dates you're pitching, your sign-off, and any hard rules (e.g. `must_not_mention: ["visa", "hosting"]`, or rename a project consistently).

You can also just **start a run and let the skill ask you** — it writes your answers back into
the config so you're never asked twice. Either way, per run it only needs: *field, university,
dates, and which professors.*

> Want to adapt the whole voice? Edit the base body in `references/email-templates.md`. The
> bolding checklist there is what makes the emails look hand-written rather than mail-merged —
> keep it if you change the wording.

---

## Requirements
- **Claude Code** (or Claude with skills support).
- **[kimi-webbridge](https://www.kimi.com/features/webbridge)** installed and running (local daemon + browser extension) — this is what lets Claude drive your browser.
- You must be **logged into https://webmail.iitb.ac.in** in that browser.

## Install
```bash
git clone <this-repo> ~/.claude/skills/iitb_apping
```
Then edit `references/applicant-config.md` (above), and in Claude say:
**"use iitb_apping to find professors at <university> in <field> and email them"** (or `/iitb_apping`).

## A typical run
1. *"/iitb_apping — find 15 AI/ML profs at NUS and email them for a July–Aug research internship."*
2. The skill checks kimi-webbridge + your webmail login, loads your config.
3. It finds professors, verifies emails, and shows you a table to approve.
4. It reads your CV, shows you the **first fully-rendered draft** for sign-off.
5. It composes each email in turn; you click **Attach → CV + transcript → Send** (or say "send"), then "next".

## Limitations
- **Attachments are manual** — browsers block programmatic file uploads, so you click "Attach" and pick your CV/transcript yourself before sending. Everything else is filled for you.
- **Roundcube only** for now (built for IITB webmail). Other providers need their own adapter in `references/webmail-roundcube.md`.
- Requires kimi-webbridge to be healthy (the skill checks this first).
- **Send in reasonable batches.** Lots of cold mail from one personal account in a single sitting can hit sending limits or spam filters — space it out.

## Layout
```
iitb_apping/
├── SKILL.md                       # the playbook Claude follows
├── README.md                      # this file
├── references/
│   ├── applicant-config.md        # << CUSTOMIZE: your identity, links, CVs, preferences >>
│   ├── finding-professors.md      # how to find + verify emails (no hallucinated addresses)
│   ├── email-templates.md         # the proven body, bolding checklist, subject, hooks, follow-up
│   └── webmail-roundcube.md       # proven Roundcube DOM selectors + the attachment caveat
└── scripts/
    ├── compose.ps1                # fills To/Subject/HTML-body via the kimi-webbridge daemon
    └── send.ps1                   # clicks Send (after your confirmation)
```

## Ethics
Use it for genuine, personalized outreach. Verify emails, keep volumes reasonable, never
misrepresent your experience, and only claim projects your CV actually supports. It's a
productivity tool, not a spam cannon.
