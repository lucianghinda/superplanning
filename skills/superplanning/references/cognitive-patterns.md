# Cognitive Patterns

Curated thinking lenses for use during review phases of the superplanning flow.
Drawn from plan-ceo-review (18 patterns), plan-eng-review (15 patterns), and plan-design-review (12 patterns).

These are not checklist items. They are thinking instincts — the cognitive moves that separate rigorous review from rubber-stamping. Apply them throughout; do not enumerate them as a to-do list.

---

## CEO / Product Cognitive Patterns

Apply during Phase 2 (CHALLENGE & EXPLORE) and Phase 5 CEO Review.

1. **Classification instinct** (Bezos) — Categorize every decision by reversibility × magnitude. One-way doors need more scrutiny. Two-way doors: move fast.

2. **Paranoid scanning** (Grove) — Continuously scan for strategic inflection points that could make the current approach obsolete. "Only the paranoid survive."

3. **Inversion reflex** (Munger) — For every "how do we win?" also ask "what would make us fail?" Invert the problem before committing to a solution.

4. **Focus as subtraction** (Jobs) — Primary value-add is deciding what NOT to do. Jobs went from 350 products to 10. Default: do fewer things, better.

5. **Speed calibration** (Bezos) — Fast is the default. Only slow down for irreversible + high-magnitude decisions. 70% information is enough to decide.

6. **Proxy skepticism** (Bezos Day 1) — Are metrics still serving users, or have they become self-referential? When a metric replaces the goal it was measuring, it's a proxy. Challenge proxies.

7. **Narrative coherence** — Hard decisions need clear framing. Make the "why" legible, not everyone happy.

8. **Temporal depth** — Think in 5–10 year arcs. Apply regret minimization for major bets.

9. **Willfulness as strategy** (Altman) — The world yields to people who push hard enough in one direction long enough. Most people give up too early.

10. **Leverage obsession** (Altman) — Find inputs where small effort creates massive output. Technology is leverage: one person with the right tool can outperform a team of 100.

11. **Wartime awareness** (Horowitz) — Correctly diagnose peacetime vs wartime. Peacetime habits kill wartime companies.

12. **Talent density** (Hastings) — Most other problems become easier with higher talent density. People, products, profits — always in that order.

13. **Founder-mode bias** (Chesky/Graham) — Deep involvement isn't micromanagement if it expands (not constrains) the team's thinking.

14. **Edge case paranoia** — What if the name is 47 chars? Zero results? Network fails mid-action? First-time user vs power user? Empty states are features, not afterthoughts.

15. **Subtraction default** (Rams) — "As little design as possible." If a feature doesn't earn its place, cut it. Feature bloat kills products faster than missing features.

16. **Design for trust** — Every interface decision either builds or erodes user trust. Pixel-level intentionality about safety, identity, and belonging.

17. **Hierarchy as service** — Every UI decision answers "what should the user see first, second, third?" Respecting their time, not prettifying pixels.

18. **Completeness is cheap** — AI compresses implementation time 10–100x. Shortcuts save minutes; completeness saves months of future rework. Boil lakes.

---

## Engineering Cognitive Patterns

Apply during Phase 5 Engineering Review.

1. **State diagnosis** (Larson) — Teams exist in four states: falling behind, treading water, repaying debt, innovating. Each demands a different intervention.

2. **Blast radius instinct** — Every decision evaluated through "what's the worst case and how many systems/people does it affect?"

3. **Boring by default** (McKinley) — "Every company gets about three innovation tokens." Everything else should be proven technology.

4. **Incremental over revolutionary** (Fowler) — Strangler fig, not big bang. Canary, not global rollout. Refactor, not rewrite.

5. **Systems over heroes** — Design for tired humans at 3am, not your best engineer on their best day.

6. **Reversibility preference** — Feature flags, A/B tests, incremental rollouts. Make the cost of being wrong low.

7. **Failure is information** (Allspaw, Google SRE) — Blameless postmortems, error budgets, chaos engineering. Incidents are learning opportunities.

8. **Org structure IS architecture** (Skelton/Pais) — Conway's Law in practice. Design both intentionally.

9. **Essential vs accidental complexity** (Brooks) — Before adding anything: "Is this solving a real problem or one we created?"

10. **Make the change easy, then make the easy change** (Beck) — Refactor first, implement second. Never structural + behavioral changes simultaneously.

11. **Own your code in production** (Majors) — No wall between dev and ops. Engineers write code and own it in production.

12. **Error budgets over uptime targets** (Google SRE) — 99.9% SLO = 0.1% downtime budget to spend on shipping. Reliability is resource allocation.

13. **Glue work awareness** (Reilly) — Recognize invisible coordination work. Value it, but don't let people get stuck doing only glue.

14. **DX is product quality** — Slow CI, bad local dev, painful deploys → worse software, higher attrition. Developer experience is a leading indicator.

15. **Two-week smell test** — If a competent engineer can't ship a small feature in two weeks, there is an onboarding problem disguised as architecture.

---

## Design Cognitive Patterns

Apply during Phase 5 Design Review.

1. **Subtraction default** (Rams) — "As little design as possible." Remove everything that doesn't earn its place.

2. **Affordances and feedback** (Norman) — Users understand interfaces through affordances (what can I do?) and feedback (what happened?). Every interaction must answer both.

3. **Recognition over recall** (Nielsen) — Minimize the user's memory load. Make actions, objects, and options visible. The user shouldn't have to remember information from one part of the interface to use another.

4. **Thumb zones** (Hoober) — On mobile, 75% of touches use a thumb. Primary actions belong in comfortable reach; dangerous actions should require deliberate effort.

5. **Don't make me think** (Krug) — Every question mark in a user's head is a failure. The best interfaces are self-evident.

6. **Simplicity** (Maeda) — Simplicity is about subtracting the obvious and adding the meaningful.

7. **Unity and gestalt** (Lidwell) — Elements that look similar are perceived as related. Use proximity, similarity, and enclosure to communicate structure.

8. **Goal-directed design** (Cooper) — Design for what users are trying to accomplish, not for what they do with your interface.

9. **Behavior model** (Fogg) — Behavior happens when motivation, ability, and a trigger coincide. If behavior isn't happening, diagnose which element is missing.

10. **First principles of interaction** (Tognazzini) — Visibility, feedback, consistency, non-destructive operations, discoverability. These are non-negotiable.

11. **Target size and distance** (Fitts) — The time to acquire a target is a function of its size and distance. Small, distant targets are slow and error-prone.

12. **Working memory limits** (Miller) — Users can hold 7±2 items in working memory. Interfaces that exceed this cause confusion and errors.

---

## How to Apply These Patterns

During any review phase, these patterns should surface naturally as questions:

- When evaluating scope: apply Focus as subtraction + Boring by default
- When evaluating architecture: apply Blast radius instinct + Essential vs accidental complexity
- When evaluating user flows: apply Goal-directed design + Recognition over recall
- When evaluating timeline: apply Speed calibration + Incremental over revolutionary
- When evaluating completeness: apply Completeness is cheap + Shadow path tracing
- When evaluating UI: apply Subtraction default + Design for trust

Do not enumerate the patterns. Internalize them as lenses that shape how you see the plan.
