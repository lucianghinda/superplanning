# Session Q&A Log: Research Skill Integration

**Date:** 2026-04-22
**Mode:** Brainstorm → pivoted to targeted New Feature edits
**Scope:** Standard
**Phases completed:** 0, 1, 2 (analysis-focused, bypassed 3 when user chose Option 3 directly)
**Outcome:** Three small edits to superplanning rather than a new skill — new `references/research-agents.md`, Phase 4 clarify gate, Phase 6 expanded agent taxonomy.

---

## Questions & Answers by Phase

### Phase 0: Intake & Route

**Q:** What shape should the research capability take?
**User:** Initially chose "Separate callable skill, referenced from Phase 1" with triggers from superplanning Phase 1, Phase 6, user invocation, and other skills. Scope: plan + ship.
**AI position:** Flagged the "two entry points for planning" risk in the option description. Took the position that the proposed prompt was ~40% net-new, ~40% duplicative, ~20% conflicting with existing superplanning phases.
**Resolved:** User interrupted the build-it trajectory to request a straight overlap analysis first.

### Phase 1: Ground

**Q:** What in the proposed `research` skill is genuinely new versus already covered by superplanning?
**User:** (Implicit — asked for analysis)
**AI position:** Categorized each step of the proposed prompt as (a) covered by existing phase, (b) net-new, or (c) conflicting. Identified the net-new contributions as: pre-research clarify gate (Step 1), post-research check-in (Step 4), expanded agent taxonomy (Docs/Deps/UI/UX/Delight), "research the problem, not the proposal" as an explicit rule, formal output template, primary-source preference.
**Resolved:** Shared as overlap map.

### Phase 2: Challenge & Explore

**Q:** Does superplanning create an implementation plan in the current form?
**User:** Asked directly.
**AI position:** Yes for New Feature and New Product (Phase 4 Structure). No for Brainstorm by design.
**Resolved:** Confirmed.

**Q:** Should we fold research into Phase 4, or create a new plan-reviewer skill that uses research?
**User:** Posed the two options.
**AI position:** Rejected both. Option 2 duplicates Phase 6 (Deepen), which already does confidence-gap scoring + targeted research + selective strengthening. Option 1 bloats Phase 4 (structure's job is breaking work, not gathering context). Recommended Option 3: strengthen Phase 6 with the expanded agent taxonomy + add a clarify gate to Phase 4. No new skill.

**Evidence that would change the position** — stated explicitly:
- If research needs to be usable outside superplanning → standalone skill still wins.
- If plans frequently go stale and need re-review in separate sessions → standalone plan-reviewer justified.
- If agent taxonomy needs to evolve independently → extraction justified.

**Resolved:** User chose Option 3. Executed.

---

## Key Decisions

| Decision | Chosen | Phase | Rationale |
|----------|--------|-------|-----------|
| Integration shape | Option 3: strengthen existing phases | 2 | Phase 6 already does 70% of what a new plan-reviewer skill would do; Phase 4 needed a clarify gate but not full research context-gathering |
| No new standalone `research` skill | Defer | 2 | Would duplicate Phase 6 + create two entry points for the same user intent |
| Clarify gate goes in Phase 4 only (not Phase 1) | Phase 4 Step 4.0 | Implementation | Phase 1 already has a gate at Phase 2 entry; adding another clarify-before-agents step would fragment the flow. Structure phase is where implementation-level ambiguities bite. |
| Batched AskUserQuestion allowed in Phase 4 clarify step | Explicit exception | Implementation | Contradicts Interaction Rule #1 generally, but structure-time ambiguities belong together; named as the one allowed exception |
| Agent taxonomy as reference file, not inline | `references/research-agents.md` | Implementation | Matches existing pattern ("load when needed — do not pre-load all"); keeps SKILL.md focused |

---

## Positions Where AI Pushed Back

| Topic | AI Position | User Response | Final Resolution |
|-------|------------|---------------|------------------|
| Proposed skill shape (standalone vs fold-in) | Pushed that standalone would create two entry points for "plan a feature" and that EnterPlanMode at end would conflict with superplanning's gates | User initially picked standalone anyway, then pivoted to overlap analysis | Landed on Option 3 — no standalone skill |
| Option 1 (fold into Phase 4) vs Option 2 (plan-reviewer skill) | Took the position that Option 2 duplicates Phase 6 and Option 1 muddles Phase 4's single responsibility | User accepted and chose Option 3 | Executed Option 3 |
| Proposed prompt's "one question at a time" violation | Noted that the batched AskUserQuestion in proposed Step 1 contradicts superplanning's Interaction Rule #1 | — | When folding into Phase 4, named the batched call as an explicit exception (structure-time ambiguities belong together) |

---

## Artifacts Produced

- `skills/superplanning/references/research-agents.md` (new) — 7-agent taxonomy with trigger conditions, output format, selection heuristic
- `skills/superplanning/SKILL.md` — edits:
  - Top-of-file reference list: added `research-agents.md` entry
  - Phase 1 (New Feature): rewritten to load research-agents.md and select agents by trigger
  - Phase 4: new Step 4.0 "Clarify Before Structuring" with batched AskUserQuestion and optional agent invocation
  - Phase 6: expanded "Research Agent Mapping" table referencing the new file
- `docs/sessions/2026-04-22-research-skill.md` (this log)

## Open Questions (for a future session)

- Should the `tests/superplanning/` suite add a test covering Phase 4's clarify gate? Current tests cover triggering and document creation; none verify the Phase 4 clarify step fires.
- Post-research check-in (proposed Step 4) was identified as net-new but not yet added anywhere. Worth adding to Phase 1 (New Feature) between research and Gate 1→2 if research findings contradict the user's framing.
- Installed skill copy at `~/.claude/skills/superplanning/` is unchanged. Sync/install process is the user's to decide.
