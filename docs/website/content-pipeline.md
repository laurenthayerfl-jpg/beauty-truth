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

1. Read `AGENTS.md`, this runbook, relevant website documentation, any existing status file, and the current operative artifacts named there. Load superseded artifacts only for audit or targeted comparison when needed.
2. Create or confirm a normalized topic slug and the per-article pipeline directory.
3. Create or update the human-readable `pipeline-status.md` file.
4. Record lightweight stage telemetry when each stage starts, when the agent completes, and when the artifact is saved.
5. For an existing-article update, retrieve the production article once in read-only mode after the target URL is confirmed and preserve a reusable source snapshot.
6. For an existing-article update, enforce the Existing Article Preservation Gate, including the SEO Preservation Map, pre-draft broad-rewrite check, Writer Preservation Ledger, and separate Claims Reviewer preservation check.
7. Delegate each required stage to the correct existing agent with the current operative upstream artifacts it needs.
8. Save each agent's completed output directly as the expected artifact before starting the next stage.
9. Verify each stage's exit criteria rather than treating agent completion as automatic approval.
10. Route revisions according to the Claims Review decision and issue type, using a compact revision manifest.
11. Preserve prior artifacts and revision history instead of silently overwriting them.
12. Avoid making revision agents reread or regenerate large unchanged sections when a targeted correction is sufficient.
13. Stop for Lauren whenever her input or approval is required.
14. Keep WordPress and all production actions outside this pipeline.

The `seo_researcher`, `evidence_researcher`, and `claims_reviewer` agents are configured as read-only. All four specialists return their completed stage work to the main Codex task, which is responsible for saving each output directly to the designated artifact without changing its substantive findings or editorial meaning. The Writer's file permissions do not make the Writer a transport or persistence agent.

Do not invoke the Writer or any other specialist agent merely to transfer, chunk, persist, copy, or verify another agent's completed report. If a response is too large for one file operation, the coordinator may save it in local chunks while preserving exact order and content. Specialist-agent turns must represent substantive SEO, evidence, writing, or Claims Review work.

## Direct Artifact Persistence

When a specialist agent completes a stage:

1. Record the agent-completion time in `pipeline-status.md`.
2. Save the returned output directly to the expected artifact. Do not summarize away required content and do not route the output through another agent.
3. Verify that the file exists, is complete, and has the expected heading or decision.
4. Record the artifact-save completion time.
5. Only then start the dependent downstream stage.

Content verification belongs to the appropriate specialist and required review stage. Coordinator file checks should confirm persistence and routing integrity, not repeat the specialist's substantive analysis.

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
7. If this is an update and the exact existing article is already known, retrieve it once in read-only mode and save `00-existing-article-snapshot.md`. If Stage 1 first identifies the update target, preserve the article representation obtained during that first retrieval as the snapshot when adequate; otherwise retrieve it once immediately after the decision. Save the snapshot before downstream stages reuse the article.

### Existing-article source snapshot

For an update workflow, `00-existing-article-snapshot.md` must record:

- The article title and exact public URL.
- Retrieval date and time in `America/New_York`.
- That retrieval was public and read-only; no WordPress login or administration area was used.
- The retrieved article body or the fullest reliable representation available.
- Any retrieval limitation, missing section, redirect, error, or uncertainty.

SEO Research, the Writer, and the Claims Reviewer should reuse this snapshot when it is adequate for content overlap, drafting, and old-to-new fidelity review. Do not repeatedly crawl the same production article merely to give each stage a separate copy. A later live recheck is appropriate only when the snapshot is missing, incomplete, materially stale, or a specific implementation or review question requires current public state; record the reason for the recheck.

The Claims Reviewer remains free to independently verify external scientific, medical, regulatory, and bibliographic sources. Reusing the Beauty Truth article snapshot does not limit that independence.

### Existing Article Preservation Gate

Apply this gate whenever `Content type` is `Existing article update`. It does not apply to a new-article workflow.

The saved existing-article snapshot is the default base text. The Writer must edit the existing article rather than draft a replacement from a blank page. Existing language remains unless a stage documents a reason to change it for scientific accuracy, citation integrity, medical or regulatory safety, obsolete or incorrect information, duplicated or broken content, a genuine search-intent or structural need, a specific readability problem, or explicit Lauren instruction. Calling an assignment a `substantial update` never grants blanket permission for a wholesale rewrite.

Treat existing published Lauren-attributed material as supplied source content. Preserve, where reasonably possible:

- Hooks and transitions.
- Analogies and nonfactual examples.
- Section titles and memorable phrasing.
- First-person language and brand framing.
- Professional observations already present.
- Concise closing lines.

If protected language contains an unsupported claim, repair the claim as narrowly as practical while retaining the safe expression around it. This protection never permits inventing, extending, or falsely attributing Lauren's experience.

The gate is implemented inside the existing four stages:

1. SEO Research creates the Existing Article Preservation Map.
2. Evidence Research identifies the exact factual claims that require repair and the safe surrounding prose that can remain.
3. The Writer edits the snapshot under the map and produces an internal Preservation Ledger.
4. The Claims Reviewer performs a separate preservation check in addition to scientific Claims Review.

No new agent or pipeline stage is created.

### Exit criteria

- The topic and slug are unambiguous.
- Existing overlapping pipeline work has been identified.
- The status file exists and points to any known inputs.
- For a known update target, the existing-article snapshot exists or a retrieval limitation is recorded.
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
- `00-existing-article-snapshot.md` when the topic is a confirmed update and the snapshot is available.

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

For an update, use the saved article snapshot for article-body and overlap analysis when it is adequate. Do not refetch the same production article solely because SEO is a separate stage. If SEO first discovers the update target and no snapshot exists, return the article title, URL, retrieval time, retrieved body or fullest reliable representation, and any retrieval limitations as a separately identified snapshot payload so the coordinator can save that first retrieval as `00-existing-article-snapshot.md`.

For an existing-article update, the SEO brief must also contain an **Existing Article Preservation Map**. Account for every meaningful original content block by heading, stable label, or recognizable opening words and assign exactly one primary disposition:

| Disposition | Meaning |
|---|---|
| `KEEP VERBATIM` | Accurate, useful material remains unchanged. |
| `LIGHT EDIT` | A bounded, recognizable edit is needed for readability, precision, or integration. |
| `CLAIM REPAIR — EVIDENCE` | A specific factual claim requires evidence-led removal, narrowing, qualification, replacement, or stronger support. |
| `MOVE — SEO/STRUCTURE` | Useful material changes location for reader intent or structure; moving does not authorize rewriting. |
| `REMOVE — DEFECT` | A stated defect justifies removal, such as duplication, broken content, obsolete or incorrect information, or a medical/regulatory safety problem. |
| `ADD — EVIDENCE/SEARCH` | New material fills a stated evidence or search-intent gap. |
| `LAUREN DECISION` | The disposition or rewrite scope cannot be resolved from the evidence, permitted change reasons, and Lauren's existing instructions; use this especially when a proposed change to protected expression lacks another valid reason. |

Default to preserving accurate, useful supported material. Distinguish material that genuinely needs correction from material that only needs moving, genuinely new information required for search intent, and existing Lauren-authored material that is already useful and accurate. SEO architecture recommendations do not authorize copy replacement.

Add a `BROAD-REWRITE WARNING` when the map suggests that a large portion of meaningful original content may require substantive replacement, or protected Lauren-authored material may be removed without an evidence, accuracy, safety, defect-correction, or explicit-Lauren reason. About 40% is a practical warning signal, not a rigid calculation. Do not count duplicated text, subscriber residue, broken markup, formatting cleanup, typo correction, or citation insertion. Identify the affected blocks and reasons.

### Expected output

Save the complete SEO brief as:

`docs/website/pipeline/<topic-slug>/01-seo-brief.md`

The brief should include the proposed content role, primary intent, audience questions, overlap findings, internal-link opportunities, limitations, and recommended next step. It should clearly separate confirmed observations from interpretations and unknowns. For an existing-article update, it must also include the complete Existing Article Preservation Map and any broad-rewrite warning.

### Exit criteria

- The reader intent and content opportunity are clear enough to frame a scientific research question.
- Existing content overlap has been checked.
- For an existing-article update, every meaningful original block is accounted for in the Preservation Map with a reasoned disposition.
- For an existing-article update, protected Lauren-authored expression is identified where present, and any possible broad rewrite is flagged without treating SEO structure as rewriting authority.
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
- For an existing-article update, `00-existing-article-snapshot.md` and the Existing Article Preservation Map inside `01-seo-brief.md`.

### Tasks

The Evidence Researcher must:

- Turn the reader need into answerable scientific and dermatologic research questions.
- Locate and actually review credible sources.
- Apply the Evidence Researcher's Citation-Integrity Gate to every source supporting a material claim before treating it as approved evidence.
- Classify conclusions by evidence strength.
- Separate established evidence from uncertain, conflicting, emerging, mechanistic, or unsupported claims.
- Record important limitations, population differences, study design concerns, and generalizability limits.
- Record funding, manufacturer involvement, and conflicts when relevant and available.
- Define the medical and regulatory boundary.
- Distinguish ingredient biology from finished-formulation performance.
- Identify claims the Writer must avoid or qualify.
- Actively look for credible contradictory evidence and alternative explanations.
- For an existing-article update, map every factual block marked `CLAIM REPAIR — EVIDENCE`, `REMOVE — DEFECT`, or otherwise questioned on evidence grounds to the exact claim requiring removal, narrowing, qualification, replacement, or new evidence.
- For an existing-article update, identify scientifically safe surrounding prose that can remain where practical; one defective claim does not automatically justify replacing its entire paragraph.

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

### Hard citation-identity gate

For every source supporting a material scientific, medical, regulatory, safety, efficacy, formulation, or product-performance claim, the evidence artifact must record:

- A coherent identity appropriate to the source type: title, authors, journal, publisher or issuing organization, and publication year or page date where applicable. Mark a genuinely inapplicable field `N/A` and explain why.
- DOI resolution to the stated publication when a DOI exists.
- PMID resolution to the same publication when a PMID exists.
- Agreement among DOI, PMID, title, authors, publication, and year.
- Stable URL checked at research time.
- Actual access level: `full text`, `abstract`, `metadata only`, or a precisely described `other` form of access.
- Funding, manufacturer involvement, and conflicts when available; otherwise an explicit `unverified` status.
- The authoritative identity-verification record or records used.
- One citation status: `VERIFIED FOR CLAIM USE` or `UNRESOLVED — DO NOT USE FOR PUBLIC CLAIMS`.

Never combine plausible bibliographic fields from different records. If identifiers disagree, a link cannot be checked, or the source identity cannot be established, the source must be marked `UNRESOLVED — DO NOT USE FOR PUBLIC CLAIMS`. It may remain only as an explained research lead and must not support the Bottom Line, approved Writer guidance, or a public citation.

### Expected output

Save the complete evidence brief as:

`docs/website/pipeline/<topic-slug>/02-evidence-brief.md`

The brief must use the Evidence Researcher's configured structure and preserve citation details, citation status, identity-verification record, access level, evidence-strength labels, limitations, conflicts or explicit unverified status, medical boundaries, formulation considerations, and unresolved questions. For an existing-article update, `Implications for Beauty Truth` must include a concise claim-repair handoff identifying the affected original block, exact defective claim, required evidence action, and safe surrounding prose that can remain where practical.

### Exit criteria

- Every source supporting a material claim is marked `VERIFIED FOR CLAIM USE` and contains a coherent bibliographic identity, checked stable URL, explicit access level, and identity-verification record.
- Any unresolved or mismatched source is marked `UNRESOLVED — DO NOT USE FOR PUBLIC CLAIMS` and is excluded from the Bottom Line, approved Writer guidance, and public-claim support.
- Evidence strength and uncertainty are explicit.
- Citation, formulation, medical, and generalizability boundaries are documented.
- The brief states what the Writer can responsibly teach.
- For an existing-article update, every evidence-questioned original claim has a bounded repair instruction, and the brief does not use one bad claim to authorize unnecessary paragraph replacement.
- For an existing-article update, any evidence-driven expansion of the possible rewrite scope is flagged for the coordinator.
- The artifact is saved and linked from `pipeline-status.md`.
- The evidence is adequate for the proposed premise, or the brief clearly explains why it is not.

The evidence brief becomes the scientific boundary for the Writer. If the evidence cannot responsibly support the premise, the coordinator must stop and report that conclusion to Lauren rather than asking the Writer to make the article sound more certain.

### Pre-draft broad-rewrite escalation for updates

After Stage 2 and before delegating Stage 3 for an existing-article update, the coordinator must compare the SEO Preservation Map with the Evidence Researcher claim-repair handoff.

Stop before drafting and ask Lauren to approve the proposed rewrite scope when either condition applies:

- A large portion of meaningful original content appears to require substantive replacement.
- Distinctive Lauren-authored material would be removed for a reason other than evidence, accuracy, safety, defect correction, or explicit Lauren instruction.

About 40% of meaningful original content is a practical warning signal, not an inflexible mathematical rule. Exclude duplicated text, subscriber residue, broken markup, formatting cleanup, typo correction, and citation insertion from the assessment. Use editorial judgment and name the affected blocks and reasons.

Record one of these outcomes in `pipeline-status.md`:

- `Not triggered`.
- `Pending Lauren scope approval — drafting blocked`.
- `Approved by Lauren on YYYY-MM-DD — [bounded scope]`.

An unresolved `LAUREN DECISION` affecting rewrite scope also blocks Stage 3. This is advance approval of rewrite scope only; it does not replace Claims Review or Lauren's mandatory final human approval.

## Stage 3 — Drafting

**Agent:** `beauty_truth_writer`

### Required inputs

- Lauren's topic and supplied context.
- `01-seo-brief.md`.
- An adequate `02-evidence-brief.md`.
- `AGENTS.md` and this runbook.
- Relevant existing Beauty Truth content.
- `00-existing-article-snapshot.md` for an update workflow.
- The Existing Article Preservation Map in `01-seo-brief.md` and the existing-claim repair handoff in the operative evidence brief for an update workflow.
- The recorded broad-rewrite outcome and Lauren's advance scope approval when that warning was triggered.
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
- Include concise claim-to-source notes that let the Claims Reviewer trace material claims to the operative evidence brief without reproducing that brief.

For an existing-article update, the Writer must also:

1. Start from the saved article snapshot rather than a blank page.
2. Follow the SEO Preservation Map.
3. Keep `KEEP VERBATIM` material intact.
4. Keep `LIGHT EDIT` changes bounded and recognizable.
5. Repair only the portions identified as scientifically or editorially defective.
6. Move existing material when structure changes rather than rewriting it unnecessarily.
7. Add new evidence or search material around retained copy.
8. Avoid rewriting supported language merely to make the entire article stylistically uniform.
9. Preserve distinctive Lauren-authored hooks, transitions, analogies, headings, memorable phrasing, first-person language, framing, nonfactual examples, existing professional observations, and concise closing lines unless a documented reason permits a change.
10. Produce an internal Preservation Ledger accounting for every major original block.

If the supplied map, evidence handoff, or Writer's own faithful application of them reveals a broad-rewrite warning that lacks Lauren's recorded advance scope approval, the Writer must stop without drafting and return the unresolved scope to the coordinator.

### Expected output

Save the working draft as:

`docs/website/pipeline/<topic-slug>/03-draft.md`

The draft artifact should contain:

- A clear status stating that it is a working draft and is not approved for publication.
- Complete publication content.
- Concise SEO and editorial recommendations.
- Concise internal-link recommendations.
- Concise claim-to-source traceability for material claims, normally mapped to evidence-brief source numbers or verified citations.
- Any `[LAUREN INPUT: ...]` placeholders.
- Material uncertainties or specific questions for the Claims Reviewer.
- For an existing-article update, a concise internal Preservation Ledger, clearly separated from publication content and using this structure:

  | Original block | Final location | Disposition | Reason |
  |---|---|---|---|

  The ledger is an editorial audit tool and must not appear in publication content. It must use the configured Preservation Map dispositions, identify every major original block, and record any applicable Lauren scope approval.

The Writer artifact must not reproduce a second full evidence brief. Do not duplicate long source abstracts, the Evidence Researcher's complete limitation analysis, exhaustive lists of every claim not made, or large boundary tables when a concise reference to the operative evidence section is sufficient.

### Exit criteria

- The article answers the documented intent.
- Its important scientific claims stay within the evidence brief.
- Required source notes are traceable.
- The draft is lean enough that the Evidence Researcher artifact remains the single complete scientific record.
- Lauren's experience has not been invented.
- SEO and internal-link recommendations are included.
- For an existing-article update, every major original block is accounted for and the Preservation Ledger matches the actual draft.
- For an existing-article update, all `KEEP VERBATIM` and other required preserved material remains; `LIGHT EDIT` changes are bounded and recognizable.
- For an existing-article update, every substantive rewrite or removal has a documented valid reason, and scientifically safe surrounding prose was retained where practical.
- For an existing-article update, Lauren-authored framing and expression were not unnecessarily erased.
- For an existing-article update, any broad-rewrite warning received Lauren's advance scope approval before drafting.
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
- `00-existing-article-snapshot.md` for every update workflow.
- For an update workflow, the Existing Article Preservation Map, Writer Preservation Ledger, Evidence Researcher claim-repair handoff, and any broad-rewrite scope approval record.

### Tasks

The Claims Reviewer must independently compare the draft with the evidence rather than trusting the Writer's interpretation. It must review scientific, medical, regulatory, logical, citation, formulation, generalizability, reader-impression, SEO, and Lauren-expertise boundaries.

For an update workflow, use the saved existing-article snapshot for continuity and fidelity review when it is adequate. The Claims Reviewer may independently verify external scientific, medical, regulatory, safety, and bibliographic sources and may request a live article recheck when the saved snapshot is materially inadequate.

For an update workflow, the Claims Reviewer must also perform an **Existing-Content Preservation Check** that is separate from scientific Claims Review. It must answer:

1. Were unsupported claims corrected?
2. Was accurate existing prose unnecessarily replaced?
3. Were Lauren-attributed hooks, examples, framing, analogies, and voice preserved where possible?
4. Does every removal or substantive rewrite have a valid documented reason?
5. Did SEO restructuring accidentally become wholesale copy replacement?
6. If a broad rewrite occurred, was Lauren's advance scope approval recorded?

The Reviewer must verify that every major original block is accounted for and the Preservation Ledger matches the actual draft. A scientifically correct article can still fail this preservation check. Unauthorized substantial replacement of protected existing material is a `MAJOR` editorial issue. A higher severity applies only when the same change independently meets the configured criteria for that severity.

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

For an existing-article update, the report must include a clearly separate `Existing-Content Preservation Check` subsection answering all six questions, assessing ledger accuracy, identifying unauthorized removals or rewrites, and confirming any required scope approval. Do not collapse preservation into the scientific decision without reporting it.

### Exit criteria

- The report contains every required section from the Claims Reviewer configuration.
- Important claims have been compared with the evidence brief and traceable sources.
- For an existing-article update, the separate preservation check is complete, the ledger has been tested against the draft, and any preservation finding has an explicit severity and required correction.
- For an existing-article update, the draft cannot advance with an unresolved unauthorized substantial replacement of protected material.
- The report gives one valid decision.
- Required corrections and routing are unambiguous.
- The artifact and decision are recorded in `pipeline-status.md`.

## Stage 5 — Revision Routing

Use targeted revisions whenever they can fully resolve the findings. Do not order a full rewrite merely because a narrow correction is needed.

### Required revision manifest

Before delegating a revision, the coordinator must create a compact manifest such as `05-revision-notes-r1.md`. It is a routing document, not a second Claims Review Report.

Use this minimum structure:

```markdown
# Revision Manifest — Round [N]

| Finding | Severity | Responsible stage | Affected source, claim, or passage | Required correction | Scientific meaning changes? |
|---|---|---|---|---|---|
| [Claims Review ID or concise finding] | [BLOCKER / MAJOR / MINOR / NOTE] | [SEO Research / Evidence Research / Writer / Claims Review / Coordinator] | [Exact source, claim, heading, or passage] | [Bounded correction] | [Yes / No — explain briefly] |

## Operative Inputs

- Current evidence artifact: [path]
- Current draft artifact: [path]
- Claims Review report: [path]
- Existing-article snapshot, if applicable: [path]

## Required Route

- [Evidence Researcher → Writer → Claims Reviewer / Writer → Claims Reviewer / targeted non-claim editorial correction]
```

Each revision agent should receive the current operative artifact it must change, the Claims Review findings, and the revision manifest. Include other current artifacts only when they are necessary to understand the correction. Superseded artifacts remain available for audit and spot-checking, but revision agents should not automatically reread them in full.

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

Save the revised evidence brief, revised draft, and new Claims Review Report as separate revision artifacts. Scientific, medical, regulatory, safety, efficacy, or citation changes always require a new Claims Review after the affected draft is updated.

### Writing, clarity, or voice issue with adequate evidence

Return the affected passage to the Writer with the Claims Review finding and its evidentiary boundary. The Writer should change only what is necessary unless the issue genuinely affects the broader structure.

If the revision changes a substantive scientific, medical, regulatory, safety, efficacy, citation, formulation-performance, or other factual meaning, rerun Claims Review. If it is a normal voice, clarity, grammar, or formatting change that does not change meaning, follow the original decision's required review route and document the coordinator's verification in the manifest.

### Minor formatting or editorial issue

Make or delegate a narrowly scoped correction and document it in revision notes. Do not use a minor formatting issue as permission to rewrite unrelated copy.

### New BLOCKER or MAJOR claim issue

Do not advance. Route it to the appropriate agent and rerun Claims Review after correction.

### Targeted revision behavior

Preserve a complete audit trail without asking an agent to regenerate large unchanged sections.

- Ask the responsible specialist for only the corrected source records, conclusions, passages, metadata, or source mappings identified in the revision manifest.
- Create the next versioned artifact by preserving unchanged content and applying the specialist's returned corrections exactly. The coordinator may perform this mechanical persistence but must not alter scientific or editorial meaning.
- Keep unchanged sections unchanged where practical. A new revision filename does not require a new introduction, full source re-summary, exhaustive self-audit, or regenerated article body.
- The new versioned artifact must still be coherent and usable as the current operative artifact. Record in the manifest which sections changed and which prior conclusions remain unchanged.
- If the correction changes the article's premise, evidence strength, Bottom Line, medical boundary, regulatory boundary, safety guidance, efficacy conclusion, citation support, or another material claim, use `Evidence Researcher → Writer → Claims Reviewer` as applicable.
- If evidence remains adequate and only writing changes, route only to the Writer and the review step required by the original Claims Review decision and the meaning-change rules above.
- Never use targeted revision behavior to avoid Claims Review after a substantive scientific, medical, regulatory, safety, efficacy, or citation change.

### Revision artifact names

Do not overwrite the artifact that was reviewed. For the first revision round, use names such as:

- `02-evidence-brief-r2.md` when evidence changes.
- `03-draft-r2.md` when the draft changes.
- `04-claims-review-r2.md` for the next Claims Review.
- `05-revision-notes-r1.md` as the compact revision manifest mapping each finding to responsibility, affected content, required correction, meaning change, and route.

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
├── 00-existing-article-snapshot.md  # update workflows only
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
- **Existing-article rewrite scope:** [N/A / Not triggered / Pending Lauren scope approval — drafting blocked / Approved by Lauren on YYYY-MM-DD — bounded scope]
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

## Stage Telemetry

| Stage | Agent invoked | Pass type | External research | Stage started | Agent completed | Artifact saved |
|---|---|---|---|---|---|---|
| 0. Request | Main coordinator | Coordination | No | [YYYY-MM-DD HH:MM America/New_York] | N/A | [YYYY-MM-DD HH:MM America/New_York] |
| 1. SEO Research | `seo_researcher` | Original substantive | [Yes / No] | — | — | — |
| 2. Evidence Research | `evidence_researcher` | Original substantive | [Yes / No] | — | — | — |
| 3. Drafting | `beauty_truth_writer` | Original substantive | [Yes / No] | — | — | — |
| 4. Claims Review | `claims_reviewer` | Original substantive | [Yes / No] | — | — | — |
| 5. Revisions | [Agent name or Main coordinator] | Revision [N] substantive | [Yes / No] | — | — | — |
| 6. Lauren Human Review | Lauren / Main coordinator | Human review | No | — | N/A | — |

## Artifact History

- [Add every artifact path in creation order. Do not remove superseded versions.]

## Resume Instructions

- [Record the exact next safe action and any blocker.]
```

Allowed stage-status values are `Not started`, `In progress`, `Complete`, `Needs revision`, `Blocked`, `Failed`, `Not needed`, and `Abandoned`.

Telemetry is lightweight operational history, not a performance promise. Use `YYYY-MM-DD HH:MM America/New_York` and record actual times rather than estimates:

- **Stage started:** when the coordinator begins the stage or delegates to the specialist agent.
- **Agent completed:** when the specialist's complete response is received. Use `N/A` for coordinator-only or human stages.
- **Artifact saved:** when the expected artifact has been fully written and its persistence verified.
- **Agent invoked:** the exact configured agent name, or `Main coordinator`/`Lauren` when no specialist is used.
- **Pass type:** `Original substantive`, `Revision 1 substantive`, `Revision 2 substantive`, and so on for specialist work; use `Coordination` for coordinator-only setup. Do not label file-transfer or persistence activity as an agent pass.
- **External research:** `Yes` when the stage accessed public websites, bibliographic databases, journals, government sources, or other external material; otherwise `No`.

Add a telemetry row for each revision-stage invocation rather than overwriting the original row. If a timestamp is unavailable, use `Not recorded`; do not invent or backfill an estimate.

Update the status file when a stage starts, completes, fails, becomes stale, or changes route. The latest artifact paths and the exact next safe action must always be clear enough that a new Codex chat can resume without guessing.

Publication should normally remain `Not authorized` when the content pipeline finishes. Only a separate, explicitly authorized publishing workflow may change it to `Published`.

## Claims Review Artifact Requirement

Every future Claims Review Report must be saved to the project. The minimum required artifact is `04-claims-review.md`; every rerun must receive its own revision suffix.

The coordinator must not summarize away the Claims Reviewer's findings and treat the summary as the report. Save the complete structured report, then use `05-revision-notes-r1.md` or a later compact revision manifest to route and track every required correction.

## Restart and Recovery

The recovery rule is simple:

> Read `pipeline-status.md`, the current operative artifacts named there, the latest Claims Review Report, and the active revision manifest before taking action. Keep superseded artifacts available for audit or spot-checking, but do not automatically reread all of them in full. Never assume a stage needs to be rerun.

### A run stops halfway through

- Read the status file and artifact history.
- Verify that the latest listed artifact exists and appears complete.
- Read the current operative inputs and active revision manifest; consult superseded versions only when needed to resolve history, scope, or a discrepancy.
- Resume at the documented next safe action.
- If the status file and artifacts disagree, stop and reconcile the discrepancy before delegating.

### A chat closes

- Start from the repository root.
- Read `AGENTS.md`, this runbook, the topic's status file, its current operative artifacts, the latest Claims Review Report, and any active revision manifest.
- Use superseded artifacts for audit or targeted comparison rather than automatically loading each one in full.
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
- Create or update the compact revision manifest with the affected sources, claims, passages, responsibility, required correction, and whether meaning changes.
- Send the operative evidence, affected passages, Claims Review finding, and manifest to the Writer; do not require a full reread of superseded artifacts unless the correction needs it.
- Save the targeted revised draft and rerun Claims Review.

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
- Specialist agents are invoked only for substantive stage work, not artifact transfer or persistence.
- Every completed stage has a saved, separately named artifact.
- The coordinator recorded stage-start, agent-completion, and artifact-save telemetry without inventing timestamps.
- Every material evidence source passed the Citation-Integrity Gate or is marked `UNRESOLVED — DO NOT USE FOR PUBLIC CLAIMS`.
- An existing-article update has one reusable read-only source snapshot or a documented retrieval limitation.
- An existing-article update has a complete SEO Preservation Map that defaults accurate, useful material to preservation.
- Before drafting an existing-article update, any broad-rewrite warning is either not triggered or has Lauren's recorded advance scope approval.
- An existing-article draft has a Preservation Ledger that matches the article and accounts for every major original block.
- Claims Review of an existing-article update includes a preservation check separate from scientific review, and no unauthorized substantial replacement remains unresolved.
- The Claims Review Report is saved rather than left only in chat.
- `pipeline-status.md` identifies the current stage and next safe action.
- Required upstream artifacts are complete before downstream delegation.
- Revision handoffs use the current operative artifacts and compact manifest instead of automatically loading every superseded version.
- Lauren's approval remains a mandatory stop.
- WordPress access and publishing remain outside the pipeline.
- Existing ceramide files remain intact.

## Known MVP Limitations

- This is documented coordination, not unattended background automation. A Codex task must still interpret the request, delegate each stage, save outputs, and maintain status.
- The quality of a run depends on agents receiving the correct, current artifact paths. The main task must verify those paths at every handoff.
- Citation identity checks improve reliability but do not replace scientific interpretation or independent Claims Review.
- Existing-article snapshots can become stale; a live recheck is still appropriate when the public page may have materially changed or the snapshot is incomplete.
- Preservation dispositions and the broad-rewrite warning require editorial judgment. The map, ledger, independent review, and Lauren escalation make that judgment visible, but they cannot turn voice preservation into a purely mechanical percentage calculation.
- Claims-review routing still requires judgment when a finding mixes evidence and writing problems. When in doubt, resolve evidence integrity first, then return the bounded result to the Writer.
- Public website and keyword data may be incomplete. The SEO brief must disclose data limitations rather than manufacture precision.
- Human approval remains intentionally manual, and publishing remains intentionally separate.

These limitations do not prevent a reliable first test. A clear future request such as “Run the Beauty Truth content pipeline for [topic]” provides enough information to begin Stage 0, create the status artifact, and coordinate the four defined stages without requiring Lauren to design the research or article structure herself.
