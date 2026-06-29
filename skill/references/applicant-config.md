# Applicant config — CUSTOMIZE THIS FIRST

This is the one place you make the skill yours. Fill in your details below, then the
agent reuses them on every run so it never has to re-ask. Edit the values between the
`<<` `>>` markers (keep the keys). Anything you leave as a `<< ... >>` placeholder, the
agent will ask you for on first use and then write back here.

> Tip: you can keep more than one profile (e.g. an "ML" profile and a "hardware" profile)
> by copying the block and the agent will ask which to use.

---

## 1. Identity (goes in every email)
```yaml
full_name:        << Your Full Name >>            # e.g. Nimay Shah
institute:        << Your Institute >>            # e.g. IIT Bombay
# The exact degree phrase that appears (BOLD) in the intro line:
degree_line:      << degree phrase >>             # e.g. B.Tech (Honors) graduate in Electrical Engineering from IIT Bombay
# The credential shown in parentheses (NOT bold):
credential:       << credential >>                # e.g. CPI 9.89/10, with a Minor in Computer Science
level:            << level >>                     # e.g. recent graduate (2026) | final-year undergrad | master's student
```

## 2. Links (signature — plain hyperlinks, never styled buttons)
```yaml
linkedin_url:     << https://linkedin.com/in/your-handle >>
github_url:       << https://github.com/your-handle >>
# Optional extras you can add to the signature line (website, Scholar). Leave blank to skip.
extra_link_label: <<  >>
extra_link_url:   <<  >>
```

## 3. Attachments (you attach these manually at send time — browsers block auto-upload)
```yaml
cv_path:          << C:\path\to\Your_CV.pdf >>
transcript_path:  << C:\path\to\Your_Transcript.pdf >>
# If you keep multiple CVs (e.g. an ML CV and a hardware CV), list them and note which
# fields they suit — the agent will pick the best-matching one per professor:
cv_variants:
  - { file: <<  >>, use_for: <<  >> }   # e.g. { file: ML_CV.pdf, use_for: AI/ML, vision, generative }
  - { file: <<  >>, use_for: <<  >> }   # e.g. { file: Core_CV.pdf, use_for: hardware, EDA, chip design }
```

## 4. Sender mailbox
```yaml
webmail:          https://webmail.iitb.ac.in     # Roundcube. Change only if your adapter differs.
from_account:     << your-roll@iitb.ac.in >>
```

## 5. Email preferences (tone & content knobs)
```yaml
# The word(s) before "Intern" in the subject. Keep generic unless a named scheme truly applies.
intern_label:     Research Intern                # e.g. "Research Intern", "IIPP Intern", "Summer Research Intern"
dates_phrase:     << July–August 2026 >>         # the window you are pitching
sign_off:         Best regards                   # or "Warm regards", "Kind regards"
greeting_style:   Dear Prof. <LastName>          # how to address professors
# Hard content rules the agent must honour:
must_not_mention: []                             # e.g. ["hosting", "invitation letter", "visa"] to keep those OUT of the body
project_naming:   {}                             # rename projects in emails, e.g. { CompCLIP: GS-CLIP }
```

---

## How the agent uses this
- On first run, the agent fills any `<< ... >>` blanks by asking you, then **persists** them
  (here and/or in its memory) so later runs are zero-friction.
- Per run it only needs: **field, target university, dates, and which professors**.
- Everything in §1–§5 flows into the tokens used by `email-templates.md`.
- **Honesty rule:** the agent only writes project bullets it can ground in your real CV
  (see Step 3 in SKILL.md). It will never invent results to fit a professor.
