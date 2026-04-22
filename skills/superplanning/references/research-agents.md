# Research Agents

Expanded agent taxonomy for context-gathering. Loaded on demand from **Phase 1 (Ground — New Feature)** and **Phase 6 (Deepen — any mode)**.

## Core rule

**Research the problem, not the proposal.** When the input includes a proposed solution, every agent researches the underlying problem independently first. The proposal may be correct — verify, don't anchor.

**Agent count matches complexity.** Do not launch all seven for a one-file bug. Three or four well-chosen agents beat seven diffuse ones. If only one agent type applies, run one agent — this file is not a minimum.

## Agents

### Codebase agent (almost always)
**When:** Any task touching existing code.
**Does:** Grep/Glob/Read to find relevant patterns, existing implementations, related code, config, dependencies, test conventions, naming conventions.
**Returns:** File paths (with line numbers where useful), existing patterns this change should extend, system-wide touch points.

### Docs agent (when libraries/frameworks involved)
**When:** Task involves a specific library, framework, SDK, API, CLI tool, or cloud service.
**Does:** Look up authoritative documentation. Try Context7 MCP tools first (`mcp__context7__resolve-library-id`, `mcp__context7__get-library-docs`). If Context7 is unavailable or the library isn't indexed, use `WebSearch` + `WebFetch` targeting official docs sites.
**Returns:** Current API syntax (not training-data version), version-specific constraints, config options, primary-source URLs.

### Web agent (when the problem isn't purely local)
**When:** External research is needed — similar problems others have solved, competitor approaches, real-world failure modes.
**Does:** `WebSearch` for similar problems, solutions, blog posts, Stack Overflow, GitHub issues. Focus on recent and authoritative sources.
**Returns:** Findings with URLs. When sources conflict, name which source is more trustworthy and why.

### Dependencies agent (when package versions matter)
**When:** Adding a new dependency, upgrading an existing one, or when compatibility might bite.
**Does:** Read `package.json`/`Gemfile`/`requirements.txt`/`go.mod`/`Cargo.toml`. Cross-reference installed versions with current docs. Check changelogs for breaking changes between installed and latest.
**Returns:** Installed version, latest version, known breaking changes between them, relevant config options for the installed version specifically.

### UI agent (when the change affects visual design)
**When:** Task introduces new visual elements, changes layout, or touches shared design tokens.
**Does:** Inventory existing design system components, typography, color, spacing scale, responsive breakpoints. Check whether the proposed change introduces visual inconsistencies. If a `/ui` skill is available, invoke it.
**Returns:** Existing components that already do part of this, design tokens the change must use, inconsistencies to watch for.

### UX agent (when the change affects user-facing behavior)
**When:** Task changes an interaction, flow, error surface, or affordance.
**Does:** Search codebase for how similar interactions are handled today. `WebSearch` for established UX patterns. Check accessibility (keyboard navigation, screen reader behavior, WCAG compliance).
**Returns:** Existing interaction patterns this should match, cognitive-load risks, error/empty/loading states that need design, accessibility concerns.

### Delight agent (when the change touches anything a user sees or interacts with)
**When:** Task is user-facing and scope allows space for polish. Skip when adding complexity would outweigh payoff — delight is opt-in, not required.
**Does:** Look for opportunities where a small addition would make the experience feel noticeably better — micro-interactions, smart defaults, helpful empty states, smooth transitions. Search the codebase for existing delight patterns worth matching.
**Returns:** Concrete, specific opportunities (not "add animations" — "fade toast out over 200ms when dismissed, matching existing notification pattern in X"). Skip items where delight would require new infrastructure.

## Agent output format

Each agent returns three things — no more, no less:

1. **What it found** — the finding itself, stated plainly.
2. **Where it found it** — file paths with line numbers, or URLs with source type (official docs / blog / SO).
3. **Key snippets** — code excerpts or quotes that back up the finding.

## Selection heuristic

For each research task, run this check before launching:

| Condition | Agents to launch |
|-----------|------------------|
| Touching existing code? | + Codebase |
| Uses a library/framework/SDK? | + Docs |
| Problem extends beyond this repo? | + Web |
| Package version ambiguity? | + Dependencies |
| Visual design impact? | + UI |
| User-facing behavior change? | + UX |
| User-facing polish in scope? | + Delight |

Three agents is typical. Seven is rare and probably over-researched.

## When agents disagree

If findings contradict each other, state the contradiction explicitly. Name which source you trust more and why. Do not average or merge conflicting findings into a single bland summary — the contradiction is itself a finding the user needs to see.
