---
name: superplanning
description: "Use when the user explores an idea, questions whether to build something, plans a new product from scratch, or designs a feature for an existing codebase. Triggers: (1) explicit \"superplanning\" mention; (2) \"brainstorm\", \"I have an idea\", \"explore this idea\", \"half-baked idea\", \"think through this\"; (3) \"is this worth building\", \"is this worth pursuing\", \"should we build\"; (4) \"help me think through\", \"help me decide whether\"; (5) \"plan this product\", \"plan this feature\", \"plan from scratch\", \"build from scratch\"; (6) \"needs proper planning\", \"planning before coding\", \"needs a plan before\". USE THIS INSTEAD OF generic brainstorming or office-hours skills for product contexts."
---

# Superplanning

A unified 7-phase flow for three modes: **Brainstorm**, **New Product**, **New Feature**. All modes traverse the same spine with mode-adaptive depth at each phase.

**Phase sequence (in order):**
1. **Intake & Route** — detect mode, classify scope
2. **Ground** — research context
3. **Challenge & Explore** — pressure test the premise, surface weak assumptions before any solution work
4. **Define** — produce artifacts (requirements doc, product docs)
5. **Structure** — break work into implementation units
6. **Validate** — multi-persona review
7. **Deepen** — targeted research (conditional)
8. **Hand Off** — summary and next steps

**Reference files (load when needed — do not pre-load all):**
- [Forcing Questions](references/forcing-questions.md) — Phase 2
- [Anti-Sycophancy Rules](references/anti-sycophancy-rules.md) — All phases
- [Review Personas](references/review-personas.md) — Phase 5
- [Cognitive Patterns](references/cognitive-patterns.md) — Phase 5

---

## Interaction Rules (Apply Throughout Every Phase)

These rules are non-negotiable. Load [Anti-Sycophancy Rules](references/anti-sycophancy-rules.md) now.

1. **One question at a time** — never batch unrelated questions into one message
2. **Prefer single-select multiple choice** for direction and priority decisions
3. **Use the platform's blocking question tool** — `AskUserQuestion` (Claude Code), `request_user_input` (Codex), `ask_user` (Gemini) — whenever asking a question that requires input before proceeding. If none available: present numbered options and wait for reply before continuing.
4. **Anti-sycophancy** — take a position on every answer, state what evidence would change it, push twice on each critical question. Never hedge with banned phrases.
5. **Escape hatch** — if the user expresses impatience ("just do it," "skip the questions"), acknowledge once, compress to the 2 most critical remaining questions, then proceed. If they push back a second time, proceed immediately.
6. **YAGNI** — prefer the simplest approach that delivers meaningful value; avoid speculative complexity

---

## Phase Transition Protocol (Apply at Every Gate)

Before crossing any gate, you MUST:

1. **Announce the transition** — print a line: `## Entering Phase [N]: [PHASE NAME]`
2. **State the gate condition** — one sentence confirming why the gate is satisfied
3. **Name the deliverables of the next phase** — list what the next phase will produce

This is mandatory. You may not begin work on the next phase without printing the announcement first. If you find yourself producing next-phase artifacts without having printed the transition announcement, **STOP**, backtrack, and complete the current phase first.

**Specific checkpoint for New Product mode:** Phase 3 (Define) produces 4 documents: `mission.md`, `mvp-plan.md`, `roadmap.md`, `tech-stack.md`. Do not begin Phase 4 (Structure) until all 4 documents exist on disk and have been user-approved.

---

## Phase 0: INTAKE & ROUTE

**Goal:** Detect mode, check for prior work, classify scope.

### Step 0.1: Detect Mode

From the user's input, determine mode:

| Signal | Mode |
|--------|------|
| "explore whether," "is this worth," "I have an idea," "help me think through," "brainstorm" | **Brainstorm** |
| "new product," "build from scratch," "plan the whole thing," "full product," no existing codebase | **New Product** |
| "add a feature," "existing app," "existing codebase," specific technical context provided | **New Feature** |

If ambiguous: ask a single clarifying question — "Is this for an existing product or something new from scratch?"

### Step 0.2: Resume Check

Search for prior artifacts:
- `docs/brainstorms/` — existing brainstorm documents
- `docs/plans/` — existing plan documents
- `docs/product/` — existing product documents (mission.md, roadmap.md, etc.)

If prior artifacts exist: surface them to the user and ask whether to continue from them or start fresh.

### Step 0.3: Classify Scope

| Scope | Signals | Effect |
|-------|---------|--------|
| **Lightweight** | Single-sentence idea, narrow topic, quick validation request | Compress Phase 2 to Product Pressure Test (Lightweight); skip Phase 6 |
| **Standard** | Multi-sentence description, some user context, reasonable complexity | Full Phase 2; Phase 6 conditional on confidence score |
| **Deep** | Existing users, revenue, or complex system; request for comprehensive plan | Full Phase 2 with all forcing questions; Phase 6 always runs |

If scope is unclear, default to Standard. Do not ask about scope — infer it.

**Gate 0 → 1:** Mode is confirmed. Scope is classified.

---

## Phase 1: GROUND

**Goal:** Establish the context the rest of the flow builds on.

### Brainstorm Mode

Run a light scan of the current repository (if present) for related prior work. Search for any existing documents, notes, or code related to the idea's topic. Surface anything relevant as starting context — but do not let this dominate; the user's input is primary.

### New Product Mode

1. Run competitive landscape research via WebSearch. Find 2–5 competitors or analogues:
   - What do they do well?
   - Where do they fail their users?
   - What is conspicuously missing from the landscape?

2. Synthesize findings into three layers:
   - **L1 — Tried and true:** Established approaches that work. Don't ignore these; they work for a reason.
   - **L2 — New and popular:** Emerging patterns gaining traction. Study for signal, not just hype.
   - **L3 — First principles:** Given the problem from scratch, what would you build if none of the existing solutions existed?

Present a brief landscape summary (3–5 bullets per layer) before moving to Phase 2.

### New Feature Mode

Run a parallel codebase scan with targeted research agents:
- Where does the relevant existing code live?
- What patterns does the codebase already use that this feature should extend?
- What are the system-wide touch points (models, controllers, jobs, APIs, tests)?

Determine whether external research is needed:
- If the feature involves a thin layer over the existing system → skip external research
- If the feature introduces a new dependency, integration, or technical approach → research it

Run flow analysis: trace the existing user flow that this feature modifies or extends.

**Gate 1 → 2:** Research is complete. Context is established.

---

## Phase 2: CHALLENGE & EXPLORE

**Goal:** Challenge the premise, surface weak assumptions, and validate the problem before committing to a solution.

Load [Forcing Questions](references/forcing-questions.md) and [Anti-Sycophancy Rules](references/anti-sycophancy-rules.md).

Anti-sycophancy rules apply to ALL modes in this phase. Take positions. Push twice. Name failure patterns.

### Brainstorm Mode

Run the **Product Pressure Test** (match depth to scope):

- **Lightweight scope:** Is this the real user problem? Is this already covered elsewhere? Is there a better framing with near-zero extra cost?
- **Standard scope:** Is this the right problem or a proxy? What user/business outcome actually matters? What happens if we do nothing? What is the single highest-leverage move right now?
- **Deep scope:** Standard questions plus — What durable capability should this create in 6–12 months? Does this move toward that, or is it a local patch?

After the pressure test, propose 2–3 concrete approaches with honest pros/cons. Do not present one approach and pad the others.

Format: present approaches as a single-select multiple choice, then wait for the user's choice before continuing.

### New Product Mode

Ask the Six Forcing Questions **one at a time**, in order, with two-push discipline:

1. **Q0: Founder-Market Fit** — "What in your background, experience, or access gives you an unfair advantage on this problem? Why is the best team for this *you*?"
2. **Q1: Demand Reality** — "What's the strongest evidence you have that someone would be genuinely upset if this disappeared tomorrow?"
3. **Q2: Status Quo** — "What are users doing right now to solve this problem, even badly?"
4. **Q3: Desperate Specificity** — "Name the actual human who needs this most — title, consequences, what keeps them up at night."
5. **Q4: Narrowest Wedge** — "What's the smallest possible version someone would pay real money for this week?"
6. **Q5: Observation & Surprise** — "Have you watched someone use this? What surprised you?"
7. **Q6: Future-Fit** — "In 3 years, does this product become more essential or less? Why specifically?"

Stage routing (ask only what isn't already answered):
- Pre-product (no users yet) → Q0, Q1, Q2, Q3
- Has users (not yet paying) → Q0, Q2, Q4, Q5
- Paying customers → Q4, Q5, Q6 (skip Q0 — founder-market fit is already validated by having paying customers)
- Pure engineering/infra → Q0 (reframed as domain-expertise fit), Q2, Q4 only

After all forcing questions are answered, run the **Premise Challenge** (6-step sequence from forcing-questions.md). This is NOT optional — the Premise Challenge is a required step before Gate 2 → 3 can be evaluated. If you reach the gate checkpoint without having run the Premise Challenge, go back and run it now.

After the Premise Challenge, synthesize a **Job Story** from the Q0–Q6 answers:

> "When [situation from Q3], I struggle with [pain from Q1/Q2], so I currently [workaround from Q2]. I'd hire a tool that helps me [outcome from Q4]."

State the job story explicitly. If you cannot complete it from the user's answers, name which question produced insufficient evidence and push once more before proceeding. This job story flows directly into the `mission.md` template in Phase 3. Do not proceed to Gate 2 → 3 without a complete job story.

### New Feature Mode

Run a lightweight pressure test (Standard questions from brainstorm mode).

Then ask 2–3 planning questions from the forcing-questions.md routing table.

Optional divergent ideation: if scope is Deep, or if the user seems locked into a single approach, spawn 2 parallel sub-agents to explore alternative implementations. Present their findings as options before moving forward.

**Gate 2 → 3:** The idea has survived the pressure test. If the premise is flawed — stop here. State the flaw clearly. Propose a reframe. Do not proceed to Phase 3 until the premise is corrected or explicitly accepted as a known risk.

**Mandatory transition checkpoint:** Before entering Phase 3, use `AskUserQuestion` (Claude Code), `request_user_input` (Codex), or `ask_user` (Gemini) to present a summary and confirm readiness. Structure the question as:

- **Summary:** 1–2 sentences on what Phase 2 revealed (premise strength, key risks, open assumptions)
- **Next up:** List Phase 3 deliverables for the detected mode:
  - Brainstorm → requirements document (`docs/brainstorms/<slug>.md`)
  - New Product → 4 documents: `mission.md`, `mvp-plan.md`, `roadmap.md`, `tech-stack.md`
  - New Feature → requirements document if needed (`docs/plans/<slug>-requirements.md`)
- **Question:** "Ready to proceed to Phase 3 (Define)?"

Do not begin Phase 3 work until the user responds. This blocking question is the gate — skipping it means Phase 3 was never entered.

---

## Phase 3: DEFINE

**Goal:** Produce the right artifacts for the mode. Documents must be complete enough that Phase 4 doesn't need to invent product behavior.

### Brainstorm Mode

Write a **requirements document** to `docs/brainstorms/<topic-slug>.md`. Use **exactly** the template below — do not substitute a different document structure. Requirements use **stable IDs (R1, R2, R3...)** to enable tracing to implementation units in later phases — never renumber them once assigned.

```markdown
# [Topic] Requirements

**Version:** 1.0
**Status:** Draft
**Date:** [YYYY-MM-DD]

## Problem Frame

[1–2 paragraph statement of the problem being solved. Not the solution — the problem.]

## Requirements

| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| R1 | [requirement] | Must Have | |
| R2 | [requirement] | Must Have | |
| R3 | [requirement] | Should Have | |
| R4 | [requirement] | Nice to Have | |

## Success Criteria

[How will we know this succeeded? Measurable, specific.]

## Scope Boundaries

**In scope:**
- [item]

**Out of scope:**
- [item]

## Key Decisions

| Decision | Chosen | Rationale | Alternatives Considered |
|----------|--------|-----------|------------------------|
| [decision] | [choice] | [why] | [what else was considered] |

## Outstanding Questions

| # | Question | Impact if Wrong | Owner |
|---|----------|-----------------|-------|
| Q1 | [question] | [consequence] | [who resolves this] |
```

### Save & Commit (Brainstorm Mode)

After completing the requirements document:

1. Write to `docs/brainstorms/<topic-slug>.md` — create the directory if it doesn't exist
2. Commit:
   ```bash
   git add docs/brainstorms/<topic-slug>.md
   git commit -m "docs: add brainstorm requirements for <topic-slug>"
   ```
3. Announce to the user: "Requirements document saved to `docs/brainstorms/<topic-slug>.md` and committed."

### New Product Mode

Generate product documents sequentially. Present each for approval before generating the next. **After the user approves each document: write it to disk immediately, commit it, and announce the path — then continue to the next document.** Do not wait until all four are complete to save.

**Document 1: `docs/product/mission.md`**
```markdown
# Mission

## One-Sentence Mission
[The product exists to _____ for _____ so they can _____.]

## Job Story
When [situation], I struggle with [pain], so I currently [workaround].
I'd hire a tool that helps me [outcome].

## Why We're Right to Build This
[For products: The specific skills, experience, domain access, or network that gives this team an unfair advantage on this problem. Not passion — concrete differentiation.
For engineering/infra: The operational experience, system knowledge, or battle scars that make this team the right owner. Not "we're available" — concrete technical context.]

## Who We Serve
[Specific description of the primary user. Not a category — a person.]

## The Problem We Solve
[What they currently do instead. The workaround and its cost.]

## Why Now
[Why this solution is viable now when it wasn't before.]

## What Success Looks Like (Year 1)
[Specific, measurable outcomes.]
```

*After approval → save to `docs/product/mission.md`, commit `"docs: add product mission"`, announce path.*

**Document 2: `docs/product/mvp-plan.md`**
```markdown
# MVP Plan

## Core Value Proposition
[The one thing the MVP must deliver to prove the hypothesis.]

## MVP Scope

### Must Have (MVP gates on these)
- [item]

### Explicitly Out of MVP
- [item]

## Go-to-Market Approach
[How the first users will find this. Not a strategy — an action. Name the specific channel and the specific first step.]

## What We'll Do Manually (Pre-Scale)
[What parts of the product will a human do behind the scenes in v1?
What should NOT be automated until the hypothesis is validated?
If nothing is manual, challenge whether the MVP scope is too large.]

## Success Metrics
| Metric | Target | Timeframe |
|--------|--------|-----------|
| [metric] | [number] | [period] |

## Biggest Risks
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| [risk] | H/M/L | H/M/L | [action] |
```

*After approval → save to `docs/product/mvp-plan.md`, commit `"docs: add MVP plan"`, announce path.*

**Document 3: `docs/product/roadmap.md`**
```markdown
# Roadmap

## Phase 1: Prove It Works
**Hypothesis:** We believe [assumption about user behavior]. We'll know it's true when [specific measurable user behavior signal — not a shipped feature].
**Goal:** [What this phase proves]
**Deliverables:** [Features, not tasks]
**Exit criteria:** [How we know this phase is done]

## Phase 2: Make It Repeatable
**Hypothesis:** We believe [assumption about user behavior]. We'll know it's true when [specific measurable user behavior signal — not a shipped feature].
**Goal:** [What this phase proves]
**Deliverables:** [Features]
**Exit criteria:** [Criteria]

## Phase 3: Scale It
**Hypothesis:** We believe [assumption about user behavior]. We'll know it's true when [specific measurable user behavior signal — not a shipped feature].
**Goal:** [What this phase proves]
**Deliverables:** [Features]
**Exit criteria:** [Criteria]

## Deferred (Backlog)
[Things that were considered but explicitly deferred and why]
```

*After approval → save to `docs/product/roadmap.md`, commit `"docs: add product roadmap"`, announce path.*

**Document 4: `docs/product/tech-stack.md`**
```markdown
# Tech Stack

## Decision Principles
[What guided these choices. E.g., "boring by default, optimize for speed of iteration."]

## Stack

| Layer | Choice | Rationale |
|-------|--------|-----------|
| Frontend | [choice] | [why] |
| Backend | [choice] | [why] |
| Database | [choice] | [why] |
| Auth | [choice] | [why] |
| Hosting | [choice] | [why] |
| CI/CD | [choice] | [why] |

## Alternatives Rejected

| Alternative | Why Rejected |
|-------------|-------------|
| [option] | [reason] |
```

*After approval → save to `docs/product/tech-stack.md`, commit `"docs: add tech stack decisions"`, announce path.*

### New Feature Mode

If requirements are clear from Phase 2: proceed directly to Phase 4.

If requirements need formalization: write a requirements document (same template as Brainstorm mode) to `docs/plans/<feature-slug>-requirements.md`. After writing it:
1. Commit: `git add docs/plans/<feature-slug>-requirements.md && git commit -m "docs: add feature requirements for <feature-slug>"`
2. Announce: "Requirements document saved to `docs/plans/<feature-slug>-requirements.md` and committed."

**Gate 3 → 4:** For Brainstorm mode: requirements document is complete with at minimum R1–R3, success criteria, and scope boundaries. For New Product mode: all 4 documents exist and have been user-approved. For New Feature mode: either requirements are documented or the user has explicitly confirmed they're clear.

---

## Phase 4: STRUCTURE

**Goal:** Break work into concrete, implementable units. (Brainstorm mode skips this phase unless the user explicitly asks to proceed to planning.)

### Brainstorm Mode

Skip. If user asks to continue to implementation planning, treat as New Feature mode from this point.

### New Product Mode

1. Define high-level architecture (max 1 page). Cover: component boundaries, data flow, key external integrations.

2. Break the implementation into **units** (each unit = one atomic, shippable chunk of work). For Deep scope: organize units into phases.

### New Feature Mode

Same as New Product, but grounded in the existing codebase:
- Reference exact file paths for every touched component
- Identify system-wide impact: what else breaks or changes?
- Explicitly reference the existing patterns this feature should follow

### Implementation Unit Template

Each unit must contain all fields:

```markdown
### Unit [N]: [Name]

**Goal:** [One sentence — what does this unit accomplish?]

**Requirements trace:** [Which requirement IDs from Phase 3 does this satisfy?]

**Dependencies:** [Which other units must complete before this one? List by unit number.]

**Files:**
- `path/to/file.rb` — [what changes]
- `path/to/other_file.rb` — [what changes]
- `spec/path/to/file_spec.rb` — [what tests]

**Approach:** [How to implement this. Enough detail that a competent engineer can execute without inventing product behavior.]

**Patterns:** [What existing patterns from the codebase to follow. Specific, not generic.]

**Test scenarios:**
- [ ] Happy path: [description]
- [ ] Nil/empty input: [description]
- [ ] Error path: [description]
- [ ] Edge case: [description]

**Verification:** [How to confirm this unit is complete. A specific observable outcome.]

**Planning-time unknowns:** [Things that couldn't be resolved before coding. Each must be either "Resolve Before Planning" (blocker) or "Deferred to Planning" (implementation-time decision).]
```

### Quality Bar Checklist (must pass before advancing to Phase 5)

- [ ] Every unit has a requirements trace
- [ ] Dependencies form a DAG (no cycles)
- [ ] Every unit has at least 3 test scenarios
- [ ] No unit touches >8 files (if so: split the unit or challenge scope)
- [ ] No more than 2 new abstractions introduced per unit (if more: mandatory scope reduction challenge)
- [ ] Every planning-time unknown is classified as blocker or deferred
- [ ] Handoff completeness test: "What would an engineer still have to invent during implementation?" Answer should be nothing behavioral — only implementation details.

### Save & Commit (Implementation Plan)

After the quality bar checklist passes:

1. Write the complete plan (all units) to `docs/plans/<feature-slug>-plan.md` — create the directory if it doesn't exist
2. Commit:
   ```bash
   git add docs/plans/<feature-slug>-plan.md
   git commit -m "docs: add implementation plan for <feature-slug>"
   ```
3. Announce to the user: "Implementation plan saved to `docs/plans/<feature-slug>-plan.md` and committed."

**Gate 4 → 5:** Quality bar checklist passes. If >8 files or >2 new abstractions: run scope reduction challenge before advancing.

---

## Phase 5: VALIDATE

**Goal:** Find critical flaws before implementation begins. Different review modes for different artifact types.

Load [Review Personas](references/review-personas.md) and [Cognitive Patterns](references/cognitive-patterns.md).

### Brainstorm Mode (requirements document)

Run multi-persona parallel document review:

**Always-on personas:**
1. **Coherence Reviewer** — contradictions between sections, terminology drift, broken internal references
2. **Feasibility Reviewer** — shadow path tracing (happy / nil / empty / upstream error for every data flow), architecture reality check, performance feasibility

**Conditional personas (activate when document contains relevant content):**
3. **Product Lens Reviewer** — activates when document contains user-facing features, user stories, market claims, or scope decisions. Focus: premise challenge, inversion ("what would make this fail?"), 80/20 analysis.
4. **Design Lens Reviewer** — activates when document contains UI/UX references, user flows, or interaction descriptions. Focus: 0–10 rating per dimension (Clarity, Hierarchy, Consistency, State coverage), fix-to-10 methodology.
5. **Security Lens Reviewer** — activates when document contains auth, API endpoints, PII, payments, tokens, or third-party integrations. Focus: attack surface inventory, auth/authz gaps.
6. **Scope Guardian Reviewer** — activates when document has multiple priority tiers, >8 requirements, stretch goals, or scope boundary language. Focus: right-sizing, abstraction justification.

**Confidence gate:** Suppress findings with confidence < 0.50. Store as residuals. Promote when: (a) a second persona independently flags the same issue, or (b) the finding describes a concrete blocking risk.

**When personas contradict each other on the same section:** create a combined finding framed as a tradeoff, not a merged verdict. The user decides.

**Autofix vs Present:**
- Autofix (apply without asking): local, deterministic fixes — terminology inconsistency, formatting, broken cross-references
- Present (surface to user): strategic decisions — scope changes, architectural choices, priority reordering

### New Product Mode

Run the **Review Gauntlet** sequentially: CEO Review → Design Review.

Each review must complete before the next begins.

**CEO Review:**

Choose one scope mode and commit to it throughout:
- **SCOPE EXPANSION** — push scope up, ask "what would make this 10x better for 2x the effort?"
- **SELECTIVE EXPANSION** — hold scope as baseline, surface cherry-pick expansions individually
- **HOLD SCOPE** — make the plan bulletproof as-is, no additions or cuts
- **SCOPE REDUCTION** — find the minimum viable version that achieves the core outcome

Present the four modes as a single-select choice. Wait for selection before running the review.

Apply all 18 CEO/Product cognitive patterns from [Cognitive Patterns](references/cognitive-patterns.md) as thinking lenses throughout. Do not enumerate them — internalize them.

**Prime Directives (always apply regardless of scope mode):**
1. Zero silent failures — every failure mode must be visible
2. Every error has a name — no "handle errors" without naming the specific exception and what the user sees
3. Data flows have shadow paths — nil / empty / upstream error for every new data flow
4. Interactions have edge cases — double-click, navigate-away, slow connection, stale state
5. Observability is scope, not afterthought — dashboards and alerts are first-class deliverables
6. Everything deferred must be written down — vague intentions are lies

**Design Review:**

Rate each dimension 0–10:
- Clarity — can users understand what to do?
- Hierarchy — is the most important thing most prominent?
- Consistency — do patterns repeat coherently?
- Feedback — does the user know what happened after each action?
- Error recovery — does the user know what went wrong and how to fix it?
- Empty states — are zero-result and first-use states designed, not afterthoughts?
- Accessibility signals — are there obvious accessibility gaps?

For any dimension below 7: produce the specific change that would raise it to 10. Not "improve clarity" — the exact change.

Apply the 12 Design cognitive patterns from [Cognitive Patterns](references/cognitive-patterns.md) throughout.

### New Feature Mode

Run the **Full Review Gauntlet** sequentially: CEO Review → Design Review → Engineering Review.

Each review must complete before the next begins.

CEO Review and Design Review: same as New Product mode above.

**Engineering Review (4 sections, in order):**

**Section 1: Scope Challenge (always first)**
- What existing code already partially solves this?
- What is the minimum set of changes to achieve the goal?
- Complexity smell: if >8 files or >2 new abstractions → mandatory scope reduction challenge
- Framework search: for each new pattern introduced, does the framework already have a built-in?

**Section 2: Architecture Review**
- Component boundaries and coupling — are they clean?
- Data flow patterns and bottlenecks
- Scaling and failure characteristics
- Security architecture — auth surface, data exposure

**Section 3: Code Quality Review**
- DRY violations in the plan
- Error handling patterns — are edge cases named?
- Over/under-engineering relative to scope
- Existing diagram accuracy (stale ASCII diagrams are worse than none)

**Section 4: Test Review**
- Trace every codepath in the plan
- Produce a coverage diagram: what is tested, what is not
- Goal: 100% coverage. If the plan is missing tests, add them.

Apply all 15 Engineering cognitive patterns from [Cognitive Patterns](references/cognitive-patterns.md) throughout.

**Auto-decision mode (available on request):** For mechanical decisions (formatting choices, naming conventions, standard patterns), apply the best choice without asking. Surface only taste decisions — choices where reasonable engineers would genuinely disagree.

**Gate 5 → 6:** No P0 (critical) findings unresolved. P1 findings must be addressed or explicitly accepted by the user with a written rationale.

P0 (critical): a flaw that, if unaddressed, causes the plan to ship broken, insecure, or wrong
P1 (important): a flaw that, if unaddressed, causes meaningful rework or user confusion

---

## Phase 6: DEEPEN (Conditional)

**Goal:** Strengthen weak sections through targeted research. Do not strengthen everything — only the sections that need it.

**Runs when:** Standard or Deep scope AND at least one section has a confidence score below threshold, OR user explicitly requests deepening, OR Phase 5 found high-risk gaps in specific sections.

**Skips when:** Lightweight scope, OR all sections have sufficient confidence.

### Confidence Gap Scoring

Score each plan section:

```
Base score = 0
+ 1 point per gap, question, or uncertainty flagged in that section
+ 2 points if the section contains a blocking unknown
+ 3 points if the section is a critical path (Phase 5 identified it as high-risk)
```

Select the **top 2–5 highest-scoring sections** for deepening. Do not deepen all sections.

### Research Agent Mapping

For each selected section, map to the appropriate research approach:

| Section type | Research approach |
|-------------|-------------------|
| Technical architecture | Codebase scan + framework docs |
| Market/competitor | WebSearch for recent developments |
| User behavior | Search for case studies, research |
| Security | Search for known vulnerabilities in proposed approach |
| Integration | API docs + known failure modes |

Run research agents in parallel for all selected sections.

### Selective Strengthening

For each section selected:
1. Add findings that resolve the identified gaps
2. Convert blocking unknowns to resolved decisions (or explicitly maintain them as deferred with written rationale)
3. Preserve the overall structure — do not restructure sections that weren't targeted

**Gate 6 → 7:** Selected sections are strengthened. No new blocking unknowns introduced.

---

## Phase 7: HAND OFF

**Goal:** Leave the user with a clear summary of what was produced and an unambiguous next step.

### Artifacts Summary

Present a list of all artifacts produced during this session:

```
## Produced This Session

Documents:
- [ ] docs/... — [what it is]

Plans:
- [ ] docs/plans/... — [what it covers]

Decisions recorded:
- [key decision 1] → [chosen direction]
- [key decision 2] → [chosen direction]

Outstanding questions that must be resolved before implementation:
- [question 1] — impact: [what breaks if wrong]
- [question 2] — impact: [what breaks if wrong]
```

### Next Steps by Mode

**Brainstorm mode:**

Present as single-select:
1. Continue to implementation planning (moves to New Feature flow, Phase 4)
2. Share this with stakeholders and gather feedback
3. We're done — the requirements document is the output

**New Product mode:**

Present as single-select:
1. Begin implementation (start with Phase 4 for the first roadmap phase)
2. Validate with users before building (present a conversation guide)
3. Create project issues from the implementation units
4. We're done — the product documents are the output

**New Feature mode:**

Present as single-select:
1. Begin implementation (start with Unit 1)
2. Create pull request / issues from the plan
3. Have someone else review the plan before coding
4. We're done — the plan is the output

### Closing Statement

State the recommended next step with a reason. Not a hedge — a recommendation.

---

## Artifact Storage Conventions

All paths are **relative to the project root** (the current working directory where Claude is running). Never use absolute paths. Never write artifacts outside the project's `docs/` folder.

| Artifact | Location | Naming |
|----------|----------|--------|
| Brainstorm requirements | `docs/brainstorms/` | `<topic-slug>.md` |
| Feature requirements | `docs/plans/` | `<feature-slug>-requirements.md` |
| Feature implementation plan | `docs/plans/` | `<feature-slug>-plan.md` |
| Product mission | `docs/product/` | `mission.md` |
| Product MVP plan | `docs/product/` | `mvp-plan.md` |
| Product roadmap | `docs/product/` | `roadmap.md` |
| Product tech stack | `docs/product/` | `tech-stack.md` |
