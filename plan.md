# Superplanning: Unified Planning Flow

## Context

The `resources/` folder contains 5 skill repositories (compound-engineering, gstack, superpowers, rails-claude-code, agent-os) with 48+ skills covering brainstorming, planning, validation, and review. The best techniques are scattered across repos — no single repo has the complete picture. This plan creates a unified "superplanning" skill that combines the strongest elements into one coherent flow supporting three modes: **Brainstorm**, **New Product Plan**, and **New Feature Plan**.

## Deliverables

### Skill Files
1. **`skills/superplanning/SKILL.md`** — The main skill file (the unified flow)
2. **`skills/superplanning/references/forcing-questions.md`** — Extracted questioning framework
3. **`skills/superplanning/references/review-personas.md`** — Review persona definitions
4. **`skills/superplanning/references/cognitive-patterns.md`** — Curated cognitive patterns library
5. **`skills/superplanning/references/anti-sycophancy-rules.md`** — Interaction discipline rules
6. **`SOURCES.md`** — Citation file tracking which skills were used/combined and how

### Test Suite (modeled on `resources/superpowers-main/tests/`)
7. **`tests/superplanning/unit/test-helpers.sh`** — Test assertion helpers
8. **`tests/superplanning/unit/test-superplanning.sh`** — 12 behavior verification tests
9. **`tests/superplanning/unit/run-skill-tests.sh`** — Unit test orchestrator
10. **`tests/superplanning/skill-triggering/run-test.sh`** — Single skill-trigger test runner
11. **`tests/superplanning/skill-triggering/run-all.sh`** — Batch trigger test runner
12. **`tests/superplanning/skill-triggering/prompts/*.txt`** — 6 natural language trigger prompts
13. **`tests/superplanning/explicit-skill-requests/run-test.sh`** — Single explicit request test runner
14. **`tests/superplanning/explicit-skill-requests/run-all.sh`** — Batch explicit request runner
15. **`tests/superplanning/explicit-skill-requests/prompts/*.txt`** — 5 explicit request prompts
16. **`tests/run-all-tests.sh`** — Master test runner (all layers)

## Architecture: 7-Phase Flow

The skill has a single spine that all three modes traverse, with mode-adaptive depth at each phase.

### Phase 0: INTAKE & ROUTE
- Detect mode (Brainstorm / New Product / New Feature) from user input
- Resume check: search for existing artifacts (`docs/brainstorms/`, `docs/plans/`, `docs/product/`)
- Scope classification: Lightweight / Standard / Deep
- **Sources:** ce:brainstorm (Phase 0), office-hours (context gathering), plan-product (existing docs check)

### Phase 1: GROUND
- **Brainstorm:** Light repo scan, topic search
- **New Product:** Competitive research via WebSearch (2-5 competitors), three-layer synthesis (tried-and-true / new-and-popular / first-principles)
- **New Feature:** Codebase scan with parallel research agents, external research decision, flow analysis
- **Sources:** ce:brainstorm (1.1), ce:plan-beta (Phase 1), ce:ideate (codebase scan), office-hours (landscape awareness), mvp-creator (competitor research), design-consultation (three-layer synthesis)

### Phase 2: CHALLENGE & EXPLORE
- **Brainstorm:** Product pressure test, collaborative dialogue, propose 2-3 approaches with pros/cons
- **New Product:** 6 forcing questions (Demand Reality, Status Quo, Desperate Specificity, Narrowest Wedge, Observation & Surprise, Future-Fit), premise challenge, anti-sycophancy enforcement
- **New Feature:** Planning questions, lightweight pressure test, optional divergent ideation with parallel sub-agents
- Anti-sycophancy rules apply to ALL modes
- **Gate:** Idea must survive pressure test. Flawed premises stop here with reframe recommendation.
- **Sources:** ce:brainstorm (1.2-1.3, Phase 2), office-hours (forcing questions, anti-sycophancy, pushback patterns), plan-ceo-review (premise challenge), ce:ideate (divergent ideation), superpowers brainstorming (2-3 approaches)

### Phase 3: DEFINE
- **Brainstorm:** Write requirements document with stable IDs (R1, R2...) — problem frame, requirements, success criteria, scope boundaries, key decisions, outstanding questions
- **New Product:** Generate product documents sequentially with approval gates — mission.md, MVP business plan, roadmap.md, tech-stack.md, optional brand guide
- **New Feature:** Write requirements document OR proceed to planning if requirements already clear
- **Gate:** Documents must be complete enough that the next phase doesn't need to invent product behavior.
- **Sources:** ce:brainstorm (Phase 3 template), plan-product (mission/roadmap/tech-stack), mvp-creator (discovery questions, deliverables, quality checklists), shape-spec (spec folder structure)

### Phase 4: STRUCTURE
- **Brainstorm:** Skip (or continue to planning if user wants)
- **New Product:** High-level architecture, break into implementation units (atomic commit-sized), phased delivery for Deep scope
- **New Feature:** Same as Product but grounded in existing codebase — exact file paths, system-wide impact analysis, existing pattern references
- Each unit defines: Goal, Requirements trace, Dependencies, Files, Approach, Patterns, Test scenarios, Verification
- **Gate:** Plan passes quality bar checklist before advancing.
- **Sources:** ce:plan-beta (Phases 3-4, implementation units, plan template), superpowers writing-plans (bite-sized TDD steps), shape-spec (plan structure)

### Phase 5: VALIDATE
- **Brainstorm (requirements doc):** Multi-persona document review — coherence + feasibility always, conditional: product-lens, design-lens, security-lens, scope-guardian. Confidence gate (<0.50 suppressed).
- **New Product:** CEO Review (premise challenge, scope modes, cognitive patterns) + Design Review (0-10 ratings, fix-to-10) + shadow path tracing
- **New Feature:** Full review gauntlet CEO -> Design -> Eng (architecture, code quality, tests, performance). Auto-decision mode available with 6 principles. Taste decisions surfaced at final gate.
- **Gate:** No P0 (critical) findings unresolved. P1 must be addressed or explicitly accepted.
- **Sources:** document-review (multi-persona dispatch, confidence gate, autofix), plan-ceo-review (premise challenge, 18 cognitive patterns), plan-eng-review (4 review sections, 15 cognitive patterns), plan-design-review (0-10 ratings, fix-to-10), autoplan (sequential pipeline, 6 decision principles), feasibility-reviewer (shadow path tracing)

### Phase 6: DEEPEN (Conditional)
- Only for Standard/Deep scope, high-risk topics, or explicit user request
- Score confidence gaps section-by-section, select top 2-5 weakest
- Map sections to targeted research agents, run in parallel
- Strengthen only selected sections, preserve overall structure
- **Sources:** deepen-plan-beta (confidence gap scoring, section-to-agent mapping, selective deepening)

### Phase 7: HAND OFF
- Present mode-appropriate next steps (proceed to planning, start implementation, create issues, review further, done)
- Closing summary with artifacts list, key decisions, recommended next step
- **Sources:** ce:brainstorm (Phase 4 handoff), ce:plan-beta (Phase 5 handoff), mvp-creator (Phase 5 SDD handoff)

## Interaction Rules (Applied Throughout)

Drawn from the strongest patterns across all repos:

1. **One question at a time** — never batch unrelated questions (ce:brainstorm, superpowers)
2. **Prefer single-select multiple choice** for direction decisions (ce:brainstorm)
3. **Use platform's blocking question tool** — AskUserQuestion / request_user_input / ask_user (ce:brainstorm, ce:plan-beta)
4. **Anti-sycophancy** — take positions, push twice, name failure patterns, never hedge (office-hours)
5. **Escape hatch** — compress to 2 most critical questions if user is impatient (office-hours)
6. **YAGNI** — prefer simplest approach that delivers meaningful value (ce:brainstorm)

## Implementation Steps

### Step 1: Create directory structure
```
skills/superplanning/
  SKILL.md
  references/
    forcing-questions.md
    review-personas.md
    cognitive-patterns.md
    anti-sycophancy-rules.md
SOURCES.md
```

### Step 2: Write `references/forcing-questions.md`
Extract and adapt the 6 forcing questions from office-hours, plus the premise challenge from plan-ceo-review, plus the product pressure test from ce:brainstorm. Organize by when each applies (product stage routing from office-hours).

### Step 3: Write `references/review-personas.md`
Extract persona definitions from compound-engineering's document-review agents (coherence-reviewer, feasibility-reviewer, product-lens, design-lens, security-lens, scope-guardian) plus the CEO/Design/Eng review dimensions from gstack. Define when each persona activates.

### Step 4: Write `references/cognitive-patterns.md`
Curate the best cognitive patterns from plan-ceo-review (18 patterns: Bezos, Grove, Munger, Jobs...), plan-eng-review (15 patterns: Larson, Fowler, Beck...), and plan-design-review (12 patterns: Rams, Norman, Nielsen...). Remove duplicates, organize by phase where they apply.

### Step 5: Write `references/anti-sycophancy-rules.md`
Extract the anti-sycophancy rules, pushback patterns, and interaction discipline from office-hours. Add the "Boil the Lake" completeness principle from gstack ETHOS.

### Step 6: Write `SKILL.md`
The main skill file implementing the 7-phase flow. Must:
- Have proper YAML frontmatter (name, description)
- Reference all `references/` files via markdown links
- Be platform-agnostic (Claude Code, Codex, Gemini fallbacks)
- Use imperative voice, no second person
- Include the complete flow with mode-adaptive instructions per phase
- Include artifact templates for requirements doc, product docs, and implementation plan
- Define gates and validation criteria at each phase transition

### Step 7: Write `SOURCES.md`
Track every source skill used, its repository, what was taken from it, and how it was adapted.

### Steps 8–12: Write test suite (see "Deliverable: Test Suite" section below)

---
Track every source skill used, its repository, what was taken from it, and how it was adapted. Format:

```markdown
| Source Skill | Repository | What Was Used | Phase(s) |
|---|---|---|---|
| ce:brainstorm | compound-engineering | Scope classification, requirements template, interaction rules | 0, 1, 2, 3 |
| office-hours | gstack | Forcing questions, anti-sycophancy, premise challenge | 2 |
| ... | ... | ... | ... |
```

## Key Source Files

- `resources/compound-engineering-plugin-main/plugins/compound-engineering/skills/ce-brainstorm/SKILL.md` — brainstorm flow spine
- `resources/compound-engineering-plugin-main/plugins/compound-engineering/skills/ce-plan-beta/SKILL.md` — planning flow, implementation units, plan template
- `resources/gstack-main/office-hours/SKILL.md` — forcing questions, anti-sycophancy
- `resources/gstack-main/autoplan/SKILL.md` — sequential review pipeline
- `resources/gstack-main/plan-ceo-review/SKILL.md` — CEO review, cognitive patterns
- `resources/gstack-main/plan-eng-review/SKILL.md` — eng review, test coverage
- `resources/gstack-main/plan-design-review/SKILL.md` — design review, 0-10 ratings
- `resources/compound-engineering-plugin-main/plugins/compound-engineering/skills/deepen-plan-beta/SKILL.md` — confidence gap scoring, selective deepening
- `resources/compound-engineering-plugin-main/plugins/compound-engineering/skills/document-review/SKILL.md` — multi-persona review dispatch
- `resources/compound-engineering-plugin-main/plugins/compound-engineering/agents/document-review/*.md` — 6 review persona agents
- `resources/agent-os-main/commands/agent-os/plan-product.md` — product doc generation
- `resources/rails-claude-code-main/mvp-creator/agents/mvp-creator.md` — competitor research, MVP deliverables
- `resources/superpowers-main/skills/brainstorming/SKILL.md` — visual companion, spec review loop

## Deliverable: Test Suite

The test suite follows the same architecture as `resources/superpowers-main/tests/` — a production-grade, multi-layer testing system that verifies skill triggering, explicit invocation, and behavioral correctness.

### Test Architecture Overview

Three test layers, matching superpowers' proven pattern:

| Layer | What It Tests | How It Works | Speed |
|-------|--------------|--------------|-------|
| **Skill triggering** | Natural prompts auto-invoke the skill | `claude -p` with `--output-format stream-json`, grep for `"name":"Skill"` | ~5 min/test |
| **Explicit requests** | User names the skill, it loads before any action | Same as triggering + checks no tools fire before Skill invocation | ~5 min/test |
| **Unit/behavior** | Skill describes correct phases, rules, artifacts | `claude -p` with questions about the skill, regex assertions on answers | ~2 min/test |

### Directory Structure

```
tests/
  superplanning/
    skill-triggering/
      run-test.sh                   # Single test runner
      run-all.sh                    # Batch runner with pass/fail summary
      prompts/
        brainstorm-idea.txt         # Triggers brainstorm mode
        new-product-plan.txt        # Triggers new product mode
        new-feature-plan.txt        # Triggers new feature mode
        help-think-through.txt      # Triggers brainstorm (alternative phrasing)
        is-this-worth-building.txt  # Triggers brainstorm (validation-seeking)
        plan-from-scratch.txt       # Triggers new product mode (alternative)
    explicit-skill-requests/
      run-test.sh                   # Single test runner
      run-all.sh                    # Batch runner
      prompts/
        superplanning-please.txt
        use-superplanning.txt
        product-plan-via-skill.txt
        brainstorm-via-skill.txt
        feature-plan-via-skill.txt
    unit/
      test-helpers.sh               # Assertion helpers (run_claude, assert_contains, etc.)
      run-skill-tests.sh            # Unit test orchestrator
      test-superplanning.sh         # 12 behavior verification tests
  run-all-tests.sh                  # Master runner (all layers)
```

### Layer 1: Skill Triggering Tests

**Purpose:** Verify the skill triggers automatically from natural language prompts that never mention "superplanning" by name.

**Runner: `tests/superplanning/skill-triggering/run-test.sh`**
- Based on: `resources/superpowers-main/tests/skill-triggering/run-test.sh`
- Runs `claude -p "$PROMPT" --plugin-dir "$PLUGIN_DIR" --dangerously-skip-permissions --max-turns 3 --output-format stream-json`
- Passes if JSON stream contains `"name":"Skill"` AND `"skill":"superplanning"` (or `"skill":"...:superplanning"`)
- Fails otherwise, shows which skills WERE triggered (for debugging)

**Prompts (6 scenarios):**

1. **`brainstorm-idea.txt`** — Pure ideation, no commitment to build:
   ```
   I have a half-baked idea I want to explore: a tool that helps freelancers
   track which clients drain their energy vs which ones energize them, and
   correlates that with profitability data. Before we build anything, can we
   just think through whether this is worth pursuing and what it would look like?
   ```

2. **`new-product-plan.txt`** — Explicit new product, needs full planning:
   ```
   I want to build a new SaaS product for independent restaurant owners to
   manage their suppliers and automate reordering when stock runs low. I need
   a proper plan - the mission, a roadmap, the tech stack, the whole thing.
   Can you help me plan this out from scratch?
   ```

3. **`new-feature-plan.txt`** — Feature within existing product:
   ```
   We need to add a notification system to our existing Rails app. Users
   should receive email alerts and in-app notifications when they get a new
   comment, when a task is assigned to them, or when a deadline is approaching.
   This is a multi-step feature and needs proper planning before we start coding.
   ```

4. **`help-think-through.txt`** — Decision-making, not yet committed:
   ```
   Help me think through whether adding social login (Google and GitHub OAuth)
   to our developer tool is the right next step. Our users currently use
   email+password. I'm not sure if social login is worth the added complexity
   for our audience of backend engineers.
   ```

5. **`is-this-worth-building.txt`** — Worth-it validation:
   ```
   Is this worth building? I keep seeing developers complain about context
   switching between their IDE, browser, and terminal. I'm thinking about
   building a unified workspace that combines all three. But maybe this is
   too ambitious or the market is already saturated.
   ```

6. **`plan-from-scratch.txt`** — New product, different phrasing:
   ```
   I want to create a product that helps remote engineering teams run better
   async standups. Instead of synchronous meetings, team members record short
   video updates and the tool generates AI summaries. I need to plan the entire
   product from the ground up.
   ```

**Runner: `tests/superplanning/skill-triggering/run-all.sh`**
- Iterates over all prompt files, runs `run-test.sh` for each
- Tracks pass/fail counts, prints summary table
- Exit code 1 if any test fails

### Layer 2: Explicit Skill Request Tests

**Purpose:** Verify that when the user names "superplanning" directly, the Skill tool fires BEFORE any action tools (Read, Write, Bash, etc.).

**Runner: `tests/superplanning/explicit-skill-requests/run-test.sh`**
- Based on: `resources/superpowers-main/tests/explicit-skill-requests/run-test.sh`
- Same as triggering runner, but adds **premature action detection**: finds the line number of the first `"name":"Skill"` invocation, then checks if any non-Skill tools were called before that line
- Creates an isolated project directory with dummy docs for context

**Prompts (5 scenarios):**

1. **`superplanning-please.txt`**:
   ```
   superplanning, please. Here's my idea: a browser extension that helps
   writers track how much time they spend on research versus actual writing,
   with weekly reports and productivity insights.
   ```

2. **`use-superplanning.txt`**:
   ```
   Use superplanning to help me work through a new feature idea: our SaaS
   app needs a billing portal where customers can view invoices, update
   payment methods, and manage their subscription tier.
   ```

3. **`product-plan-via-skill.txt`**:
   ```
   Please use the superplanning skill to create a complete product plan.
   The product: an async standup tool for remote engineering teams with
   AI-generated summaries of video updates.
   ```

4. **`brainstorm-via-skill.txt`**:
   ```
   I want to brainstorm using superplanning. The idea: what if we built
   a tool that analyzes your git commit patterns and suggests when you're
   most productive, then blocks distracting apps during those windows?
   ```

5. **`feature-plan-via-skill.txt`**:
   ```
   Use superplanning to plan this feature: add real-time collaborative
   editing to our document app. Multiple users should be able to edit
   the same document simultaneously with cursor presence and conflict
   resolution.
   ```

**Runner: `tests/superplanning/explicit-skill-requests/run-all.sh`**
- Same pattern as skill-triggering run-all.sh

### Layer 3: Unit/Behavior Tests

**Purpose:** Verify the skill's documented behavior by asking Claude questions about the skill and asserting the answers contain correct concepts. These tests validate that the SKILL.md content is coherent and complete.

**Based on:** `resources/superpowers-main/tests/claude-code/test-subagent-driven-development.sh`

**Helper: `tests/superplanning/unit/test-helpers.sh`**
Provides:
- `run_claude "prompt" [timeout]` — runs `claude -p` with `--plugin-dir` pointing to project root
- `assert_contains "output" "pattern" "test_name"` — case-insensitive regex match
- `assert_not_contains "output" "pattern" "test_name"` — absence check
- `assert_order "output" "pattern_a" "pattern_b" "test_name"` — ordering check

**Tests: `tests/superplanning/unit/test-superplanning.sh`** (12 tests)

```bash
# Test 1: Three modes recognized
# Prompt: "What are the three modes in the superplanning skill?"
# Assert: output contains "brainstorm", "product", "feature"

# Test 2: Scope classification
# Prompt: "How does the superplanning skill classify scope?"
# Assert: output contains "lightweight", "standard", "deep"

# Test 3: Phase ordering
# Prompt: "In superplanning, what comes first: challenging the idea or
#          structuring the implementation plan?"
# Assert: "challenge" appears before "structure" (assert_order)

# Test 4: Anti-sycophancy enforcement
# Prompt: "Does superplanning challenge assumptions or just accept them?
#          How does it handle weak ideas?"
# Assert: output contains "challenge\|push back\|pressure test\|anti-sycophancy"
# Assert: output NOT contains "accept.*all\|rubber.stamp"

# Test 5: One question at a time rule
# Prompt: "How does superplanning handle asking the user questions?
#          Does it batch questions or ask them individually?"
# Assert: output contains "one.*question.*at.*a.*time\|single.*question\|one.*at.*a.*time"

# Test 6: Artifacts for brainstorm mode
# Prompt: "What document does superplanning produce in brainstorm mode?"
# Assert: output contains "requirements.*doc\|requirements.*document"
# Assert: output contains "R1\|stable.*ID\|requirement.*ID"

# Test 7: Artifacts for new product mode
# Prompt: "What documents does superplanning produce when planning a new product?"
# Assert: output contains "mission"
# Assert: output contains "roadmap"
# Assert: output contains "tech.*stack"

# Test 8: Validation phase exists
# Prompt: "How does superplanning validate plans before implementation?"
# Assert: output contains "review\|validate\|validation"
# Assert: output contains "persona\|CEO\|design\|eng\|coherence\|feasibility"

# Test 9: Gates prevent bad plans
# Prompt: "What happens in superplanning if the idea has a flawed premise?"
# Assert: output contains "stop\|halt\|reframe\|not.*proceed\|gate"

# Test 10: Forcing questions in product mode
# Prompt: "What forcing questions does superplanning use for new product ideas?"
# Assert: output contains at least 2 of: "demand", "status quo", "narrowest wedge",
#         "specificity", "observation"

# Test 11: Implementation units in structure phase
# Prompt: "How does superplanning break down an implementation plan?"
# Assert: output contains "implementation.*unit\|atomic.*commit\|unit"
# Assert: output contains "dependencies\|test.*scenario\|verification"

# Test 12: Deepen phase is conditional
# Prompt: "When does superplanning's deepen phase run? Is it always or conditional?"
# Assert: output contains "conditional\|optional\|only.*when\|standard.*deep\|high.*risk"
# Assert: NOT contains "always.*run\|mandatory.*deepen"
```

**Runner: `tests/superplanning/unit/run-skill-tests.sh`**
- Based on: `resources/superpowers-main/tests/claude-code/run-skill-tests.sh`
- Runs `test-superplanning.sh` with timeout (default 300s)
- Supports `--verbose`, `--test NAME`, `--timeout SECONDS`
- Prints pass/fail summary with timing

### Master Runner

**`tests/run-all-tests.sh`**
- Runs all three layers sequentially:
  1. Unit tests (fastest, ~2 min)
  2. Skill triggering tests (~30 min)
  3. Explicit request tests (~25 min)
- Supports `--unit-only` flag for fast feedback during development
- Supports `--verbose` flag
- Prints combined summary at the end

### Implementation Steps for Tests

**Step 8: Write test helpers**
- `tests/superplanning/unit/test-helpers.sh` — adapted from `resources/superpowers-main/tests/claude-code/test-helpers.sh`
- Key change: `PLUGIN_DIR` points to project root (3 levels up from `tests/superplanning/unit/`)

**Step 9: Write skill triggering infrastructure**
- `tests/superplanning/skill-triggering/run-test.sh` — adapted from `resources/superpowers-main/tests/skill-triggering/run-test.sh`
- `tests/superplanning/skill-triggering/run-all.sh` — adapted from `resources/superpowers-main/tests/skill-triggering/run-all.sh`
- 6 prompt files in `prompts/`

**Step 10: Write explicit request infrastructure**
- `tests/superplanning/explicit-skill-requests/run-test.sh` — adapted from `resources/superpowers-main/tests/explicit-skill-requests/run-test.sh`
- `tests/superplanning/explicit-skill-requests/run-all.sh`
- 5 prompt files in `prompts/`
- Creates isolated project dir with dummy `docs/brainstorms/` and `docs/plans/` for context

**Step 11: Write unit behavior tests**
- `tests/superplanning/unit/test-superplanning.sh` — 12 tests following the superpowers pattern
- `tests/superplanning/unit/run-skill-tests.sh` — orchestrator with CLI flags

**Step 12: Write master runner**
- `tests/run-all-tests.sh` — runs all layers, supports `--unit-only`

### Test Design Principles (from superpowers)

1. **Deterministic** — same prompt should trigger same skill every time
2. **Isolated** — each test gets its own temp directory, no cross-contamination
3. **Layered** — unit tests are fast (run during development), triggering/explicit tests are thorough (run before shipping)
4. **Observable** — all Claude output saved to `/tmp/superplanning-tests/<timestamp>/` for debugging
5. **No manual intervention** — all tests run headless via `claude -p` with `--dangerously-skip-permissions`
6. **Premature action detection** — explicit request tests verify the Skill tool fires BEFORE any Read/Write/Bash tools

## Verification (Static)

1. **Structural:** All reference files exist and are properly linked from SKILL.md
2. **Completeness:** All 7 phases present, all 3 modes covered, all gates defined
3. **Citations:** SOURCES.md accounts for every technique used with its origin
4. **Readability:** SKILL.md can be read top-to-bottom and followed without external context
5. **Platform-agnostic:** No hardcoded tool names without fallback alternatives

## Verification (Test Suite)

```bash
# Fast: unit tests only (~2 min)
./tests/superplanning/unit/run-skill-tests.sh

# Medium: unit + triggering (~30 min)
./tests/superplanning/skill-triggering/run-all.sh

# Full: all layers (~60 min)
./tests/run-all-tests.sh

# Single triggering test
./tests/superplanning/skill-triggering/run-test.sh superplanning prompts/brainstorm-idea.txt

# Single explicit request test
./tests/superplanning/explicit-skill-requests/run-test.sh superplanning prompts/superplanning-please.txt
```
