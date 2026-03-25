# Sources

This file tracks every source skill used in the superplanning unified flow, what was taken from it, and how it was adapted.

---

## Source Skills

| Source Skill | Repository | What Was Used | Adapted How | Phase(s) |
|---|---|---|---|---|
| `ce:brainstorm` | compound-engineering | Scope classification (Lightweight/Standard/Deep), requirements document template with stable IDs (R1, R2...), interaction rules (one question at a time, single-select multiple choice, AskUserQuestion), escape hatch for impatient users, Phase 0 mode detection, Phase 4 handoff format | Scope classification integrated into Phase 0 as automatic inference rather than user-facing choice; requirements template expanded with Key Decisions and Outstanding Questions tables | 0, 1, 2, 3, 7 |
| `office-hours` (gstack) | gstack | Six forcing questions (Q1–Q6) with push patterns and red flags, stage-routing table (pre-product / has users / paying / pure eng), anti-sycophancy rules, banned phrases table, pushback patterns (5 named patterns), two-push rule, Boil the Lake principle | Forcing questions extracted verbatim into references/forcing-questions.md; stage routing became a routing table in the same file; anti-sycophancy rules extracted into references/anti-sycophancy-rules.md with Boil the Lake added | 2 |
| `ce:plan-beta` | compound-engineering | Implementation unit structure (Goal, Requirements trace, Dependencies, Files, Approach, Patterns, Test scenarios, Verification), quality bar checklist, planning-time unknowns classification (blocker vs deferred), handoff completeness test, Phase 5 handoff format | Implementation unit template adapted to add "Planning-time unknowns" field; quality bar checklist integrated as Gate 4→5 | 1, 4, 7 |
| `plan-ceo-review` (gstack) | gstack | 18 CEO/Product cognitive patterns, scope modes (EXPANSION / SELECTIVE EXPANSION / HOLD SCOPE / REDUCTION), Prime Directives (6), premise challenge (5-step sequence), permission to scrap | Scope modes moved to Phase 5 CEO Review as a user-facing single-select choice; Prime Directives integrated as non-negotiable checklist; 18 cognitive patterns extracted to references/cognitive-patterns.md | 2, 5 |
| `plan-eng-review` (gstack) | gstack | Engineering review structure (4 sections: Scope Challenge, Architecture, Code Quality, Test Review), complexity smell threshold (>8 files or >2 abstractions), coverage diagram concept, 15 engineering cognitive patterns, auto-decision mode for mechanical vs taste decisions | 4-section structure preserved; complexity smell threshold integrated as Gate 4→5 condition and Phase 5 trigger; 15 patterns extracted to references/cognitive-patterns.md | 4, 5 |
| `plan-design-review` (gstack) | gstack | 0–10 rating dimensions, fix-to-10 methodology, 12 design cognitive patterns, AI slop detection | Rating dimensions expanded for Phase 5 (added Error recovery, Empty states, Accessibility signals); fix-to-10 rule made explicit; 12 patterns extracted to references/cognitive-patterns.md | 5 |
| `document-review` | compound-engineering | Multi-persona parallel dispatch, confidence gate (0.50 threshold), residual promotion rules (cross-persona corroboration, concrete blocking risk), contradiction resolution (tradeoff framing, not merged verdict), autofix vs present classification | Confidence gate applied to Brainstorm mode review; autofix vs present classification integrated into Phase 5 output instructions | 5 |
| `document-review` agents | compound-engineering | Six review persona definitions: coherence-reviewer, feasibility-reviewer, product-lens-reviewer, design-lens-reviewer, security-lens-reviewer, scope-guardian-reviewer; each with specific activation conditions, checks, and output formats | Persona definitions extracted to references/review-personas.md; activation conditions refined to be document-content-driven rather than mode-driven | 5 |
| `deepen-plan-beta` | compound-engineering | Confidence gap scoring algorithm (base score + trigger count + risk bonus + critical section bonus), section-to-research-agent mapping, selective deepening (only top 2–5 sections), structure preservation rule | Scoring algorithm simplified to three additive factors; "top 2–5" threshold preserved; selective strengthening rule made explicit | 6 |
| `autoplan` (gstack) | gstack | Sequential review pipeline (CEO → Design → Eng, each must complete before next), mechanical vs taste decision classification | Sequential pipeline preserved as Review Gauntlet; auto-decision mode for mechanical choices kept as optional mode | 5 |
| `plan-product` (agent-os) | agent-os | Product document suite (mission.md, roadmap.md, tech-stack.md), sequential generation with approval gates, doc templates | Templates adapted and expanded; MVP plan added as an intermediate document; approval gate between each document preserved | 3 |
| `mvp-creator` | rails-claude-code | Competitive landscape research methodology, three-layer synthesis (tried-and-true / new-and-popular / first-principles), competitor research prompts, MVP deliverables checklist, SDD handoff format | Three-layer synthesis integrated into Phase 1 New Product mode; competitor research compressed to 2–5 competitors with L1/L2/L3 structure | 1, 3, 7 |
| `ce:brainstorm` (brainstorming) | superpowers | 2–3 approaches with honest pros/cons as single-select multiple choice, visual companion concept (not used), spec review loop (not used) | Approach presentation format preserved; visual companion excluded (scope); spec review loop integrated as artifact storage conventions | 2 |
| `shape-spec` | compound-engineering | Spec folder structure, planning-time vs execution-time unknowns distinction, "resolve before planning" vs "deferred to planning" classification | Folder structure adapted to `docs/plans/` and `docs/brainstorms/` conventions; unknown classification language preserved verbatim | 3, 4 |
| `ce:ideate` | compound-engineering | Divergent ideation with parallel sub-agents, codebase scan methodology, flow analysis | Divergent ideation made conditional (Deep scope or user-locked-in signal); parallel sub-agents preserved; flow analysis integrated into Phase 1 New Feature mode | 1, 2 |
| `feasibility-reviewer` | compound-engineering | Shadow path tracing methodology (happy / nil / empty / upstream error for every data flow), architecture reality check, performance feasibility check | Shadow path tracing elevated to Prime Directive #3 in CEO Review; also embedded in Feasibility Reviewer persona | 5 |

---

## What Was Not Used

Some elements from source skills were evaluated and excluded:

| Element | Source | Why Excluded |
|---------|--------|-------------|
| Visual companion (side-by-side wireframe generation) | superpowers brainstorming | Requires image generation capability; not universally available |
| YC Demo Day pitch generator | office-hours | Out of scope for planning flow; pitch is a separate artifact type |
| Brand guide generation | plan-product (agent-os) | Optional appendix; kept as user-requestable but not in default flow |
| Spec review loop (iterative refinement rounds) | superpowers brainstorming | Covered by Phase 5 validation gauntlet; redundant loop would add friction |
| Full spec diff / changelog tracking | ce:plan-beta | Adds complexity without corresponding value for single-session flow |
| Canary / post-deploy monitoring | various | Post-implementation; outside planning scope |

---

## Design Decisions

### Why three modes instead of one?

The source skills split planning into distinct tools (brainstorm, plan-product, plan-eng-review). A unified flow reduces friction: users don't need to know which skill applies to their situation. Mode detection in Phase 0 handles routing.

### Why extract reference files instead of embedding?

SKILL.md would exceed practical reading limits with all persona definitions, cognitive patterns, and forcing questions inline. Reference files keep the main flow readable while preserving completeness. The main flow loads references only when they're needed for a specific phase.

### Why sequential review gauntlet instead of parallel?

The source skills (autoplan) explicitly require sequential CEO → Design → Eng review because each review builds on prior findings. CEO Review may change scope, which affects what Design Review evaluates. Design Review may surface UX gaps that Engineering Review must account for in test coverage. Parallelizing would produce conflicting findings based on different assumptions about scope.

### Why confidence gate at 0.50?

Taken directly from document-review. Below 0.50 confidence, a finding is more likely to be noise than signal. Storing as residuals (promoted when corroborated) prevents false positives while preserving the insight if it turns out to be real.

### Why Boil the Lake in the anti-sycophancy rules?

Completeness being near-free with AI is a behavioral nudge: the planning flow should not optimize for appearing small and manageable. The completeness norm belongs in interaction discipline (alongside "take a position") because both rules push against the same failure mode — plans that are comfortable rather than correct.
