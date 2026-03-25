# Superplanning: Design Rationale

Why each integrated concept belongs, how it helps product development, and how it connects to product success and user happiness.

This document justifies every major design decision in `skills/superplanning/SKILL.md`. It answers not just *what* is integrated but *why* — grounded in product development realities, not just technical convenience.

---

## The Problem This Skill Solves

Most products fail not because the code was bad — they fail because the wrong thing was built. The gap between "idea" and "shipped product users love" is littered with:

- Assumptions that were never challenged
- Requirements that were invented during implementation rather than agreed upfront
- Plans that looked thorough but had no structure for catching failure modes
- Reviews that validated what the builder already believed instead of stress-testing it
- Good intentions that became bad scope — either too narrow to matter or too broad to ship

Superplanning attacks this gap with a structured, opinionated flow that forces the hard questions before a line of code is written.

---

## Integrated Concepts and Their Justification

---

### 1. Handoff Completeness Test

**What it is:** Before leaving any phase, ask: *"What would the next phase still have to invent if we stopped here?"* If the answer is "product behavior, scope boundaries, or success criteria" — the current phase is not done.

**Why it works:**
Most planning processes fail at the seams between phases. A brainstorm "finishes" when the conversation runs out of energy, not when the output is actually usable. The handoff test makes completion *testable* rather than *felt*. It's a forcing function that catches lazy handoffs.

**How it helps product development:**
Implementation engineers spend enormous time inventing product decisions on the fly — "the spec didn't say what to do when the user has no data, so I'll just show a blank screen." That decision, made in five seconds, becomes a UX bug six months later. The handoff test prevents those decisions from being silently deferred.

**How it makes products successful:**
Products with clear, complete requirements ship faster and with fewer rework cycles. Every hour spent filling spec gaps during implementation is 3–5x more expensive than filling them during requirements. Completeness at handoff is a multiplier on execution speed.

**How it makes users happy:**
Users experience the gaps. Empty states that weren't designed. Error messages that weren't written. Edge cases that just break. The handoff test ensures these aren't discovered in production.

---

### 2. Stage-Routed Forcing Questions

**What it is:** Six questions that expose the real strength of a product idea (Demand Reality, Status Quo, Desperate Specificity, Narrowest Wedge, Observation & Surprise, Future-Fit) — but routed by product stage. Pre-product founders get Q1–Q3. Teams with paying customers get Q4–Q6. Engineering initiatives get Q2 and Q4 only.

**Why it works:**
The wrong question at the wrong stage wastes time and breaks trust. Asking a team with 500 paying customers to prove demand is insulting and irrelevant. Asking a pre-product founder about their narrowest wedge before they've validated basic demand skips the foundation. Stage routing makes the questions land where they actually hurt — and that's where they're useful.

**How it helps product development:**
Each stage of product development has a different primary risk. Early stage: building the wrong thing. Mid stage: building too broadly before nailing the core. Late stage: failing to expand the wedge. The questions are calibrated to the risk that actually kills products at each stage.

**How it makes products successful:**
The hardest and most valuable questions to answer are the ones founders and PMs instinctively avoid. Forcing those questions into the process — with specific pushback patterns for vague answers — converts fuzzy beliefs into falsifiable claims. Products built on falsifiable claims survive contact with reality better than products built on assumptions.

**How it makes users happy:**
Q3 (Desperate Specificity) asks: *"Name the actual human who needs this most. What keeps them up at night?"* Products built with this level of customer specificity solve real problems rather than imagined ones. Real-problem products earn loyalty. Imagined-problem products earn churn.

---

### 3. Anti-Sycophancy with Specific Prohibitions

**What it is:** Named banned phrases ("That's interesting," "That could work," "There are many ways to think about this") replaced with a rule: take a position AND state what evidence would change it.

**Why it works:**
Sycophancy is the default mode of AI assistants. It feels helpful but produces the opposite of critical thinking. By naming the specific phrases that signal sycophancy and replacing them with a concrete behavioral rule, the skill builds discipline into every interaction rather than relying on general "be direct" intent.

**How it helps product development:**
The most dangerous moment in a product review is when someone with standing (a founder, a senior PM, a lead engineer) presents a flawed idea with confidence. Without anti-sycophancy rules, every tool defaults to finding the good in the idea rather than exposing the flaw. Flaws caught in planning cost nothing to fix. Flaws caught after shipping cost everything.

**How it makes products successful:**
The best products come from ideas that survived rigorous challenge. The skill doesn't kill ideas — it strengthens the ones that deserve to be built and redirects the ones that don't. "Your idea survives the pressure test" is a much stronger signal to proceed than "your idea seems interesting."

**How it makes users happy:**
Users don't benefit from the ideas that felt good in the planning room. They benefit from the ideas that actually solved a real problem. Anti-sycophancy is the mechanism that separates ideas that feel good from ideas that are good.

---

### 4. Confidence Gap Scoring with Selective Deepening

**What it is:** After a plan is drafted, each section is scored: trigger count (checklist problems found) + risk bonus (high-risk topic) + critical-section bonus (Key Decisions, System-Wide Impact, etc.). Only the top 2–5 sections by score are deepened with targeted research.

**Why it works:**
Generic "improve the plan" instructions produce uniformly padded plans — every section gets slightly better but none gets meaningfully stronger. Scoring and selection concentrates improvement where the plan is actually weakest, not where it's easiest to add words.

**How it helps product development:**
The sections that score highest are the ones most likely to cause implementation problems. A technical decision with no rationale becomes a religious argument during code review. A system-wide impact section that missed a major integration becomes a production incident. Selective deepening addresses real gaps, not cosmetic ones.

**How it makes products successful:**
Risk weighting ensures that high-stakes areas (auth, payments, data migrations, external APIs) get deeper scrutiny regardless of how confidently they were written. The most catastrophic product failures happen in exactly these areas — not because nobody cared, but because the plan looked complete and nobody looked harder.

**How it makes users happy:**
Users experience the consequences of unaddressed risks — failed payments, lost data, security breaches, broken integrations. Targeted deepening on high-risk sections means the parts of the system that affect users most severely are the parts that get the most scrutiny.

---

### 5. Shadow Path Tracing

**What it is:** For every new data flow, trace not just the happy path but three shadow paths: nil input, empty/zero-length input, and upstream error.

**Why it works:**
Happy paths are what engineers design. Shadow paths are what users encounter. The asymmetry is systematic — no one intentionally skips error handling, but the happy path is designed first and shadow paths are designed when time allows. Making shadow path tracing explicit changes the default.

**How it helps product development:**
Plans that trace shadow paths produce implementations with fewer last-minute surprises. "What happens if the API is down?" answered in the plan is an architectural decision. Answered during implementation, it's a scramble. Shadow paths belong in requirements, not in incident postmortems.

**How it makes products successful:**
Production stability is a function of how many shadow paths were considered before shipping. The applications users trust most — the ones they pay for, the ones they build workflows around — are the ones that handle failure gracefully instead of crashing or corrupting data.

**How it makes users happy:**
A product that handles errors gracefully feels professional, trustworthy, and finished. A product that crashes on empty input or shows a raw error message when an API fails feels amateur, regardless of how good the happy path experience is. Shadow path tracing is the mechanism that makes the difference.

---

### 6. Scope Mode Selection Committed Throughout

**What it is:** At the start of any review, choose one of four modes — SCOPE EXPANSION (dream big), SELECTIVE EXPANSION (hold scope, cherry-pick additions), HOLD SCOPE (bulletproof as-is), SCOPE REDUCTION (cut to minimum). The mode is chosen once and never silently shifted.

**Why it works:**
Review processes without a declared scope mode oscillate. The reviewer expands when expansion feels productive, holds when the founder pushes back, and reduces when running out of time. The result is a plan that was inconsistently reviewed and has no coherent scope. A committed mode creates a consistent reviewing posture.

**How it helps product development:**
SCOPE REDUCTION is particularly valuable. It forces the question: "What is the minimum version that proves the hypothesis?" This is the question most planning processes never ask because everyone defaults to "let's build all of it." A plan that goes through a reduction pass ships faster, fails faster (if it's wrong), and costs less to abandon (if it's the wrong thing entirely).

**How it makes products successful:**
Most products fail from over-scope, not under-scope. Features that were added "because they might be useful" dilute focus, extend timelines, and hide the core value proposition. The scope modes create a structured mechanism for controlling this.

**How it makes users happy:**
Users don't want more features — they want the right features, done well. A product built from a HOLD SCOPE or SCOPE REDUCTION pass ships a smaller, more polished set of capabilities that users can actually learn and love. A product built without scope discipline ships a large, rough set of capabilities that users find confusing.

---

### 7. Complexity Smell Threshold

**What it is:** If a plan touches >8 files OR introduces >2 new classes/services, a scope reduction challenge is automatically triggered. The reviewer must proactively recommend a minimal version before proceeding.

**Why it works:**
Complexity accumulates invisibly. "We need one more service" said 12 times produces a system that nobody can understand. By setting a specific numeric threshold, the skill creates a moment of forced reflection at the right time — before the complexity is implemented, not after.

**How it helps product development:**
Complex implementations are slow to build, hard to test, and fragile under change. The threshold catches overbuilding early, when the cost of redesign is a conversation rather than a rewrite. It also challenges engineers to find simpler solutions — and simpler solutions are often better solutions.

**How it makes products successful:**
Simple systems have fewer bugs, deploy faster, are easier to maintain, and are easier to onboard new engineers onto. Every unnecessary abstraction is technical debt that was accrued before the first line of production code was written.

**How it makes users happy:**
Users never see the internal complexity, but they feel its consequences: slower development cycles, more bugs, features that never ship because "the architecture wasn't ready." Controlling complexity at planning time produces products that improve faster.

---

### 8. Mechanical vs Taste Decision Classification

**What it is:** Decisions are classified into mechanical (one clearly correct answer — auto-decided silently) and taste (reasonable people could disagree — auto-decided but surfaced at a final gate). The user reviews only the taste decisions.

**Why it works:**
Review fatigue is real. If every decision requires user input, the user either stops engaging or approves everything without reading. Filtering to only the decisions where the user's judgment actually matters focuses attention where it creates value.

**How it helps product development:**
Taste decisions are the ones that reflect product philosophy: close architectural approaches, borderline scope inclusions, tradeoffs between speed and completeness. These are worth the founder's or PM's attention. Mechanical decisions (always test, always handle errors, always add logging) are not.

**How it makes products successful:**
Products where the key decision-makers are engaged on the right questions move faster and ship with more coherent vision. The classification mechanism is what makes engagement sustainable — it doesn't ask for input on everything, only on the things that matter.

**How it makes users happy:**
Coherent product vision produces coherent user experience. When founders and PMs are focused on the taste decisions, the products they build reflect intentional choices rather than accumulated defaults.

---

### 9. Confidence Gate with Residual Promotion

**What it is:** Review findings below 0.50 confidence are suppressed — but stored. They can be promoted if a second reviewer independently flags the same issue (cross-persona corroboration) or if the finding describes a concrete blocking risk.

**Why it works:**
Noise is the enemy of useful feedback. A review with 40 findings at mixed confidence levels is harder to act on than a review with 12 high-confidence findings. The gate reduces noise. But false negatives are dangerous — a weak signal from one reviewer that's independently confirmed by another is stronger than a strong signal from one reviewer alone. The residual promotion handles this correctly.

**How it helps product development:**
Review fatigue causes teams to stop reading reviews carefully. When every review produces the same wall of findings, reviewers skim. When reviews are focused, filtered, and prioritized, reviewers engage. The confidence gate and residual promotion produce reviews that are worth reading.

**How it makes products successful:**
The findings that matter most are the P0s and P1s — the ones that will cause real problems in production or dramatically worsen user experience. A review that reliably surfaces these without burying them in noise is a review that actually improves products.

**How it makes users happy:**
The findings that pass the confidence gate are the findings with real user impact. Coherence gaps that cause confusion. Feasibility issues that cause features to not work. Security issues that expose user data. A gate that reliably surfaces these is a gate that directly protects users.

---

### 10. Boil the Lake Reframing

**What it is:** AI makes completeness near-free. A "lake" (100% coverage, all edge cases, complete error handling) is boilable — the delta between 80% and 100% is minutes, not days. An "ocean" (multi-quarter rewrite) is not boilable. Always recommend the complete option over shortcuts.

**Why it works:**
Planning habits formed in a world of expensive human engineering time created a culture of deliberate incompleteness. "We'll handle that edge case later" was rational when later meant an engineer-day. With AI assistance, "later" means minutes. The reframing changes the calculus: shortcuts now cost roughly the same in time but far more in quality debt.

**How it helps product development:**
Teams that internalize "Boil the Lake" stop deferring the hard parts. Edge cases are handled in the first pass. Error paths are designed, not patched. Observability is built in, not bolted on. The result is a development culture where the first shipped version is more complete than the fifth version used to be.

**How it makes products successful:**
Complete products earn user trust faster. They have fewer embarrassing gaps. They require less reactive engineering (fixing the edge cases that users discover in production). Engineering time redirects from maintenance to new capabilities.

**How it makes users happy:**
Users encounter the 20% constantly. The missing empty state. The unhandled error. The feature that almost worked. Boiling the lake means users encounter a finished product rather than an 80% product where every session has a chance of hitting something broken.

---

### 11. "Resolve Before Planning" vs "Deferred to Planning" Distinction

**What it is:** Outstanding questions in a requirements document are explicitly classified: Resolve Before Planning (true product blockers that would change behavior or scope) vs Deferred to Planning (technical questions that can be answered during implementation research).

**Why it works:**
Without this classification, all outstanding questions look the same. Engineers don't know whether to proceed or wait. PMs don't know which questions need their input. The classification creates a clear decision tree: product questions must be answered now, technical questions can be answered later.

**How it helps product development:**
Product-level ambiguity is the most expensive kind. If "which users can access this feature?" is unanswered when planning starts, the planner must either invent an answer (likely wrong) or ask mid-planning (expensive context switch). The explicit classification makes this ambiguity visible before it causes damage.

**How it makes products successful:**
Products with clear product decisions before implementation starts ship more consistently. There are fewer mid-sprint pivots, fewer rework cycles caused by product ambiguity discovered during development, and fewer "we'll fix that in v2" decisions made under pressure.

**How it makes users happy:**
Users experience the consequences of product decisions made under pressure. Permission models that weren't fully thought through. Data visibility that was decided in a hurry. The classification mechanism ensures these decisions get proper attention before they're baked in.

---

### 12. Decomposition Before Clarification

**What it is:** If a request describes multiple independent subsystems, flag it immediately — before asking any clarifying questions. Help the user decompose into sub-projects first, then apply the full planning flow to each piece.

**Why it works:**
Asking clarifying questions about a scope that should be decomposed is wasted work. Every answer refines details of a project structure that will change. The decomposition check catches this pattern early and redirects energy to the right level of problem-framing.

**How it helps product development:**
Multi-subsystem projects fail at integration. When each subsystem is planned independently, the integration points, data contracts, and dependencies between subsystems become explicit. When everything is planned as one monolithic effort, these integration points are discovered late — when they're most expensive.

**How it makes products successful:**
Decomposed products ship incrementally. Each sub-project delivers value independently. Users can use the product before the entire vision is complete. Monolithic plans delay value delivery until everything is done.

**How it makes users happy:**
Users benefit from software that exists. A decomposed project plan means something ships sooner. The first sub-project, shipped and working, creates real user value while subsequent phases are being built.

---

### 13. Planning-Time vs Execution-Time Unknowns Separated

**What it is:** The plan explicitly distinguishes between questions knowable from repo context and user choice (planning-time, answered in the plan) and questions that require running code or seeing test failures (execution-time, explicitly deferred).

**Why it works:**
Plans that pretend to resolve execution-time unknowns create false certainty. Engineers read "we'll use approach X" and assume X was validated — but it was guessed. When X fails, the discovery happens during implementation, at maximum cost. Explicit deferral changes this: "we expect to use X, but this will be confirmed during implementation."

**How it helps product development:**
Clear delineation between planning and execution reduces the number of times implementation is blocked waiting for a planning decision. Things that can be decided now are decided now. Things that require runtime evidence are explicitly staged for when that evidence is available.

**How it makes products successful:**
Implementation teams that know which decisions are firm and which are provisional can sequence work intelligently. Firm decisions anchor the architecture. Provisional decisions are implemented with explicit flexibility. This produces more adaptable codebases.

**How it makes users happy:**
Users don't care about planning artifacts — but they care about features that work as described. Separating planning decisions from implementation discoveries means users get features that were planned with appropriate confidence rather than features built on guesses that may or may not have been validated.

---

### 14. Implementation Units as Structured Objects

**What it is:** Every unit of implementation work specifies: Goal, Requirements trace, Dependencies, Files (exact paths), Approach, Patterns to follow, Test scenarios, Verification outcomes. Test file paths are required.

**Why it works:**
A task list ("add user authentication") is almost useless to an implementer. A structured unit ("Goal: allow users to sign in with email+password; Files: app/controllers/sessions_controller.rb, spec/controllers/sessions_controller_spec.rb; Test scenarios: valid credentials, invalid password, unknown email, rate limiting") is a complete specification of work. The structure enforces completeness.

**How it helps product development:**
Structured units can be parallelized, estimated, reviewed, and handed off. Unstructured tasks cannot. When work is broken into reviewable units with explicit dependencies, teams can see the critical path, identify bottlenecks, and coordinate without daily status meetings.

**How it makes products successful:**
Implementations that follow structured units have higher test coverage, better adherence to existing patterns, and fewer architectural surprises. The requirement to list test file paths means tests are designed alongside the feature, not as an afterthought.

**How it makes users happy:**
Features that were implemented from structured units, with explicit test scenarios covering edge cases and failure paths, have fewer bugs in production. Users experience fewer "it almost works" moments — the kind of bugs that erode trust.

---

### 15. Conditional External Research from Repo Findings

**What it is:** The decision to do external research is driven by what the codebase scan found. If the technology layer is absent or thin in the codebase → external research is warranted. If it's well-established with existing patterns to follow → skip external research and follow the patterns.

**Why it works:**
Generic "always research everything" produces redundant information for teams that already have well-established patterns. Generic "never research" leaves teams reinventing what they could learn from documentation. The conditional approach is more accurate.

**How it helps product development:**
External research has cost: time, context, and the risk of importing patterns that don't fit the codebase. That cost is worth paying when the codebase has no guidance. It's not worth paying when the codebase already has multiple good examples to follow.

**How it makes products successful:**
Codebases that consistently follow established patterns are easier to maintain, onboard new engineers onto, and extend with new features. Research-when-needed ensures new work fits the existing pattern language rather than importing foreign patterns that create inconsistency.

**How it makes users happy:**
Consistent internal patterns mean features behave consistently from the user's perspective. "Why does this screen work differently from that screen?" is a question that arises from inconsistent implementation patterns. Codebase consistency, maintained by following established patterns, translates directly to UX consistency.

---

## How the Concepts Combine

Each concept addresses a different point of failure in the product development process. Together, they create a system where:

1. **The right problem is identified** — Forcing questions, anti-sycophancy, and decomposition checks ensure the planning session is working on the real problem, not a comfortable approximation of it.

2. **The scope is right** — Scope mode selection, complexity smell threshold, and the Boil the Lake principle create a tension between "enough to matter" and "small enough to ship."

3. **The requirements are complete** — The handoff completeness test, Resolve vs Deferred classification, and stable requirement IDs ensure requirements are actually usable by the next phase.

4. **The plan is grounded** — Structured implementation units, planning vs execution separation, and conditional external research produce plans that implementers can execute without inventions.

5. **The plan is stress-tested** — Sequential review phases (CEO → Design → Eng), confidence gap scoring, shadow path tracing, and selective deepening catch different categories of problems at different levels of the plan.

6. **The review is focused** — The confidence gate, residual promotion, mechanical vs taste classification, and committed scope modes produce reviews that are worth reading and acting on.

The result is a planning process where the first shipped version is something users actually want, built in a way that can be maintained and extended, with fewer surprises in production than any of the individual source skills could achieve alone.

---

## What Superplanning Does Not Do

To be clear about scope boundaries:

- **It does not write code.** Every output is a document, a plan, or a set of requirements. Implementation is a separate phase.
- **It does not replace product judgment.** Taste decisions are surfaced to the human. The skill challenges, structures, and deepens — it does not decide.
- **It does not guarantee success.** A plan that survives all phases of superplanning is a plan with well-examined assumptions and high implementation confidence. It is not a prediction that the product will find market fit. Product-market fit is a market question, not a planning question.
- **It does not run forever.** Each phase has gates and exits. The skill is designed to be completed in a focused session, not to become an infinite refinement loop.
