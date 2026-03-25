# Forcing Questions

Questioning frameworks extracted from office-hours, plan-ceo-review, and ce:brainstorm.
Used in Phase 2 (CHALLENGE & EXPLORE) of the superplanning flow.

---

## When to Use Which Questions

| Mode | Context | Questions to use |
|------|---------|-----------------|
| Brainstorm | Any | Product Pressure Test |
| New Product — pre-product | No users yet | Q1, Q2, Q3 |
| New Product — has users | People using, not yet paying | Q2, Q4, Q5 |
| New Product — paying customers | Real revenue | Q4, Q5, Q6 |
| New Product — pure engineering/infra | Technical initiative | Q2, Q4 only |
| New Feature | Any | Premise Challenge + 2–3 Planning Questions |

Smart-skip: if the user's earlier answers already cover a question, skip it. Only ask questions whose answers are not yet clear.

---

## Product Pressure Test (Brainstorm + New Feature)

Before generating approaches, challenge the request to catch misframing. Match depth to scope:

**Lightweight:**
- Is this solving the real user problem?
- Are we duplicating something that already covers this?
- Is there a clearly better framing with near-zero extra cost?

**Standard:**
- Is this the right problem, or a proxy for a more important one?
- What user or business outcome actually matters here?
- What happens if we do nothing?
- Is there a nearby framing that creates more user value without more carrying cost?
- Given the current project state and constraints, what is the single highest-leverage move right now?
- Favor moves that compound value, reduce future carrying cost, or make the product meaningfully more useful.

**Deep** (Standard questions plus):
- What durable capability should this create in 6–12 months?
- Does this move the product toward that, or is it only a local patch?

---

## The Six Forcing Questions (New Product)

Ask ONE AT A TIME. Push on each until the answer is specific, evidence-based, and uncomfortable. Comfort means the answer has not gone deep enough.

### Q1: Demand Reality

**Ask:** "What's the strongest evidence you have that someone actually wants this — not 'is interested,' not 'signed up for a waitlist,' but would be genuinely upset if it disappeared tomorrow?"

**Push until hearing:** Specific behavior. Someone paying. Someone expanding usage. Someone who would scramble if the product vanished.

**Red flags:** "People say it's interesting." "We got 500 waitlist signups." "VCs are excited about the space." None of these are demand.

**After the first answer, check:**
1. Language precision — are key terms defined? If they said "AI space," "seamless experience," "better platform" — challenge: "What do you mean by [term]? Can you define it so I could measure it?"
2. Hidden assumptions — what does their framing take for granted? Name one assumption and ask if it's verified.
3. Real vs hypothetical — "I think developers would want..." is hypothetical. "Three developers at my last company spent 10 hours a week on this" is real.

---

### Q2: Status Quo

**Ask:** "What are your users doing right now to solve this problem — even badly? What does that workaround cost them?"

**Push until hearing:** A specific workflow. Hours spent. Dollars wasted. Tools duct-taped together. People hired to do it manually.

**Red flags:** "Nothing — there's no solution, that's why the opportunity is so big." If truly nothing exists and no one is doing anything, the problem probably isn't painful enough.

---

### Q3: Desperate Specificity

**Ask:** "Name the actual human who needs this most. What's their title? What gets them promoted? What gets them fired? What keeps them up at night?"

**Push until hearing:** A name. A role. A specific consequence they face if the problem isn't solved. Ideally something the founder heard directly from that person's mouth.

**Red flags:** Category-level answers. "Healthcare enterprises." "SMBs." "Marketing teams." These are filters, not people. You can't email a category.

---

### Q4: Narrowest Wedge

**Ask:** "What's the smallest possible version of this that someone would pay real money for — this week, not after you build the platform?"

**Push until hearing:** One feature. One workflow. Maybe something as simple as a weekly email or a single automation. Something that could ship in days, not months.

**Red flags:** "We need to build the full platform before anyone can really use it." "We could strip it down but then it wouldn't be differentiated." Signs of attachment to architecture rather than value.

**Bonus push:** "What if the user didn't have to do anything at all to get value? No login, no integration, no setup. What would that look like?"

---

### Q5: Observation & Surprise

**Ask:** "Have you actually sat down and watched someone use this without helping them? What did they do that surprised you?"

**Push until hearing:** A specific surprise. Something the user did that contradicted assumptions. If nothing has surprised them, they're either not watching or not paying attention.

**Red flags:** "We sent out a survey." "We did some demo calls." "Nothing surprising, it's going as expected." Surveys lie. Demos are theater. "As expected" means filtered through existing assumptions.

**The gold:** Users doing something the product wasn't designed for. That's often the real product trying to emerge.

---

### Q6: Future-Fit

**Ask:** "If the world looks meaningfully different in 3 years — and it will — does your product become more essential or less?"

**Push until hearing:** A specific claim about how the users' world changes and why that change makes the product more valuable. Not "AI keeps getting better so we keep getting better."

**Red flags:** "The market is growing 20% per year." Growth rate is not a vision. "AI will make everything better." That's not a product thesis.

---

## Premise Challenge (All Modes, CEO Review)

Before accepting any plan or requirement at face value, challenge the premise.

Ask these in sequence (stop at the first one that reveals a gap):

1. **The reframing test:** "What is this feature actually trying to accomplish at the user/business level? Is the proposed solution the right way to get there, or is it one of several ways?"

2. **The do-nothing test:** "What happens if we don't build this? What is the actual cost of inaction?"

3. **The assumption test:** "What has to be true about users, the market, or the codebase for this plan to succeed? Which of those assumptions are unverified?"

4. **The inversion test:** "What would make this fail? What's the most likely way this ships and still doesn't solve the problem?"

5. **The scope test:** "Is this the minimum version that proves the hypothesis, or have we already added scope that assumes the hypothesis is true?"

If the premise doesn't survive, stop. Surface the flaw, propose a reframe, and do not proceed with planning until the premise is either corrected or explicitly accepted as a known risk.

---

## Escape Hatch

If the user expresses impatience ("just do it," "skip the questions"):

1. Acknowledge: "The hard questions are the value — skipping them is where planning goes wrong later. Let me ask two more, then we'll move."
2. Consult the routing table above. Ask the 2 most critical remaining questions for the current stage.
3. If the user pushes back a second time, respect it — proceed to the next phase immediately.
4. Only allow a full skip if the user provides a fully formed plan with real evidence — existing users, revenue numbers, specific customer names. Even then, still run the Premise Challenge.
