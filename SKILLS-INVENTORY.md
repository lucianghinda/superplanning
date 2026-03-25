# Skills Inventory

All skills found across the 5 resource repositories that are relevant to the superplanning flow.
Referenced during design of `skills/superplanning/SKILL.md`.

---

## compound-engineering-plugin-main

Base path: `resources/compound-engineering-plugin-main/plugins/compound-engineering/`

### Workflow Skills

| Skill | Path | What It Contributes |
|-------|------|---------------------|
| **ce:brainstorm** | `skills/ce-brainstorm/SKILL.md` | Flow spine: 5 phases (Route→Understand→Explore→Capture→Handoff), scope classification (Lightweight/Standard/Deep), product pressure test, requirements doc with stable IDs (R1, R2...), interaction rules (one Q at a time) |
| **ce:ideate** | `skills/ce-ideate/SKILL.md` | Divergent-then-convergent ideation: 4-6 parallel sub-agents with different frames (pain, unmet need, inversion, assumption-breaking, leverage, extreme cases), adversarial filtering, survivor rubric |
| **ce:plan** | `skills/ce-plan/SKILL.md` | 7-step planning with parallel research agents, SpecFlow analysis, three detail levels (MINIMAL/MORE/A LOT) |
| **ce:plan-beta** | `skills/ce-plan-beta/SKILL.md` | WHAT vs HOW boundary, 5 phases, implementation units (goal/requirements/dependencies/files/approach/patterns/test scenarios/verification), plan quality bar |
| **ce:work** | `skills/ce-work/SKILL.md` | Execution: inline/serial/parallel subagent modes, swarm mode for 10+ tasks |
| **ce:review** | `skills/ce-review/SKILL.md` | Multi-agent code review: 6 steps, ultra-thinking deep dive, multi-angle review, simplification pass |
| **deepen-plan** | `skills/deepen-plan/SKILL.md` | Power mode: discovers all skills, spawns sub-agent per section, runs ALL review agents in parallel |
| **deepen-plan-beta** | `skills/deepen-plan-beta/SKILL.md` | Stress-test approach: confidence gap scoring, selects top 2-5 weakest sections, max ~8 targeted agents |
| **document-review** | `skills/document-review/SKILL.md` | Multi-persona parallel review dispatch, confidence gate (<0.50 suppressed), autofix classification, contradiction resolution |

### Document Review Agents

| Agent | Path | Focus |
|-------|------|-------|
| **coherence-reviewer** | `agents/document-review/coherence-reviewer.md` | Contradictions between sections, terminology drift, broken internal references |
| **feasibility-reviewer** | `agents/document-review/feasibility-reviewer.md` | Shadow path tracing (happy/nil/empty/error), architecture reality check, performance feasibility |
| **product-lens-reviewer** | `agents/document-review/product-lens-reviewer.md` | Premise challenge ("right problem?"), inversion ("what would make this fail?"), 80/20 analysis |
| **design-lens-reviewer** | `agents/document-review/design-lens-reviewer.md` | 0-10 rating per dimension, AI slop detection, interaction state coverage |
| **security-lens-reviewer** | `agents/document-review/security-lens-reviewer.md` | Attack surface inventory, auth/authz gaps, plan-level threat model |
| **scope-guardian-reviewer** | `agents/document-review/scope-guardian-reviewer.md` | Right-sizing, abstraction justification, complexity challenge (>8 files or >2 abstractions triggers) |

### Code Review Agents

| Agent | Path | Focus |
|-------|------|-------|
| **correctness-reviewer** | `agents/review/correctness-reviewer.md` | Off-by-one errors, null propagation, race conditions, broken error propagation |
| **security-reviewer** | `agents/review/security-reviewer.md` | Injection vectors, auth bypass, secrets-in-code, full attack path tracing |
| **testing-reviewer** | `agents/review/testing-reviewer.md` | Untested branches, false confidence tests, brittle implementation-coupled tests |
| **performance-reviewer** | `agents/review/performance-reviewer.md` | N+1 queries, unbounded memory growth, missing pagination, blocking I/O |
| **maintainability-reviewer** | `agents/review/maintainability-reviewer.md` | Premature abstraction, unnecessary indirection, dead code, naming |
| **reliability-reviewer** | `agents/review/reliability-reviewer.md` | Missing error handling on I/O, retry loops, timeouts, cascading failure paths |
| **api-contract-reviewer** | `agents/review/api-contract-reviewer.md` | Breaking changes, missing versioning, inconsistent error shapes |
| **data-migrations-reviewer** | `agents/review/data-migrations-reviewer.md` | Swapped ID/enum mappings, irreversible migrations, deploy-window safety |
| **code-simplicity-reviewer** | `agents/review/code-simplicity-reviewer.md` | YAGNI rigor, LOC reduction, abstraction challenging |
| **architecture-strategist** | `agents/review/architecture-strategist.md` | SOLID principles, circular dependencies, component boundary checking |
| **performance-oracle** | `agents/review/performance-oracle.md` | Big-O analysis, 10x/100x/1000x projections, performance budgets |
| **security-sentinel** | `agents/review/security-sentinel.md` | OWASP Top 10, risk matrix, remediation roadmap |
| **data-integrity-guardian** | `agents/review/data-integrity-guardian.md` | Migration reversibility, transaction boundaries, referential integrity |
| **data-migration-expert** | `agents/review/data-migration-expert.md` | Production data verification, swapped value detection, SQL verification queries |
| **agent-native-reviewer** | `agents/review/agent-native-reviewer.md` | Action/context parity between UI and agent tools |

### Workflow Agents

| Agent | Path | Focus |
|-------|------|-------|
| **spec-flow-analyzer** | `agents/workflow/spec-flow-analyzer.md` | User flow mapping, gap finding (unhappy paths, state transitions, permission boundaries), specific question formulation |
| **bug-reproduction-validator** | `agents/workflow/bug-reproduction-validator.md` | Systematic bug reproduction, 6-category classification (Confirmed/Cannot Reproduce/Not a Bug/Environmental/Data/User Error) |

---

## gstack-main

Base path: `resources/gstack-main/`

| Skill | Path | What It Contributes |
|-------|------|---------------------|
| **office-hours** | `office-hours/SKILL.md` | Two modes (Startup: 6 forcing questions, Builder: design thinking), anti-sycophancy rules, premise challenge, landscape awareness via WebSearch, pushback patterns |
| **autoplan** | `autoplan/SKILL.md` | Sequential review pipeline (CEO→Design→Eng), 6 auto-decision principles, taste decision classification |
| **plan-ceo-review** | `plan-ceo-review/SKILL.md` | 4 scope modes, nuclear scope challenge, 18 cognitive patterns (Bezos, Grove, Munger, Jobs...), "Boil the Lake" completeness |
| **plan-eng-review** | `plan-eng-review/SKILL.md` | 4 review sections (Architecture, Code Quality, Tests, Performance), 15 cognitive patterns, complexity check |
| **plan-design-review** | `plan-design-review/SKILL.md` | 0-10 rating per dimension, 9 design principles, 12 cognitive patterns, fix-to-10 methodology |
| **design-consultation** | `design-consultation/SKILL.md` | 7 phases, competitive research, three-layer synthesis, coherent design proposal, AI slop anti-patterns |

---

## superpowers-main

Base path: `resources/superpowers-main/`

| Skill | Path | What It Contributes |
|-------|------|---------------------|
| **brainstorming** | `skills/brainstorming/SKILL.md` | 9-step checklist, visual companion (browser-based mockup server), one question at a time, 2-3 approaches with pros/cons, spec review loop (max 3 iterations) |
| **visual-companion** | `skills/brainstorming/visual-companion.md` | Local HTTP server for HTML mockups, CSS utility classes (A/B/C options, cards, pros/cons), events file as JSONL |
| **writing-plans** | `skills/writing-plans/SKILL.md` | Bite-sized TDD steps (2-5 min: RED→GREEN→REFACTOR), plan review loop via subagent |
| **executing-plans** | `skills/executing-plans/SKILL.md` | Load plan, execute tasks, mark in_progress/completed, stop-and-ask when blocked |
| **subagent-driven-development** | `skills/subagent-driven-development/SKILL.md` | Fresh subagent per task, two-stage review (spec + code quality), DONE/DONE_WITH_CONCERNS/NEEDS_CONTEXT/BLOCKED status protocol |
| **verification-before-completion** | `skills/verification-before-completion/SKILL.md` | Iron Law: no completion claims without fresh verification evidence. Gate: IDENTIFY→RUN→READ→VERIFY→CLAIM |

### Reviewer Prompts (used as subagents)

| Prompt | Path | Focus |
|--------|------|-------|
| **spec-document-reviewer** | `skills/brainstorming/spec-document-reviewer-prompt.md` | Completeness, consistency, clarity, scope, YAGNI — only flags issues that cause real implementation problems |
| **plan-document-reviewer** | `skills/writing-plans/plan-document-reviewer-prompt.md` | Completeness, spec alignment, task decomposition, buildability |
| **spec-reviewer** | `skills/subagent-driven-development/spec-reviewer-prompt.md` | "Do not trust the implementer's report" — independently reads actual code |
| **code-quality-reviewer** | `skills/subagent-driven-development/code-quality-reviewer-prompt.md` | Single responsibility, independent units, file size growth |

---

## agent-os-main

Base path: `resources/agent-os-main/commands/agent-os/`

| Skill | Path | What It Contributes |
|-------|------|---------------------|
| **plan-product** | `plan-product.md` | Interactive conversation creating mission.md, roadmap.md, tech-stack.md in `agent-os/product/` |
| **shape-spec** | `shape-spec.md` | 9-step spec creation: clarify→visuals→references→product context→standards→folder name→structure→complete→ready |
| **discover-standards** | `discover-standards.md` | Finds unusual/tribal/consistent patterns in codebase, drafts standards, updates index.yml |
| **inject-standards** | `inject-standards.md` | Auto-suggests or explicitly injects standards from index into conversation/skill/plan |

---

## rails-claude-code-main

Base path: `resources/rails-claude-code-main/`

| Skill | Path | What It Contributes |
|-------|------|---------------------|
| **spec-driven-development** | `spec-driven-development/agents/spec-driven-development.md` | 4 phases (Product Planning→Shape Spec→Create Tasks→Implement), standards system with index.yml, task groups with self-contained Claude Code prompts |
| **mvp-creator** | `mvp-creator/agents/mvp-creator.md` | Research phase (2-5 competitors via WebSearch), discovery questions, Research Report + MVP Business Plan + Brand Guide + Technical Guide + Claude Setup |

---

## Key Cross-Cutting Patterns (by role in superplanning)

### For Phase 0 (INTAKE & ROUTE)
- ce:brainstorm Phase 0 — resume check, scope classification
- office-hours Phase 1 — context gathering, mode selection

### For Phase 1 (GROUND)
- ce:brainstorm Phase 1.1 — existing context scan
- ce:plan-beta Phase 1 — parallel research agents (repo-research-analyst, learnings-researcher)
- mvp-creator Phase 1 — competitor research
- design-consultation — three-layer synthesis

### For Phase 2 (CHALLENGE & EXPLORE)
- office-hours Phase 2A — 6 forcing questions, anti-sycophancy rules, pushback patterns
- plan-ceo-review Step 0A — premise challenge
- ce:brainstorm Phase 1.2-1.3 — product pressure test, collaborative dialogue
- ce:ideate Phases 2-3 — divergent ideation, adversarial filtering

### For Phase 3 (DEFINE)
- ce:brainstorm Phase 3 — requirements doc template with stable IDs
- plan-product — mission/roadmap/tech-stack generation
- mvp-creator Phases 2-3 — discovery questions, quality checklists

### For Phase 4 (STRUCTURE)
- ce:plan-beta Phases 3-4 — implementation units, plan quality bar, templates
- superpowers writing-plans — bite-sized TDD steps
- shape-spec — spec folder structure

### For Phase 5 (VALIDATE)
- document-review — multi-persona dispatch, confidence gate, autofix
- plan-ceo-review — 18 cognitive patterns, scope modes
- plan-eng-review — 4 review sections, 15 cognitive patterns
- plan-design-review — 0-10 ratings, fix-to-10
- autoplan — sequential pipeline, 6 decision principles

### For Phase 6 (DEEPEN)
- deepen-plan-beta — confidence gap scoring, section-to-agent mapping

### For Phase 7 (HAND OFF)
- ce:brainstorm Phase 4 — handoff options
- ce:plan-beta Phase 5 — final review and handoff
- mvp-creator Phase 5 — SDD handoff
