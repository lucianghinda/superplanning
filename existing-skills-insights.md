# Existing Skills: Unique Valuable Insights

Analysis of what makes each source skill uniquely valuable for integration into the superplanning unified flow. Focus is on concepts that are distinctly useful — not common patterns shared by all skills.

Referenced during design of `skills/superplanning/SKILL.md`.

---

## 1. `ce:brainstorm` — The Handoff Completeness Test

**Unique concept: "What would the next phase still have to invent?"**

The pre-finalization checklist asks: *"What would `ce:plan` still have to invent if this brainstorm ended now?"* This is a precise, testable gate. A brainstorm is incomplete not when questions run out, but when planning would still have to invent *product behavior, scope boundaries, or success criteria*.

Also unique:
- **"Resolve Before Planning" vs "Deferred to Planning"** — explicit classification splits blocking questions from questions that belong in planning. Prevents key product decisions from being silently punted.
- **Stable IDs on requirements** (R1, R2…) — enables unambiguous cross-referencing from requirements → plan → implementation units → tests.

---

## 2. `ce:plan-beta` — Implementation Unit Anatomy + Planning-Time vs Execution-Time Separation

**Unique concept 1: Each implementation unit is a structured object, not a task**

Every unit specifies: Goal, Requirements trace, Dependencies, Files (exact paths), Approach, Patterns to follow, Test scenarios, Verification. The test file path is required in the Files field. This makes units *reviewable* before implementation starts.

**Unique concept 2: Planning-time vs execution-time unknowns are explicitly separated**

Things knowable from repo context or user choice belong in the plan. Things that depend on *running code* or *seeing test failures* are explicitly deferred under "Deferred to Implementation." This prevents fake certainty in plans.

**Unique concept 3: Conditional external research using repo findings**

The decision to do external research is made by reading what the local scan found: if the technology layer is *absent or thin* in the codebase → do external research; if *well-established with examples to follow* → skip it. More precise than "always research" or "never research."

---

## 3. `office-hours` — Staged Forcing Questions + Two Posture Modes

**Unique concept 1: Stage-routed forcing questions**

The 6 forcing questions (Demand Reality, Status Quo, Desperate Specificity, Narrowest Wedge, Observation & Surprise, Future-Fit) are not always all asked. There is a routing table:
- Pre-product → Q1, Q2, Q3
- Has users → Q2, Q4, Q5
- Has paying customers → Q4, Q5, Q6
- Pure engineering/infra → Q2, Q4 only

Asking the wrong questions at the wrong stage wastes time and misframes the problem.

**Unique concept 2: Anti-sycophancy as named, specific prohibitions**

Not "be direct" — specific banned phrases with required replacements:
- "That's interesting" → take a position instead
- "There are many ways to think about this" → pick one and state what evidence would change your mind
- "That could work" → say whether it WILL work based on evidence, and what evidence is missing

The rule: take a position AND state what evidence would change it. Position + falsifiability condition is more rigorous than just "be honest."

**Unique concept 3: The escape hatch preserves respect while maintaining discipline**

If the user is impatient: compress to the 2 most critical remaining questions (not zero), then proceed. If they push back a second time, stop asking entirely. Respects autonomy without abandoning the process.

**Unique concept 4: Startup mode vs Builder mode — same tool, different posture**

Startup mode is diagnostic and uncomfortable. Builder mode is enthusiastic and generative. The same session can shift between them if signals change. A skill that treats a hobbyist the same as a founder wastes both people's time.

---

## 4. `autoplan` — Mechanical vs Taste Decision Classification

**Unique concept 1: Not all auto-decisions are equal**

Mechanical decisions (run codex: always yes; reduce scope on a complete plan: always no) are made silently. Taste decisions — close approaches, borderline scope, disagreements from a second reviewer — are auto-decided but surfaced at a final approval gate. The user answers nothing during the review but still sees the decisions where reasonable people could disagree.

**Unique concept 2: "Auto-decide replaces the USER's judgment, not the ANALYSIS"**

The analytical depth stays the same even in auto mode. Every section still gets read and evaluated. Automation ≠ shallowness.

**Unique concept 3: Sequential phase ordering is mandatory**

CEO → Design → Eng runs in strict sequence, never parallel, because each phase builds on the previous. CEO review changes scope, which changes what Design reviews, which changes what Eng must account for. This is a meaningful architectural constraint.

---

## 5. `plan-ceo-review` — Scope Mode Selection + Shadow Paths

**Unique concept 1: Four scope modes chosen once, committed to throughout**

- SCOPE EXPANSION — dream big, push scope up
- SELECTIVE EXPANSION — hold scope as baseline, surface cherry-pick opportunities individually
- HOLD SCOPE — make the plan bulletproof as-is
- SCOPE REDUCTION — cut to minimum viable

The mode is chosen at the start and never silently shifted. Prevents the review from oscillating between contradictory postures.

**Unique concept 2: Shadow path tracing as a Prime Directive**

"Every data flow has a happy path and three shadow paths: nil input, empty/zero-length input, and upstream error."

This is a concrete, learnable technique — not "handle edge cases" but a specific enumeration of the shadow paths that must be traced for every new data flow.

**Unique concept 3: Cognitive patterns as internalized lenses, not a checklist**

The CEO cognitive patterns (Bezos, Munger, Jobs, Grove, etc.) are explicitly framed as thinking *instincts*, not a to-do list. The instruction is to *internalize* them, then let them surface naturally during review. Philosophically different from "check the following boxes."

**Unique concept 4: Permission to scrap and restart**

"You have permission to say 'scrap it and do this instead.'" Creates explicit space for the reviewer to recommend a fundamentally different approach, not just improve the current one.

---

## 6. `plan-eng-review` — Complexity Smell Threshold + Test Coverage Diagram

**Unique concept 1: Complexity smell triggers scope challenge automatically**

Touching >8 files OR introducing >2 new classes/services triggers a scope reduction challenge. This is a specific, numeric signal — not "if it feels complex." When triggered, the reviewer must proactively recommend a minimal version via AskUserQuestion.

**Unique concept 2: Test coverage as a diagram, not a list**

The test review traces every codepath in the plan and produces a coverage diagram showing what is and is not tested. Visual representation makes gaps obvious in ways that a bullet list cannot.

**Unique concept 3: Distribution check**

If the plan introduces a new artifact type (CLI, library, container, mobile app), the review checks whether the build/publish pipeline is included. "Code without distribution is code nobody can use." Almost never covered in other skills.

**Unique concept 4: 15 eng manager cognitive patterns as thinking instincts**

Larson's team states (falling behind / treading water / repaying debt / innovating), McKinley's "boring by default," Beck's "make the change easy, then make the easy change," Fowler's "incremental over revolutionary." Applied as lenses, not checklists.

---

## 7. `deepen-plan-beta` — Confidence Gap Scoring + Selective Deepening

**Unique concept 1: Sections are scored, only the weakest 2–5 are deepened**

Each section gets: trigger count + risk bonus (if high-risk domain) + critical-section bonus (for Key Technical Decisions, System-Wide Impact, etc.). Only the top 2–5 sections by score are deepened. Prevents "inflate everything" while targeting real weak spots.

**Unique concept 2: Section-to-agent deterministic mapping**

Requirements gaps → spec-flow-analyzer. Technical decisions → architecture-strategist. System-wide impact → performance-oracle, security-sentinel, or data-integrity-guardian depending on the actual risk. Avoids the trap of running all agents on everything.

**Unique concept 3: The `document-review` vs `deepen-plan-beta` distinction**

Explicitly differentiated:
- `document-review` = "Is this document clear?" (presentation, completeness, structure)
- `deepen-plan-beta` = "Is this plan grounded enough?" (confidence in decisions, rationale, risk treatment)

One improves clarity; the other increases confidence in the decisions themselves.

---

## 8. `document-review` — Confidence Gate + Residual Promotion + Contradiction Resolution

**Unique concept 1: The 0.50 confidence gate with residual storage**

Findings below 0.50 confidence are suppressed — but stored. They can be *promoted* if another persona independently flags the same issue (cross-persona corroboration), or if the low-confidence finding describes a concrete blocking risk. Avoids both noise and missed signals.

**Unique concept 2: Contradiction resolution is explicit**

When personas disagree on the same section (coherence says "keep for consistency," scope-guardian says "cut for simplicity"), the system creates a *combined finding* framed as a tradeoff, not a merged verdict. The user decides. Prevents false resolution.

**Unique concept 3: Autofix vs Present classification**

Local, deterministic fixes (terminology, formatting, cross-references) are applied automatically without asking. Strategic decisions are presented to the user. The right division of labor: don't interrupt the user for things that have only one correct answer.

---

## 9. `superpowers brainstorming` — Hard Gate + Decomposition Check + Unit Isolation Test

**Unique concept 1: "Simple project" fallacy is named and addressed directly**

The skill explicitly calls out the "this is too simple to need a design" anti-pattern. Reason: "Simple projects are where unexamined assumptions cause the most wasted work." The hard gate (no implementation before design approval) applies regardless of perceived simplicity.

**Unique concept 2: Decomposition before clarification**

If the request describes multiple independent subsystems, flag it immediately — before asking any clarifying questions. Decomposing first prevents spending questions refining details of a project that needs to be broken apart first.

**Unique concept 3: Unit isolation test**

"Can someone understand what a unit does without reading its internals? Can you change the internals without breaking consumers? If not, the boundaries need work."

A clean, testable definition of good component design applicable during the design phase, not just code review.

**Unique concept 4: Spec review loop with bounded iterations**

After writing the design doc: dispatch a spec-document-reviewer subagent, fix issues, re-dispatch until approved — but cap at 3 iterations, then escalate to the human. Prevents infinite review cycles.

---

## Cross-Cutting Insights (shared but worth preserving in unified form)

| Insight | What Makes It Non-Obvious |
|---|---|
| **Boil the Lake** | AI makes completeness near-free. A "lake" (all edge cases, 100% coverage) is boilable; an "ocean" (multi-quarter rewrite) is not. The economic reframing matters: with AI, shortcuts cost almost as much as completeness in time, but far more in quality debt. |
| **Three-layer synthesis** | Layer 1 (tried-and-true): don't reinvent. Layer 2 (new-and-popular): scrutinize carefully. Layer 3 (first-principles): prize above all. The ordering is prescriptive — most tools default to Layer 2 without checking Layer 1 or reasoning to Layer 3. |
| **One question at a time** | The enforcement mechanism varies: office-hours uses a hard STOP after each AskUserQuestion; ce:brainstorm allows multi-select only for compatible sets; superpowers is absolute (one per message). The mechanism matters as much as the rule. |
| **WHAT vs HOW boundary** | Planning does not invent product behavior. Execution does not invent plan structure. These are distinct phases with explicit inputs from each other. Crossing the boundary silently is always a sign of incomplete work in the prior phase. |

---

## Priority for Integration into Superplanning

Ranked by uniqueness and value to the unified flow:

| # | Concept | Source |
|---|---|---|
| 1 | Handoff completeness test ("what would the next phase still invent?") | ce:brainstorm |
| 2 | Stage-routed forcing questions (pre-product / has users / paying customers) | office-hours |
| 3 | Anti-sycophancy with specific banned phrases + falsifiability requirement | office-hours |
| 4 | Confidence gap scoring — score sections, deepen only the weakest 2–5 | deepen-plan-beta |
| 5 | Shadow path tracing — nil / empty / error paths for every new data flow | plan-ceo-review |
| 6 | Scope mode selection committed to throughout (expansion / hold / reduction) | plan-ceo-review |
| 7 | Complexity smell threshold — >8 files or >2 new abstractions = scope challenge | plan-eng-review |
| 8 | Mechanical vs taste decision classification in auto-review mode | autoplan |
| 9 | Confidence gate with residual promotion (0.50 threshold + cross-persona) | document-review |
| 10 | Boil the Lake reframing — completeness is cheap with AI, shortcuts are legacy thinking | gstack ETHOS |
| 11 | "Resolve Before Planning" vs "Deferred to Planning" distinction | ce:brainstorm |
| 12 | Decomposition check before clarification (flag multi-subsystem requests first) | superpowers |
| 13 | Planning-time vs execution-time unknowns explicitly separated | ce:plan-beta |
| 14 | Implementation unit as structured object with required fields (not just a task) | ce:plan-beta |
| 15 | Conditional external research driven by repo findings (thin vs established layer) | ce:plan-beta |
