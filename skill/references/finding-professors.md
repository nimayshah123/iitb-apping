# Finding professors (and verifying emails)

The single most important quality rule: **only send to emails you actually verified on an official page.** A hallucinated or stale address bounces, looks careless, and wastes the slot.

## 1. Disambiguate the university first
Many abbreviations collide. Confirm with the user before searching:
- **NTU** → Nanyang Technological University (Singapore) **or** National Taiwan University (Taipei)
- **UCL, NUS, KU, TUM, ETH** etc. — check country/exact name.
Getting this wrong invalidates the entire run.

## 2. Find candidates
Use WebSearch + WebFetch. Prefer **official department faculty directories**:
- `https://<dept>.<univ>.edu/.../faculty` (e.g. `giee.ntu.edu.tw/en/faculty_all.php`, `csie.ntu.edu.tw/en/member/Faculty`)
- Individual faculty / lab pages on the university domain.
Avoid ResearchGate / Google Scholar / blogs as the *email* source — use them only to discover names, then verify on the official site.

Group candidates by **sub-area** (e.g. AI/ML, AI+chip design, devices) so the hooks can be tailored.

## 3. Verify each email
- Fetch the official faculty/lab page and read the address directly.
- Some sites show the email as an **image** or as `name (at) dept.edu` — note these and confirm with the user before trusting the obvious expansion.
- **Never construct an email from a guessed pattern.** If you can't verify it, mark it `email not verified` and give the page URL instead of sending.

## 4. Present for approval
Show a table before drafting:

| Professor | Dept | Research areas | Email | Source |
|---|---|---|---|---|
| … | … | … | ✅ verified / ⚠️ unverified | URL |

Let the user pick who to contact. Only auto-send to ✅ rows.

## 5. Tailoring hooks
For each professor capture one concrete detail of their work (a lab theme, a notable result, a specific paper) to use as the personalization hook in the email. Generic praise reads as spam; a specific reference reads as genuine interest.
