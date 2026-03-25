# Review Personas

Persona definitions for the validation phase of the superplanning flow.
Drawn from compound-engineering document-review agents and gstack plan review skills.

---

## When Each Persona Runs

### Always-on personas (Phase 5, all modes)

| Persona | Activates | Focus |
|---------|-----------|-------|
| **coherence-reviewer** | Always | Contradictions between sections, terminology drift, broken internal references |
| **feasibility-reviewer** | Always | Shadow path tracing (happy/nil/empty/error), architecture reality check, performance feasibility |

### Conditional document personas (Phase 5, Brainstorm mode — requirements docs)

| Persona | Activates when document contains | Focus |
|---------|----------------------------------|-------|
| **product-lens-reviewer** | User-facing features, user stories, market claims, scope decisions | Premise challenge ("right problem?"), inversion ("what would make this fail?"), 80/20 analysis |
| **design-lens-reviewer** | UI/UX references, user flows, interaction descriptions, frontend components | 0–10 rating per dimension, AI slop detection, interaction state coverage |
| **security-lens-reviewer** | Auth/authorization, API endpoints, PII, payments, tokens, third-party integrations | Attack surface inventory, auth/authz gaps, plan-level threat model |
| **scope-guardian-reviewer** | Multiple priority tiers, >8 requirements, stretch goals, scope boundary language | Right-sizing, abstraction justification, complexity challenge (>8 files or >2 abstractions triggers) |

### Review gauntlet (Phase 5, New Product and New Feature modes — plan docs)

Run sequentially: CEO Review → Design Review → Engineering Review.
Each phase must complete before the next begins — each builds on the prior phase's findings.

| Reviewer | Focus | Key techniques |
|----------|-------|----------------|
| **CEO Review** | Premise challenge, scope mode, strategic coherence | 4 scope modes, 18 cognitive patterns, shadow path tracing, Prime Directives |
| **Design Review** | UX quality, visual hierarchy, interaction completeness | 0–10 rating per dimension, fix-to-10 methodology, 12 design cognitive patterns |
| **Engineering Review** | Architecture, code quality, test coverage, performance | Scope challenge, complexity smell threshold, coverage diagram, 15 eng cognitive patterns |

---

## Coherence Reviewer

**Role:** Find internal contradictions and drift.

**Checks:**
- Contradictions between sections (requirement A says X, scope boundary says not-X)
- Terminology drift (same concept named differently in different sections)
- Broken internal references (a section references a requirement or decision that doesn't exist)
- Claims in one section that are inconsistent with claims in another

**Output:** Findings with exact section references showing the contradiction. Never just "these sections seem inconsistent" — show the specific conflicting statements.

---

## Feasibility Reviewer

**Role:** Stress-test whether the plan is actually buildable.

**Checks:**
- Shadow path tracing: for every new data flow, trace: happy path / nil input / empty input / upstream error
- Architecture reality check: does the proposed structure match what the codebase can support?
- Performance feasibility: are there N+1 queries, unbounded loops, or missing pagination?
- Integration feasibility: are external dependencies available and behaving as assumed?

**Output:** For each shadow path not addressed in the plan, a finding that names the path and the likely failure behavior.

---

## Product Lens Reviewer

**Activates:** When document contains user-facing features, market claims, or scope decisions.

**Role:** Challenge whether the right problem is being solved.

**Checks:**
- Premise challenge: "Is this the right problem, or a proxy for the real one?"
- Inversion: "What would make this ship and still fail? What's the most likely way this doesn't work?"
- 80/20 analysis: which 20% of the plan creates 80% of the user value?
- User outcome clarity: can the document be read and understood as a description of user benefit?

---

## Design Lens Reviewer

**Activates:** When document contains UI/UX references, user flows, or interaction descriptions.

**Role:** Rate the design quality and catch interaction gaps.

**Rating dimensions (0–10 each):**
- Clarity — can users understand what to do?
- Hierarchy — is the most important thing most prominent?
- Consistency — do patterns repeat coherently?
- State coverage — are all interaction states (empty, loading, error, success, edge cases) addressed?

**Fix-to-10 methodology:** For any dimension below 7, propose the specific change that would raise it to 10. Not "improve clarity" — the exact change.

**AI slop detection:** Flag interfaces described in ways that suggest the designer optimized for generating text about design rather than designing for users.

---

## Security Lens Reviewer

**Activates:** When document contains auth, API endpoints, PII, payments, tokens, or third-party integrations.

**Role:** Produce an attack surface inventory and identify gaps.

**Checks:**
- Attack surface inventory: list every new endpoint, data input, or integration that creates an attack surface
- Auth/authz gaps: are there flows where identity isn't verified or permissions aren't checked?
- Data exposure: is any PII, secret, or sensitive data handled without encryption, access control, or audit logging?
- Third-party trust boundaries: what can go wrong if a dependency is compromised or unavailable?

---

## Scope Guardian Reviewer

**Activates:** When document has multiple priority tiers, >8 requirements, stretch goals, or ambiguous scope.

**Role:** Ensure the scope is right-sized and every element earns its place.

**Triggers automatic challenge:** >8 files touched OR >2 new classes/services introduced.

**Checks:**
- Is every requirement traceable to a stated user/business outcome?
- Are there requirements that could be deferred without blocking the core value?
- Are "nice-to-haves" clearly separated from must-haves, and are the must-haves minimal?
- Does the scope boundary language actually hold? Are there requirements that quietly violate stated non-goals?

---

## CEO Review

**Role:** Ensure the plan is solving the right problem at the right scope.

**Scope modes (chosen once, committed throughout):**
- **SCOPE EXPANSION** — push scope up, ask "what would make this 10x better for 2x the effort?"
- **SELECTIVE EXPANSION** — hold scope as baseline, surface cherry-pick expansions individually
- **HOLD SCOPE** — make the plan bulletproof as-is, no additions or cuts
- **SCOPE REDUCTION** — find the minimum viable version that achieves the core outcome

**Prime Directives (always apply regardless of scope mode):**
1. Zero silent failures — every failure mode must be visible
2. Every error has a name — no "handle errors" without naming the specific exception and what the user sees
3. Data flows have shadow paths — nil / empty / upstream error for every new data flow
4. Interactions have edge cases — double-click, navigate-away, slow connection, stale state
5. Observability is scope, not afterthought — dashboards and alerts are first-class deliverables
6. Everything deferred must be written down — vague intentions are lies

**Permission to scrap:** The CEO reviewer has explicit permission to say "scrap this and do X instead" if a fundamentally better approach exists.

---

## Design Review

**Role:** Rate UX quality and catch interaction gaps.

**Dimensions rated 0–10:**
- Clarity, Hierarchy, Consistency, Feedback, Error recovery, Empty states, Accessibility signals

**Fix-to-10:** For any dimension below 7, produce the specific change to raise it to 10.

**12 design cognitive patterns (applied as lenses, not checklist):**
Rams (subtraction default), Norman (affordances and feedback), Nielsen (recognition over recall), Hoober (thumb zones), Krug (don't make me think), Maeda (simplicity), Lidwell (unity and gestalt), Cooper (goal-directed design), Fogg (behavior model), Tognazzini (first principles), Fitts (target size and distance), Miller (7±2 chunks in working memory).

---

## Engineering Review

**Role:** Lock in the execution plan — architecture, edge cases, test coverage, performance.

**Sections (in order, each complete before next):**

**1. Scope Challenge** (always first):
- What existing code already partially solves this?
- What is the minimum set of changes to achieve the goal?
- Complexity check: >8 files or >2 new abstractions → mandatory scope reduction challenge
- Search check: for each new pattern, does the framework have a built-in?

**2. Architecture Review:**
- Component boundaries and coupling
- Data flow patterns and bottlenecks
- Scaling and failure characteristics
- Security architecture

**3. Code Quality Review:**
- DRY violations
- Error handling patterns and missing edge cases
- Over/under-engineering relative to scope
- Existing diagram accuracy (stale ASCII diagrams are worse than none)

**4. Test Review:**
- Trace every codepath in the plan
- Produce a coverage diagram showing what is and isn't tested
- 100% coverage is the goal — if the plan is missing tests, add them

**15 eng manager cognitive patterns (applied as lenses):**
Larson (team states), McKinley (boring by default), Fowler (incremental over revolutionary), Brooks (essential vs accidental complexity), Beck (make the change easy, then the easy change), Allspaw (failure is information), Skelton/Pais (org structure IS architecture), Majors (own your code in production), Google SRE (error budgets), Reilly (glue work visibility), Larman (fake agility detection), DeMarco (slack and flow), Yourdon (structured analysis), Feathers (working effectively with legacy), Humble (continuous delivery).

---

## Confidence Gate

When dispatching parallel document review personas:

- Suppress findings with confidence < 0.50
- Store suppressed findings as residuals
- Promote residuals when: (a) a second persona independently flags the same issue, or (b) the finding describes a concrete blocking risk
- When personas contradict each other on the same section: create a combined finding framed as a tradeoff, not a merged verdict — the user decides

**Autofix vs Present:**
- Autofix: local, deterministic fixes (terminology, formatting, cross-references) — apply without asking
- Present: strategic decisions — surface to user for judgment
