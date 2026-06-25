---
name: iitb_apping
description: Find professors/researchers at a university in a given field and draft + send personalized research/internship cold-emails from the user's IITB Roundcube webmail (webmail.iitb.ac.in) using kimi-webbridge browser automation. Use when the user wants to bulk-find faculty and send outreach for internships, research projects, PhD inquiries, or program applications (e.g. "find professors at NTU in AI and email them", "send outreach to semiconductor profs", "/iitb_apping").
---

# IITB Apping — professor outreach from IITB webmail

Find relevant professors at a target university, draft tailored cold-emails, and send them from the user's **IITB Roundcube webmail** by driving the browser with **kimi-webbridge**. The user pays nothing beyond their Claude subscription — the AI runs in their own chat and the browser is their own logged-in session.

## How it works (high level)
1. Confirm prerequisites (kimi-webbridge running; user logged into webmail.iitb.ac.in).
2. Gather: field/topic, **university (disambiguate!)**, level, program/dates, sender identity.
3. Find professors via web search; **verify every email from an official faculty page**.
4. Collect the user's CV + transcript file paths.
5. Draft a shared template + a per-professor research hook.
6. For each email: open compose, fill To/Subject/body, **user attaches the files**, confirm, send. One at a time.

---

## Step 0 — Prerequisites & health check

This skill **requires kimi-webbridge** (a local daemon + browser extension). Run:

```bash
~/.kimi-webbridge/bin/kimi-webbridge status
```

- Not installed / `running:false` / `extension_connected:false` → tell the user to set up kimi-webbridge first (invoke that skill), then retry. Do not proceed without it.
- Healthy (`running:true, extension_connected:true`) → continue.

Also confirm the user is **logged into https://webmail.iitb.ac.in** in their browser. Find their open tab:

```bash
curl -s -X POST http://127.0.0.1:10086/command -H 'Content-Type: application/json' \
  -d '{"action":"find_tab","args":{"url":"webmail.iitb.ac.in","active":true},"session":"iitb-mail"}'
```

If no tab is found, ask the user to open and log into webmail.iitb.ac.in, then retry.

---

## Step 1 — Gather inputs

A typical prompt ("find professors at NUS in ML and email them for an internship July–August") gives you the field, university, purpose and dates but **leaves the rest implicit**. Take whatever the user provided, then **ask (AskUserQuestion) for anything still missing — do not assume**:
- **Field / topic** (e.g. "ML", "AI + chip design") — usually given.
- **University** — and **disambiguate** if ambiguous (e.g. "NTU" = Nanyang Tech *or* National Taiwan University). Getting this wrong wastes the whole run.
- **Level** (undergrad / master's / recent grad / PhD-track) — almost never in the prompt; **ask**.
- **Program / funding scheme + dates** — only include a named scheme if it actually applies to that country (e.g. NSTC IIPP is Taiwan-only; for NUS/Singapore use a generic "research internship"). Confirm dates; **ask** if the scheme is unclear.
- **Sender identity** for the signature (name, institute) — infer from the user/their files if obvious, otherwise **ask**.
- **LinkedIn + GitHub URLs** — **always ask** for these if not in the profile. Every email signature **must end with LinkedIn + GitHub buttons** (see `references/email-templates.md`).
- **CV + transcript** file paths (Step 3) — **ask**; never proceed to send without them.

**Applicant profile (reuse — don't re-ask every run):** the identity-level answers (name, institute, level, CPI/credential, signature, default CV + transcript paths) rarely change for a given user. On first run, capture them; then **persist them** (e.g. to the user's memory as an applicant profile) and **reuse on later runs**, only re-confirming if the user signals something changed. Per-run questions are just: field, university, dates, and which professors to contact.

Only start finding professors once field + university + level are settled.

## Step 2 — Find professors (accuracy is everything)

Follow `references/finding-professors.md`. Core rules:
- Pull names + research areas + emails from **official department faculty directories** (`*.univ.edu` faculty pages), not blogs or aggregators.
- **Never invent or guess an email.** Only include an address you actually saw on an official page; cite the source URL. Flag anything unverified and exclude it from auto-send.
- Group by sub-area so hooks can be tailored.
- Present a table for the user to approve before drafting.

## Step 3 — Collect AND parse the resume (do this thoroughly, before drafting)

This step builds the applicant profile that every email is tailored from — so do it carefully.

1. **Ask the user to provide/upload their CV/resume** (and transcript). Auto-search likely folders (Downloads, Desktop) and confirm the exact files; record absolute paths (they'll attach these manually at send time).
2. **Read the resume thoroughly** (Read the PDF). Extract a structured profile:
   - Name, institute, degree, level, graduation year
   - **CPI/GPA** and key academic honors
   - **Every project / research experience in detail** — title, what was built, tools, methods, quantified results
   - Internships, skills, publications
3. **Confirm the extracted profile** with the user (especially CPI to display and which projects to feature), and persist it (memory) for reuse.
4. Use these **real, extracted project details** as the source for the per-professor email bullets in Step 4 — never invent or embellish beyond what the resume supports.

If a stored applicant profile already exists and the user hasn't changed resumes, reuse it instead of re-parsing.

## Step 4 — Draft emails

Follow `references/email-templates.md`:
- One shared body + a **per-professor research hook** referencing their actual work.
- A clear subject line.
- **Bold key terms** (the body is set as HTML in the rich-text editor).
- Show the user the drafts (or at least the first one + the hook list) and let them tweak tone, credentials, dates before sending.

## Step 5 — Compose & send loop

For **each** professor, do them **one at a time** with user confirmation:

1. Write the email body HTML to a temp file (e.g. `$TEMP/iitb_apping_body.html`), using `<p>`, `<ul><li>`, and `<strong>` for bold.
2. Run the compose helper:

```bash
powershell -File "~/.claude/skills/iitb_apping/scripts/compose.ps1" \
  -To "prof@univ.edu" \
  -Subject "Prospective Intern (…)" \
  -BodyHtmlPath "$TEMP/iitb_apping_body.html"
```

   It navigates to a fresh compose, fills the recipient (Roundcube recipient widget), subject, and the HTML body. It prints the resulting To/Subject so you can verify.
3. **Attachments are manual** — tell the user: *"Click Attach, add your CV + transcript, then say 'send' (or hit Send yourself)."* See the limitation note below.
4. On the user's go-ahead, either let them click Send, or click it via webbridge (see `references/webmail-roundcube.md` for the Send selector). **Always confirm before sending** — these are real outgoing emails.
5. Move to the next professor.

Keep a running tally (sent / pending) and report at the end.

---

## Etiquette & safety (enforce these)
- **Verify emails** — a wrong/dead address is worse than no email.
- **Genuine personalization** — every email must reference that professor's actual research. No mail-merge spam.
- **Reasonable caps** — don't blast hundreds in one sitting; space them out. Cold outreach from a personal account can hit spam filters or sending limits.
- **Confirm before each send.** Sending is irreversible and outward-facing.
- **Honest framing** — never overclaim experience the user doesn't have.

## Known limitations (tell the user up front)
- **Attachments can't be automated.** The browser blocks programmatic file uploads (CDP "Not allowed"), so the user must click Attach and pick the files themselves before sending. The skill fills everything else.
- **Roundcube only** (webmail.iitb.ac.in). Other webmail providers need their own adapter.
- **Requires kimi-webbridge** running with the browser extension connected.
