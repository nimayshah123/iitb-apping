# Email templates

Goal: a warm, specific, low-pressure cold email that's easy to reply to — one shared body,
one **per-professor hook**, three **real** project bullets, and deliberate bolding so the eye
lands on the right things. All tokens (`{{...}}`) come from `applicant-config.md`.

This is the **exact format that has worked in practice** — match it; don't drift.

---

## Subject line
```
Prospective {{intern_label}} ({{dates_phrase}}) - {{Topic}} - {{full_name}}, {{institute}}
```
- Use a plain hyphen ` - ` as the separator (renders cleanly everywhere).
- `{{Topic}}` = 3–6 words naming the professor's exact area (e.g. "Vision-Language & Self-Supervised Representation Learning", "Machine Learning for EDA & Physical Design").
- Example: `Prospective Research Intern (July-Aug 2026) - Bayesian Deep Learning & Generative Models - <Your Name>, <Institute>`

## Base body (HTML — TinyMCE `setContent`)
```html
<p>{{greeting}}</p>
<p>I am <strong>{{full_name}}</strong>, a recent <strong>{{degree_line}}</strong> ({{credential}}), hoping to spend {{dates_phrase}} contributing to research in your group, on-site at {{university}}.</p>
<p>My interests lie in {{interest_areas}}. {{hook}} Recently, I have worked on:</p>
<ul>
  <li><strong>{{project_1_name}}</strong> - {{project_1_detail_with_numbers}}</li>
  <li><strong>{{project_2_name}}</strong> - {{project_2_detail_with_numbers}}</li>
  <li><strong>{{project_3_name}}</strong> - {{project_3_detail_with_numbers}}</li>
</ul>
<p>{{credibility_line}}</p>
<p>Given this background, I was wondering whether there might be an <strong>opportunity to join your group for a research internship</strong> during {{dates_phrase}}, whether on-site or remotely. I would be glad to contribute to any ongoing project aligned with these interests.</p>
<p>My CV and transcript are attached. Thank you for your time and consideration.</p>
<p>{{sign_off}},<br><strong>{{full_name}}</strong><br><strong>{{institute}}</strong></p>
<p><a href="{{linkedin_url}}">LinkedIn</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="{{github_url}}">GitHub</a></p>
```

## Bolding checklist (this is what makes it look right — do ALL of these)
**Bold:**
- `{{full_name}}` in the opening line
- the whole `{{degree_line}}` phrase
- each project's **lead name** (the part before the ` - `)
- the ask phrase **"opportunity to join your group for a research internship"**
- `{{full_name}}` and `{{institute}}` in the sign-off

**Not bold:** the `{{credential}}` parenthetical, the dates, the hook sentence, the bullet details, the closing line.

## Signature rule
End with **plain named hyperlinks** — display text `LinkedIn` / `GitHub`, separated by `&nbsp;&nbsp;|&nbsp;&nbsp;`. Use clean `<a>` links, **never** styled background "buttons" (they look spammy in webmail). Pull URLs from `applicant-config.md`; never omit them.

## Worked example (fictional — copy this *shape*, fill with your own real projects)
```html
<p>Dear Prof. Chen,</p>
<p>I am <strong>Riya Menon</strong>, a recent <strong>B.Tech (Honors) graduate in Computer Science from IIT Bombay</strong> (CPI 9.2/10, with a Minor in Mathematics), hoping to spend July-August 2026 contributing to research in your group, on-site at the National University of Singapore.</p>
<p>My interests lie in vision-language models and self-supervised representation learning. Your work on self-supervised multimodal pre-training is exactly the area my recent projects sit in. Recently, I have worked on:</p>
<ul>
  <li><strong>Caption-Contrastive Pretraining</strong> - trained a CLIP-style dual encoder on a 2M image-text subset, improving zero-shot retrieval Recall@1 by 4.3 points over the baseline.</li>
  <li><strong>Masked Graph Autoencoder</strong> - reproduced a self-supervised graph model and added degree-aware masking, with consistent accuracy gains on citation-network benchmarks.</li>
  <li><strong>Multimodal Activity Detector</strong> - fused video and audio embeddings with a lightweight temporal policy for real-time event detection.</li>
</ul>
<p>I also interned last summer as a Machine Learning Intern at &lt;Company&gt;, building forecasting models over large time-series datasets.</p>
<p>Given this background, I was wondering whether there might be an <strong>opportunity to join your group for a research internship</strong> during July-August 2026, whether on-site or remotely. I would be glad to contribute to any ongoing project aligned with these interests.</p>
<p>My CV and transcript are attached. Thank you for your time and consideration.</p>
<p>Best regards,<br><strong>Riya Menon</strong><br><strong>IIT Bombay</strong></p>
<p><a href="https://www.linkedin.com/in/your-handle">LinkedIn</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="https://github.com/your-handle">GitHub</a></p>
```

## More worked examples (same fictional applicant, different professors — see how the bullets and hook shift)

**Example B — diffusion / generative-models professor** (lead with the generative bullet):
```html
<p>Dear Prof. Almeida,</p>
<p>I am <strong>Riya Menon</strong>, a recent <strong>B.Tech (Honors) graduate in Computer Science from IIT Bombay</strong> (CPI 9.2/10, with a Minor in Mathematics), hoping to spend July-August 2026 contributing to research in your group, on-site at &lt;University&gt; or remotely.</p>
<p>My interests lie in score-based generative models and diffusion for structured spaces. Your work on discrete diffusion and reflected diffusion models is close to the direction I want to pursue. Recently, I have worked on:</p>
<ul>
  <li><strong>Path-Space Diffusion</strong> - extended a diffusion model from state space to a measure over continuous trajectories, training a Transformer denoiser for fast rare-event sampling.</li>
  <li><strong>Diffusion, VAEs &amp; Accelerated Inference</strong> - designed diffusion models and VAEs for image generation and sped up model inference several-fold via speculative decoding.</li>
  <li><strong>Graph-Augmented CLIP</strong> - injected semantic graphs into a CLIP text encoder to improve compositional reasoning on a standard vision-language benchmark.</li>
</ul>
<p>I also interned last summer as a Machine Learning Intern at &lt;Company&gt;, building forecasting models over large time-series datasets.</p>
<p>Given this background, I was wondering whether there might be an <strong>opportunity to join your group for a research internship</strong> during July-August 2026, whether on-site or remotely. I would be glad to contribute to any ongoing project aligned with these interests.</p>
<p>My CV and transcript are attached. Thank you for your time and consideration.</p>
<p>Best regards,<br><strong>Riya Menon</strong><br><strong>IIT Bombay</strong></p>
<p><a href="https://www.linkedin.com/in/your-handle">LinkedIn</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="https://github.com/your-handle">GitHub</a></p>
```

**Example C — graph / self-supervised-learning professor** (lead with the graph bullet, hook cites a specific direction):
```html
<p>Dear Prof. Okafor,</p>
<p>I am <strong>Riya Menon</strong>, a recent <strong>B.Tech (Honors) graduate in Computer Science from IIT Bombay</strong> (CPI 9.2/10, with a Minor in Mathematics), hoping to spend July-August 2026 contributing to research in your group, on-site at &lt;University&gt; or remotely.</p>
<p>My interests lie in graph representation learning and the theory of graph neural networks. Your recent work on the expressivity of message-passing directly frames what I observed in my own graph project. Recently, I have worked on:</p>
<ul>
  <li><strong>Masked Graph Autoencoder</strong> - reproduced a self-supervised graph model and added centrality-aware masking, with consistent accuracy gains on citation-network benchmarks.</li>
  <li><strong>Graph-Augmented CLIP</strong> - injected semantic graphs into a CLIP text encoder to improve compositional reasoning on a standard vision-language benchmark.</li>
  <li><strong>Probabilistic Inference &amp; Bayesian Optimization</strong> - implemented exact inference for graphical models and explored Bayesian optimization with Gaussian-process surrogates.</li>
</ul>
<p>I also interned last summer as a Machine Learning Intern at &lt;Company&gt;, building forecasting models over large time-series datasets.</p>
<p>Given this background, I was wondering whether there might be an <strong>opportunity to join your group for a research internship</strong> during July-August 2026, whether on-site or remotely. I would be glad to contribute to any ongoing project aligned with these interests.</p>
<p>My CV and transcript are attached. Thank you for your time and consideration.</p>
<p>Best regards,<br><strong>Riya Menon</strong><br><strong>IIT Bombay</strong></p>
<p><a href="https://www.linkedin.com/in/your-handle">LinkedIn</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="https://github.com/your-handle">GitHub</a></p>
```

**Example D — hardware / EDA professor (Core-CV variant)** — note the *same applicant* swaps in hardware bullets and picks the Core CV:
```html
<p>Dear Prof. Petrova,</p>
<p>I am <strong>Riya Menon</strong>, a recent <strong>B.Tech (Honors) graduate in Electrical Engineering from IIT Bombay</strong> (CPI 9.2/10, with a Minor in Computer Science), hoping to spend July-August 2026 contributing to research in your group, on-site at &lt;University&gt; or remotely.</p>
<p>My interests lie at the intersection of machine learning and hardware. Your work on ML for physical design and EDA is exactly the area my recent projects sit in. Recently, I have worked on:</p>
<ul>
  <li><strong>RTL-to-GDSII Accelerator</strong> - took a custom accelerator from RTL through a full open-source physical-design flow, with post-layout timing and power analysis.</li>
  <li><strong>Standard-Cell Library Design</strong> - built DRC/LVS-clean cells, ran parasitic extraction, and generated timing and layout models for automated place-and-route.</li>
  <li><strong>Masked Graph Autoencoder</strong> - a self-supervised graph model with centrality-aware masking, directly relevant to learning on circuit graphs.</li>
</ul>
<p>I also interned last summer as a Quantitative Research Intern at &lt;Company&gt;, building ML forecasting models over large datasets.</p>
<p>Given this background, I was wondering whether there might be an <strong>opportunity to join your group for a research internship</strong> during July-August 2026, whether on-site or remotely. I would be glad to contribute to any ongoing project aligned with these interests.</p>
<p>My CV and transcript are attached. Thank you for your time and consideration.</p>
<p>Best regards,<br><strong>Riya Menon</strong><br><strong>IIT Bombay</strong></p>
<p><a href="https://www.linkedin.com/in/your-handle">LinkedIn</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="https://github.com/your-handle">GitHub</a></p>
```

**What to notice across A–D:** the greeting, degree line, sign-off, ask paragraph, and signature stay **identical**; only the `interest_areas`, the one-sentence `hook`, and the **three bullets (reordered most-relevant-first)** change per professor. Example D also swaps the degree line's emphasis and CV variant for a hardware group. Keep every bullet real — these are placeholders showing *shape*, not content to copy verbatim.

## Hook patterns (one sentence, names their real work)
- "Your work on **<their topic>** is exactly the area my recent projects sit in."
- "Your work on **<their specific paper/system>** is close to the direction I want to pursue."
- "Your group's work on **<their line>** maps directly onto my interest in **<applicant angle>**."

## Content rules
- **Three bullets, all real.** Pull them from your actual CV (SKILL.md Step 3). Reorder so the **most relevant-to-that-professor** project is first. Never invent or inflate a result.
- Pick the CV variant whose `use_for` matches the professor's field (see `applicant-config.md` §3), and tailor the bullets to that CV.
- Honour `must_not_mention` and `project_naming` from the config.
- ~150–220 words. No buzzword stuffing.
- Match your real credentials exactly (CPI, grad year, dates). Never inflate.

## Follow-up (no reply after ~1 week — reply on the same thread, short)
```
Dear Prof. <LastName>,
I hope you are doing well. I am writing to gently follow up on my email from <date> about a possible research internship in your group during <dates>.
I remain very interested in your work on <topic>, and would be glad to contribute to any ongoing project.
If it would help, I am happy to share any additional information to assess fit.
Thank you again for your time and consideration.
Best regards,
<full_name>
<institute>
```
