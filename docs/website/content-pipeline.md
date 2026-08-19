# The Beauty Truth Content Pipeline

## Purpose

This workflow creates evidence-informed Beauty Truth website content with four specialized Codex agents while preserving Lauren's editorial control. The agents handle distinct SEO, scientific research, writing, and claims-review responsibilities. The main Codex task coordinates their handoffs, saves every stage as a project artifact, and stops for Lauren's explicit approval.

The pipeline does not publish, schedule, or draft content in WordPress. Publishing is a separate workflow that requires separate authorization.

## Activation Rule

The pipeline runs only when Lauren clearly asks to use or run the Beauty Truth content pipeline for a topic. For example:

> Run the Beauty Truth content pipeline for: Do peptides in skincare actually work?

A normal request to brainstorm, research, outline, review, or write something does not automatically activate the pipeline. If Lauren's wording is genuinely ambiguous, the main Codex task must confirm whether she wants the complete pipeline before delegating.

## Pipeline Overview

```text
Topic/Opportunity
      ↓
SEO Researcher
      ↓
SEO Brief
      ↓
Evidence Researcher
      ↓
Evidence Brief
      ↓
Beauty Truth Writer
      ↓
Working Draft
      ↓
Claims Reviewer
      ↓
Revision Loop if Needed
      ↓
Lauren Human Review
      ↓
Final Editorial Draft
      ↓
Separate WordPress Publishing Workflow
```

The four configured agent names are:

- `seo_researcher`
- `evidence_researcher`
- `beauty_truth_writer`
- `claims_reviewer`

The main Codex task is the coordinator. No fifth orchestrator agent is required.

## Workflow States

These states must remain distinct:

- **Researched:** The required SEO and evidence research is complete and saved.
- **Drafted:** A working draft is complete and saved, but has not necessarily passed Claims Review.
- **Claims Reviewed:** The Claims Reviewer has issued a saved decision and any required corrections have been resolved. This does not mean Lauren approved the article.
- **Human Approved:** Lauren explicitly approved the editorial content. This does not mean the article was published.
- **Published:** A separately authorized publishing workflow placed the content on the live website.

Never use `Claims Reviewed`, `Human Approved`, and `Published` as synonyms.

## Coordinator Responsibilities

For every pipeline run, the main Codex task must:

1. Read `AGENTS.md`, this runbook, relevant website documentation, and any existing status file and artifacts.
2. Create or confirm a normalized topic slug and the per-article pipeline directory.
3. Create or update the human-readable `pipeline-status.md` file.
4. Delegate each required stage to the correct existing agent with the exact upstream artifacts it needs.
5. Save each agent's complete output as the expected artifact before starting the next stage.
6. Verify each stage's exit criteria rather than treating agent completion as automatic approval.
7. Route revisions according to the Claims Review decision and issue type.
8. Preserve prior artifacts and revision history instead of silently overwriting them.
9. Stop for Lauren whenever her input or approval is required.
10. Keep WordPress and all production actions outside this pipeline.

The `seo_researcher`, `evidence_researcher`, and `claims_reviewer` agents are configured as read-only. They return their work to the main Codex task, which saves that output to the designated artifact without changing its substantive findings. The main task also verifies that the Writer's output is saved in the correct location.

## Stage 0 — Pipeline Request

### What Lauren can provide

Lauren may start a run with any clear content opportunity, including:

- A specific topic.
- A question consumers ask.
- An existing article that needs updating.
- An SEO opportunity.
- A misinformation or trend topic.
- A product-education question.

Lauren does not need to provide keywords, an article structure, scientific sources, citations, or a finished content brief. Those are pipeline outputs.

Helpful optional context includes the intended audience, an existing Beauty Truth URL or file, a concern she wants addressed, a deadline, and any personal perspective she already wants incorporated.

### Coordinator actions

Before delegating, the main Codex task must:

1. Confirm that Lauren explicitly requested the pipeline.
2. Identify the topic and whether this is new content or an update.
3. Create a stable lowercase, hyphen-separated slug, such as `do-peptides-work`. Avoid dates and temporary wording unless they are essential to the topic.
4. Check whether `docs/website/pipeline/<topic-slug>/` or related research/content already exists.
5. If a status file exists, resume from it rather than beginning again.
6. If no run exists, create the pipeline directory and `pipeline-status.md` before Stage 1.

### Exit criteria

- The topic and slug are unambiguous.
- Existing overlapping pipeline work has been identified.
- The status file exists and points to any known inputs.
- The run is ready for SEO research.

## Stage 1 — SEO Research

**Agent:** `seo_researcher`

### Required inputs

- Lauren's topic or opportunity.
- Whether the task is new content or an update.
- `AGENTS.md`.
- `docs/website/README.md`.
- `docs/website/research/current-site-audit.md` when relevant.
- Relevant existing Beauty Truth research and content.
- The per-article `pipeline-status.md`.

### Tasks

The SEO Researcher should determine:

- The primary reader and search intent.
- Existing Beauty Truth content overlap or possible cannibalization.
- The content gap or update opportunity.
- The questions a useful article should answer.
- The topic's possible role in a broader topical cluster.
- Internal-link opportunities to and from verified existing content.
- Future-app alignment when it is natural and relevant.
- Known limitations in keyword, ranking, analytics, or competitor data.

The SEO Researcher may use qualitative search evidence and verified data that is actually available. It must not invent search volume, keyword difficulty, competition scores, rankings, traffic, or analytics.

### Expected output

Save the complete SEO brief as:

`docs/website/pipeline/<topic-slug>/01-seo-brief.md`

The brief should include the proposed content role, primary intent, audience questions, overlap findings, internal-link opportunities, limitations, and recommended next step. It should clearly separate confirmed observations from interpretations and unknowns.

### Exit criteria

- The reader intent and content opportunity are clear enough to frame a scientific research question.
- Existing content overlap has been checked.
- Unsupported quantitative SEO claims are absent.
- Limitations are explicit.
- The artifact is saved and linked from `pipeline-status.md`.

If the SEO stage finds that the proposed article would duplicate existing content or does not justify a standalone article, the coordinator must stop or propose an update path to Lauren rather than forcing the topic into the remaining stages.

## Stage 2 — Evidence Research

**Agent:** `evidence_researcher`

### Required inputs

- Lauren's original topic or question.
- `01-seo-brief.md`.
- `AGENTS.md`.
- Relevant Beauty Truth research and existing content.
- Any specific scientific questions or claims identified during SEO research.

### Tasks

The Evidence Researcher must:

- Turn the reader need into answerable scientific and dermatologic research questions.
- Locate and actually review credible sources.
- Verify citation identities, titles, authors, publication details, DOI or stable URL, and accessible source content.
- Classify conclusions by evidence strength.
- Separate established evidence from uncertain, conflicting, emerging, mechanistic, or unsupported claims.
- Record important limitations, population differences, study design concerns, and generalizability limits.
- Record funding, manufacturer involvement, and conflicts when relevant and available.
- Define the medical and regulatory boundary.
- Distinguish ingredient biology from finished-formulation performance.
- Identify claims the Writer must avoid or qualify.
- Actively look for credible contradictory evidence and alternative explanations.

### Evidence and source standards

Prefer sources in this order when they are relevant:

1. Systematic reviews and meta-analyses.
2. Peer-reviewed clinical studies.
3. Peer-reviewed scientific reviews.
4. Dermatology or medical professional organizations.
5. Government or regulatory sources.
6. Academic medical centers.
7. High-quality formulation or cosmetic-science sources.

Marketing pages, retailers, influencers, social media, and unsourced skincare sites are not scientific evidence. Abstract-only access must be disclosed. Mechanistic, in vitro, ex vivo, animal, disease-specific, product-specific, or manufacturer-sponsored evidence must not be generalized beyond what it supports.

### Expected output

Save the complete evidence brief as:

`docs/website/pipeline/<topic-slug>/02-evidence-brief.md`

The brief must use the Evidence Researcher's configured structure and preserve citation details, evidence-strength labels, limitations, conflicts, medical boundaries, formulation considerations, and unresolved questions.

### Exit criteria

- Important sources have been verified and are traceable.
- Evidence strength and uncertainty are explicit.
- Citation, formulation, medical, and generalizability boundaries are documented.
- The brief states what the Writer can responsibly teach.
- The artifact is saved and linked from `pipeline-status.md`.
- The evidence is adequate for the proposed premise, or the brief clearly explains why it is not.

The evidence brief becomes the scientific boundary for the Writer. If the evidence cannot responsibly support the premise, the coordinator must stop and report that conclusion to Lauren rather than asking the Writer to make the article sound more certain.

## Stage 3 — Drafting

**Agent:** `beauty_truth_writer`

### Required inputs

- Lauren's topic and supplied context.
- `01-seo-brief.md`.
- An adequate `02-evidence-brief.md`.
- `AGENTS.md` and this runbook.
- Relevant existing Beauty Truth content.
- Any actual professional or personal input Lauren has already supplied.

The Writer must not draft substantive evidence-based skincare content if the evidence brief is missing, inadequate, or not clearly associated with the topic.

### Tasks

The Writer must:

- Answer the primary reader intent early.
- Translate the evidence into clear, useful Beauty Truth education.
- Preserve the evidence brief's level of certainty and important limitations.
- Follow the Beauty Truth voice and explain why the information matters.
- Avoid converting ingredient biology into finished-product efficacy.
- Avoid invented sources, facts, statistics, recommendations, or personal experience.
- Preserve specific `[LAUREN INPUT: ...]` placeholders where Lauren's expertise is genuinely needed.
- Recommend SEO title, meta description, URL slug, and other relevant publishing fields without keyword stuffing.
- Recommend internal links only to verified or clearly marked-to-verify Beauty Truth content.
- Include source notes that let the Claims Reviewer trace important claims to the evidence brief.

### Expected output

Save the working draft as:

`docs/website/pipeline/<topic-slug>/03-draft.md`

The draft artifact should contain:

- A clear status stating that it is a working draft and is not approved for publication.
- The article draft.
- SEO recommendations.
- Internal-link recommendations.
- Source notes for Claims Review.
- Any `[LAUREN INPUT: ...]` placeholders.
- Known uncertainties or questions for the Claims Reviewer.

### Exit criteria

- The article answers the documented intent.
- Its important scientific claims stay within the evidence brief.
- Required source notes are traceable.
- Lauren's experience has not been invented.
- SEO and internal-link recommendations are included.
- The artifact is saved and linked from `pipeline-status.md`.
- The draft is ready for independent Claims Review, not publication.

## Stage 4 — Claims Review

**Agent:** `claims_reviewer`

### Required inputs

- `AGENTS.md` and this runbook.
- `01-seo-brief.md`.
- The current `02-evidence-brief.md` or its latest revision.
- The current `03-draft.md` or its latest revision.
- The draft's source notes.
- Relevant existing Beauty Truth content when available.

### Tasks

The Claims Reviewer must independently compare the draft with the evidence rather than trusting the Writer's interpretation. It must review scientific, medical, regulatory, logical, citation, formulation, generalizability, reader-impression, SEO, and Lauren-expertise boundaries.

Every finding must use one configured severity:

- **BLOCKER:** Must be corrected before publication.
- **MAJOR:** Could materially mislead readers or weaken scientific credibility.
- **MINOR:** A limited precision or context problem worth correcting.
- **NOTE:** An optional editorial observation for human consideration.

The decision must be exactly one of:

- `PASS`
- `PASS WITH MINOR REVISIONS`
- `REVISE AND RESUBMIT`
- `DO NOT PUBLISH`

### Expected output

The coordinator must save the complete Claims Review Report as:

`docs/website/pipeline/<topic-slug>/04-claims-review.md`

The Claims Reviewer is read-only, so the main Codex task is responsible for saving its returned report as a separate artifact without rewriting or softening the findings.

This saved report is mandatory for every future pipeline run. A review that exists only in chat does not satisfy the pipeline requirements.

### Exit criteria

- The report contains every required section from the Claims Reviewer configuration.
- Important claims have been compared with the evidence brief and traceable sources.
- The report gives one valid decision.
- Required corrections and routing are unambiguous.
- The artifact and decision are recorded in `pipeline-status.md`.

## Stage 5 — Revision Routing

Use targeted revisions whenever they can fully resolve the findings. Do not order a full rewrite merely because a narrow correction is needed.

### Decision routing

- **`PASS`:** Mark Claims Review complete and advance to Lauren's human review.
- **`PASS WITH MINOR REVISIONS`:** Send each narrowly scoped correction to the appropriate agent, save revision notes, and verify that every required item is resolved before advancing. Rerun Claims Review if a correction changes scientific or medical meaning; a purely mechanical or normal voice correction does not require a full new review.
- **`REVISE AND RESUBMIT`:** Route the work to the Writer and/or Evidence Researcher, save revised artifacts, and rerun the Claims Reviewer. Do not advance until the corrected draft receives a passing decision.
- **`DO NOT PUBLISH`:** Stop the pipeline, record the reason, and report it to Lauren. Do not attempt to rescue the article by silently changing the premise or weakening uncertainty.

### Citation or evidence issue

Return the affected question to the Evidence Researcher. Examples include an incorrect citation, unverified source, unsupported statistic, missing conflict disclosure, questionable interpretation, inadequate evidence, or a claim that requires research beyond the current brief.

### Scientific wording changed because evidence changed

Route in this order:

`Evidence Researcher → Writer → Claims Reviewer`

Save the revised evidence brief, revised draft, and new Claims Review Report as separate revision artifacts.

### Writing, clarity, or voice issue with adequate evidence

Return the affected passage to the Writer with the Claims Review finding and its evidentiary boundary. The Writer should change only what is necessary unless the issue genuinely affects the broader structure.

### Minor formatting or editorial issue

Make or delegate a narrowly scoped correction and document it in revision notes. Do not use a minor formatting issue as permission to rewrite unrelated copy.

### New BLOCKER or MAJOR claim issue

Do not advance. Route it to the appropriate agent and rerun Claims Review after correction.

### Revision artifact names

Do not overwrite the artifact that was reviewed. For the first revision round, use names such as:

- `02-evidence-brief-r2.md` when evidence changes.
- `03-draft-r2.md` when the draft changes.
- `04-claims-review-r2.md` for the next Claims Review.
- `05-revision-notes-r1.md` to map each finding to its resolution.

Use `r3`, `r4`, and so on for later rounds. `pipeline-status.md` must point to the current versions while retaining links to earlier artifacts.

## Stage 6 — Lauren Human Review

> **MANDATORY HUMAN APPROVAL GATE**
>
> The pipeline stops here and waits for Lauren. Claims-reviewed content is not human-approved content. No WordPress draft, schedule, publication, or production change may occur merely because Claims Review passed.

Lauren reviews:

- Brand voice and whether the article sounds like Beauty Truth.
- Practical usefulness for the reader.
- Professional perspective and whether she agrees with the framing.
- Every `[LAUREN INPUT: ...]` placeholder.
- SEO title and meta recommendations.
- Internal-link recommendations.
- Whether the article should advance, change direction, or be abandoned.

AI must not approve on Lauren's behalf. Silence, lack of objection, previous approval of another article, or a Claims Review pass does not count as approval.

Human review may result in:

- Explicit approval.
- Editorial revisions.
- Additional professional input.
- A return for evidence research.
- Abandoning the article.

If Lauren changes a scientific, medical, safety, regulatory, efficacy, or other meaningful factual claim, route the affected material back through Claims Review. If her edit requires new evidence, route it through the Evidence Researcher and Writer first. Normal voice edits that do not change meaning do not require another full Claims Review.

If a `[LAUREN INPUT: ...]` placeholder remains, finalization must wait. After Lauren supplies the input, review whether it introduces or changes a claim and route it accordingly.

Record Lauren's decision and the date in `pipeline-status.md`. Do not describe the article as `Human Approved` until she explicitly approves it.

## Stage 7 — Final Editorial Draft

After Lauren's explicit approval and resolution of any claim-changing edits, create:

`docs/website/pipeline/<topic-slug>/06-final.md`

The final file must clearly separate:

```text
PUBLICATION CONTENT
```

from:

```text
EDITORIAL / WORDPRESS NOTES — DO NOT PUBLISH
```

Internal notes may include:

- SEO title and meta description.
- URL slug.
- Internal-link instructions and URLs that still require verification.
- Backlink opportunities from existing articles.
- Citation implementation notes.
- Category and tag recommendations.
- Publication checklist and unresolved implementation details.

This stage produces a final editorial file only. It does not access WordPress, create a WordPress draft, schedule content, publish content, or authorize production changes.

## Required Artifact Structure

Use one folder per new article:

```text
docs/website/pipeline/<topic-slug>/
├── pipeline-status.md
├── 01-seo-brief.md
├── 02-evidence-brief.md
├── 03-draft.md
├── 04-claims-review.md
├── 05-revision-notes-r1.md      # only when revisions are needed
├── 02-evidence-brief-r2.md       # only when evidence is revised
├── 03-draft-r2.md                # only when the draft is revised
├── 04-claims-review-r2.md        # only when Claims Review is rerun
└── 06-final.md                   # only after Lauren's approval
```

Use a normalized lowercase, hyphen-separated topic slug. Once artifacts exist, do not casually rename the slug because the status file and artifact links depend on it.

### Relationship to the existing folders

- `docs/website/research/` remains the home for existing and cross-topic research, site audits, and legacy research artifacts.
- `docs/website/content/` remains the home of the existing content artifacts and any legacy editorial files already stored there.
- `docs/website/pipeline/` becomes the complete, auditable home for future per-article runs.

Do not move or rename legacy files merely to match the new convention. A future run may cite a legacy research or content file from its status manifest instead of copying it. If a legacy article later re-enters the pipeline, create only a per-article status folder that links to the existing artifacts and add new revision artifacts there.

## Pipeline Status File

Every future article run requires:

`docs/website/pipeline/<topic-slug>/pipeline-status.md`

Use this human-readable template:

```markdown
# Pipeline Status: [Topic]

- **Topic:** [Full topic]
- **Slug:** [topic-slug]
- **Content type:** [New article / Existing article update]
- **Current stage:** [Stage number and name]
- **Overall state:** [Requested / Researched / Drafted / Claims Reviewed / Human Approved / Published / Stopped]
- **Claims Review decision:** [Not run / PASS / PASS WITH MINOR REVISIONS / REVISE AND RESUBMIT / DO NOT PUBLISH]
- **Lauren input required:** [No / Yes — describe the exact input]
- **Human approval:** [Pending / Approved on YYYY-MM-DD / Changes requested / Abandoned]
- **Publication status:** [Not started / Not authorized / Published separately on YYYY-MM-DD]
- **Last updated:** [YYYY-MM-DD HH:MM America/New_York]

## Stage Status

| Stage | Status | Current artifact | Decision or notes |
|---|---|---|---|
| 0. Request | Complete | `pipeline-status.md` | [Notes] |
| 1. SEO Research | Not started | — | — |
| 2. Evidence Research | Not started | — | — |
| 3. Drafting | Not started | — | — |
| 4. Claims Review | Not started | — | — |
| 5. Revisions | Not needed | — | — |
| 6. Lauren Human Review | Pending | — | Mandatory stop |
| 7. Final Editorial Draft | Not started | — | Requires Lauren approval |

## Artifact History

- [Add every artifact path in creation order. Do not remove superseded versions.]

## Resume Instructions

- [Record the exact next safe action and any blocker.]
```

Allowed stage-status values are `Not started`, `In progress`, `Complete`, `Needs revision`, `Blocked`, `Failed`, `Not needed`, and `Abandoned`.

Update the status file when a stage starts, completes, fails, becomes stale, or changes route. The latest artifact paths and the exact next safe action must always be clear enough that a new Codex chat can resume without guessing.

Publication should normally remain `Not authorized` when the content pipeline finishes. Only a separate, explicitly authorized publishing workflow may change it to `Published`.

## Claims Review Artifact Requirement

Every future Claims Review Report must be saved to the project. The minimum required artifact is `04-claims-review.md`; every rerun must receive its own revision suffix.

The coordinator must not summarize away the Claims Reviewer's findings and treat the summary as the report. Save the complete structured report, then use `05-revision-notes-r1.md` or later revision notes to show how each required correction was resolved.

## Restart and Recovery

The recovery rule is simple:

> Read `pipeline-status.md` and every existing artifact before taking action. Never assume a stage needs to be rerun.

### A run stops halfway through

- Read the status file and artifact history.
- Verify that the latest listed artifact exists and appears complete.
- Resume at the documented next safe action.
- If the status file and artifacts disagree, stop and reconcile the discrepancy before delegating.

### A chat closes

- Start from the repository root.
- Read `AGENTS.md`, this runbook, the topic's status file, and its current artifacts.
- Continue only the incomplete or required revision stage.
- Do not rerun completed research merely because the original chat is unavailable.

### An agent fails or returns incomplete output

- Mark the stage `Failed` or `Blocked` and record what is missing.
- Preserve any useful partial output as a clearly labeled failure or partial artifact when it may help recovery.
- Retry only the failed stage with the same upstream inputs unless those inputs were the cause.
- Do not send partial or unverified output downstream.

### An output file already exists

- Do not overwrite it automatically.
- Check the status file to determine whether it is current, partial, stale, or superseded.
- Use the next revision suffix when producing a new version.
- If ownership or state is unclear, stop and ask Lauren rather than guessing.

### Evidence changes after drafting

- Save a revised evidence brief with a revision suffix.
- Mark the current draft and Claims Review as stale in the status file.
- Send the affected evidence and passages to the Writer.
- Save the revised draft and rerun Claims Review.

### Lauren requests a revision after approval

- Change human approval to `Changes requested` while the revision is active.
- Preserve the previously approved final artifact.
- Save the revision as a new artifact rather than silently replacing the approved file.
- Route scientific or medical changes through Evidence Research when needed and Claims Review before asking Lauren to approve again.
- Normal voice edits may proceed without a full Claims Review if they do not change meaning, but Lauren must approve the revised final version.

## Human Approval Gate

> **STOP: CLAIMS REVIEWED DOES NOT MEAN APPROVED OR PUBLISHED.**
>
> When the article is ready for Lauren, the main Codex task must report the current decision, artifact paths, unresolved notes, and any `[LAUREN INPUT: ...]` requests, then wait. It may not enter WordPress or begin a publishing workflow without a new, explicit authorization.

The pipeline can prepare publication notes inside `06-final.md` after Lauren approves. Those notes are not permission to publish.

## Existing Ceramide Article

The completed ceramide workflow is the reference example for this MVP and remains in its current locations:

- Supporting site audit: `docs/website/research/current-site-audit.md`
- SEO opportunity research: `docs/website/research/skin-barrier-seo-opportunities.md`
- Evidence brief: `docs/website/research/ceramides-barrier-repair-evidence.md`
- Working draft: `docs/website/content/ceramides-skin-barrier-draft.md`
- Final editorial article: `docs/website/content/ceramides-skin-barrier-final.md`

It maps to the new stages as follows:

| New stage | Existing ceramide artifact |
|---|---|
| SEO Research | `skin-barrier-seo-opportunities.md` plus `current-site-audit.md` |
| Evidence Research | `ceramides-barrier-repair-evidence.md` |
| Drafting | `ceramides-skin-barrier-draft.md` |
| Claims Review | No standalone report was saved |
| Human input and final editorial draft | `ceramides-skin-barrier-final.md` |

The missing standalone ceramide Claims Review Report is a known audit-trail gap. Future runs correct this by saving every review artifact. This MVP does not recreate that historical report, create a retroactive status file, or move, rename, or rewrite any ceramide file.

If the ceramide article later needs another pipeline revision, create `docs/website/pipeline/do-ceramides-repair-skin-barrier/pipeline-status.md`, link to the legacy artifacts above, and save only new work in that folder.

## Future Automation

This MVP uses the main Codex task to coordinate the four existing agents. It deliberately does not add an orchestrator agent, database, script, scheduled task, cron job, external automation, or WordPress publishing automation.

The documented workflow should be tested across several more Beauty Truth articles first. Later automation should solve observed reliability problems rather than add complexity in anticipation of them.

## Pre-Run and Completion Checklist

Before or during each run, the coordinator must confirm:

- The four agent names exactly match `seo_researcher`, `evidence_researcher`, `beauty_truth_writer`, and `claims_reviewer`.
- The main Codex task is coordinating; no fifth agent is required.
- Every completed stage has a saved, separately named artifact.
- The Claims Review Report is saved rather than left only in chat.
- `pipeline-status.md` identifies the current stage and next safe action.
- Required upstream artifacts are complete before downstream delegation.
- Lauren's approval remains a mandatory stop.
- WordPress access and publishing remain outside the pipeline.
- Existing ceramide files remain intact.

## Known MVP Limitations

- This is documented coordination, not unattended background automation. A Codex task must still interpret the request, delegate each stage, save outputs, and maintain status.
- The quality of a run depends on agents receiving the correct, current artifact paths. The main task must verify those paths at every handoff.
- Claims-review routing still requires judgment when a finding mixes evidence and writing problems. When in doubt, resolve evidence integrity first, then return the bounded result to the Writer.
- Public website and keyword data may be incomplete. The SEO brief must disclose data limitations rather than manufacture precision.
- Human approval remains intentionally manual, and publishing remains intentionally separate.

These limitations do not prevent a reliable first test. A clear future request such as “Run the Beauty Truth content pipeline for [topic]” provides enough information to begin Stage 0, create the status artifact, and coordinate the four defined stages without requiring Lauren to design the research or article structure herself.
