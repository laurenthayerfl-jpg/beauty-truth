# The Beauty Truth — Master Project Instructions

## Project Overview

The Beauty Truth is a science-backed skincare education brand focused on making skincare easier to understand.

Tagline: **The Truth About Skincare, Simplified**

The brand translates cosmetic science into clear, grounded guidance that helps consumers make confident skincare decisions without fear-mongering, trend-chasing, or oversimplified marketing claims.

The existing website is a WordPress website at thebeautytruth.com.

Do not rebuild or replace the existing WordPress website unless explicitly instructed.

The long-term project may include:
- The existing Beauty Truth WordPress website and blog
- SEO and content systems
- AI-assisted content workflows
- A future Beauty Truth consumer application
- Product scanning and product analysis
- Personalized skincare routine building
- Ingredient and formulation education
- A future Beauty Truth skincare product line

## Core Brand Principles

Beauty Truth believes:

- Skin is a living organ, not a problem to fix.
- Consistency beats trends.
- Fear is not education.
- Formulation matters more than buzzwords.
- Longevity and barrier health are foundations of good skincare.
- Consumers should understand why something works rather than simply being told what to buy.

## Brand Voice

All consumer-facing Beauty Truth content should be:

- Intelligent but approachable
- Calm rather than alarmist
- Confident without being preachy
- Honest rather than trendy
- Warm rather than clinical
- Conversational but polished
- Educational rather than sales-driven
- Evidence-informed

Write as though explaining skincare to a smart friend who wants clarity rather than marketing.

Avoid:
- Fear-based language
- Ingredient demonization
- Trend worship
- Unsupported scientific claims
- Absolute claims when evidence is nuanced
- Overpromising results
- Keyword stuffing
- Manipulative marketing language
- Excessive emojis or exclamation points

## Content Philosophy

Beauty Truth content should primarily support:

1. Longevity Beauty
   - Barrier health
   - Skin aging as a biological process
   - Long-term skin function
   - Sustainable skincare routines

2. Debunking Fear-Mongering
   - Ingredient myths
   - Misleading labels
   - Trend-driven misinformation
   - Nuance around concepts such as "clean," natural, and synthetic

3. Education & Empowerment
   - Ingredient education
   - Routine building
   - Product formulation insights
   - Understanding ingredient labels

Content should explain **why**, not merely tell the reader what to do.

## Scientific Integrity

Never invent scientific evidence, citations, statistics, study findings, dermatologist recommendations, ingredient safety claims, or product claims.

Clearly distinguish between:
- Established evidence
- Emerging evidence
- Expert interpretation
- Brand opinion

When evidence is uncertain or mixed, say so.

Do not use AI-generated scientific claims as authoritative sources.

## WordPress Website

Production website:
thebeautytruth.com

The WordPress website is an existing production property.

Treat production as protected.

Do not:
- Modify the production website without explicit authorization.
- Delete production content.
- Change themes or plugins without explicit authorization.
- Change URLs or permalink structures without explicit authorization.
- Publish AI-generated content automatically unless a publishing workflow has specifically been approved.

Prefer reversible changes and staging/testing environments whenever possible.

## SEO Philosophy

SEO should serve the reader first.

Optimize for:
- Search intent
- Topical authority
- Helpful original content
- Clear site architecture
- Internal linking
- Accurate titles and metadata
- Structured data when appropriate
- Long-term organic authority

Do not:
- Keyword stuff
- Create low-value pages solely for search traffic
- Mass-produce thin AI content
- Copy competing websites
- Manufacture expertise or citations

Beauty Truth should become a trusted skincare knowledge resource, not an AI content farm.

## Future Beauty Truth App

The long-term product vision includes a consumer skincare assistant that may allow users to:

- Scan or search skincare products while shopping
- Ask questions about products
- Understand ingredients and formulations
- Determine how products fit into their routines
- Compare products
- Build personalized skincare routines
- Account for skincare experience and routine preferences
- Learn why recommendations are being made

The experience should feel like having a knowledgeable skincare professional available while shopping.

Website architecture and data decisions should consider this future product, but do not prematurely complicate the WordPress website to support features that do not yet exist.

## Future Skincare Products

Beauty Truth may eventually launch its own skincare products.

Education must remain credible and independent.

Content should not be written merely to justify future Beauty Truth products.

Future products should emerge from principles already taught by the brand.

## Development Principles

When working on this project:

1. Explain major technical decisions in plain language.
2. Prefer simple solutions over unnecessary complexity.
3. Protect existing production systems.
4. Use version control for code and configuration.
5. Keep credentials and API keys out of source control.
6. Test meaningful changes before production deployment.
7. Make changes incrementally when possible.
8. Document important architectural decisions.
9. Do not introduce paid services or dependencies without explaining why they are needed.
10. Assume the project owner may not be a professional software developer; explanations should be understandable without sacrificing technical accuracy.

## Strategic Roadmap

- Before starting material website, content-system, growth-system, product, app, monetization, architecture, or business-model work, consult `docs/strategy/beauty-truth-master-roadmap.md`.
- Treat the roadmap's `IMPROVE → BUILD → OPERATE → REVIEW` execution sequence, active-phase scope, Definition of Done, no-new-systems rule, execution and strategic-horizon gates, and decision-status labels as binding unless Lauren explicitly directs otherwise.
- This roadmap does not replace the brand voice, editorial standards, scientific positioning, production protections, or decision priorities in this file; those remain authoritative.

## Content Pipeline Orchestration

- Run the Beauty Truth content pipeline only when Lauren explicitly asks to use or run it for a topic. An ordinary writing, research, or brainstorming request does not activate the pipeline.
- Before coordinating a run, read `docs/website/content-pipeline.md`, the topic's `pipeline-status.md` if one exists, the current operative artifacts named there, the latest Claims Review Report, and any active revision manifest. Keep superseded artifacts available for audit or spot-checking without automatically rereading them in full.
- The normal order is `SEO Researcher → Evidence Researcher → Beauty Truth Writer → Claims Reviewer → Human Review`. The main Codex task coordinates the workflow and delegates only to the existing `seo_researcher`, `evidence_researcher`, `beauty_truth_writer`, and `claims_reviewer` agents. Do not create another orchestrator or unnecessary additional agents.
- Do not bypass required upstream stages. The Writer must not draft substantive evidence-based skincare content without an adequate Evidence Researcher brief, and every stage must be preserved as a separate project artifact.
- Every source supporting a material claim must pass the Evidence Researcher's bibliographic Citation-Integrity Gate before it is approved for Writer use. A source whose DOI, PMID, title, authors, publication, or year cannot be reconciled must be marked `UNRESOLVED — DO NOT USE FOR PUBLIC CLAIMS` rather than repaired by guessing or combining records.
- The evidence brief is the Writer's scientific boundary. The Claims Reviewer must compare the draft with that brief and the traceable sources rather than trusting the Writer's interpretation.
- The main Codex task must save completed agent outputs directly. Do not invoke the Writer or another specialist merely to transfer, chunk, persist, copy, or verify another agent's report; specialist-agent turns are for substantive SEO, evidence, writing, or Claims Review work.
- Record lightweight stage telemetry in `pipeline-status.md`: stage start, agent completion, artifact-save completion, exact agent, original or revision pass, and whether external research occurred. Record actual times only.
- For an existing-article update, preserve one dated, read-only source snapshot and reuse it for SEO, drafting, and article-fidelity review when adequate. Do not repeatedly crawl the same production article without a recorded reason.
- When the content type is `Existing article update`, the saved snapshot is the default base text. The Writer must edit that article rather than draft a replacement from a blank page. `Substantial update` is never blanket permission for a wholesale rewrite.
- Require the SEO Researcher to account for each meaningful original block in an Existing Article Preservation Map using `KEEP VERBATIM`, `LIGHT EDIT`, `CLAIM REPAIR — EVIDENCE`, `MOVE — SEO/STRUCTURE`, `REMOVE — DEFECT`, `ADD — EVIDENCE/SEARCH`, or `LAUREN DECISION`. Default to preserving accurate, useful copy; SEO architecture does not authorize copy replacement.
- Treat published Lauren-attributed hooks, transitions, analogies, headings, memorable phrasing, first-person language, brand framing, nonfactual examples, professional observations already present, and concise closing lines as protected supplied content. Repair unsupported claims as narrowly as practical without inventing Lauren's experience.
- Before Stage 3 of an update, stop and obtain Lauren's advance scope approval if a large portion of meaningful original content may require substantive replacement or protected Lauren-authored material would be removed without an evidence, accuracy, safety, defect-correction, or explicit-Lauren reason. About 40% is a warning signal, not a rigid threshold; exclude duplicate residue, broken markup, formatting, typos, and citation insertion.
- The Writer must account for every major original block in an internal Preservation Ledger that is excluded from publication content. The Claims Reviewer must separately test preservation against the snapshot, map, evidence handoff, ledger, and any scope approval. Scientific accuracy alone does not satisfy the preservation gate; unauthorized substantial replacement is a `MAJOR` editorial issue.
- Route Claims Review decisions as follows: `PASS` advances to Lauren's review; `PASS WITH MINOR REVISIONS` returns narrowly scoped corrections to the appropriate agent and advances only after they are resolved; `REVISE AND RESUBMIT` returns the work to the Writer and/or Evidence Researcher and requires another Claims Review; `DO NOT PUBLISH` stops the pipeline and reports the reason to Lauren.
- Citation-integrity or evidence problems return to the Evidence Researcher. Writing, clarity, or voice problems that need no new evidence return to the Writer. Never silently weaken or remove scientific uncertainty merely to pass review.
- Use a compact revision manifest to identify the finding, severity, responsible stage, affected source or passage, required correction, and whether scientific meaning changes. Give revision agents the current operative artifact, Claims Review finding, and manifest; keep superseded artifacts available for audit or spot-checking without automatically rereading them in full.
- Preserve version history while changing only what the revision requires. Do not regenerate large unchanged evidence or article sections merely to create a revision file. Substantive scientific, medical, regulatory, safety, efficacy, or citation changes still require the appropriate Evidence Researcher → Writer → Claims Reviewer route and a new Claims Review.
- Never invent Lauren's personal or professional perspective. Preserve a specific `[LAUREN INPUT: ...]` placeholder when her input is genuinely needed, and stop for her input before finalization.
- Keep the states `Researched`, `Drafted`, `Claims Reviewed`, `Human Approved`, and `Published` distinct. `Claims Reviewed` is not `Human Approved`, and `Human Approved` is not `Published`.
- Stop for Lauren's explicit human approval after Claims Review and before finalization or any publishing workflow. WordPress access, drafting, scheduling, and publishing are separate actions requiring explicit authorization. The content pipeline must never auto-publish.
- Scientific accuracy and consumer trust outrank SEO and production speed.

## AI Role

AI supports Beauty Truth but does not replace brand judgment or scientific verification.

Appropriate AI uses include:
- Research organization
- Content outlines
- SEO analysis
- Draft assistance
- Code generation
- Testing
- Data organization
- Workflow automation
- Editing for clarity

Human review should remain part of workflows involving:
- Scientific claims
- Health-related guidance
- Product recommendations
- Published editorial content
- Major production changes

## Decision Priority

When priorities conflict, use this order:

1. Scientific accuracy and consumer trust
2. User safety and data protection
3. Brand integrity
4. Reader usefulness
5. Maintainability
6. SEO
7. Speed of production

Never sacrifice trust or accuracy simply to increase traffic, engagement, or output.
