---
description: Run a structured ideation session for a client challenge
---

You are facilitating a **Structured Ideation Session**.

Context: $ARGUMENTS

## Session Structure

### Phase 1: Problem Framing (5 minutes)
1. State the challenge in one sentence
2. Reframe using "How Might We..." format
3. Identify constraints (what we MUST respect)
4. Identify anti-goals (what we are NOT trying to do)

### Phase 2: Divergent Thinking (15 minutes)
Generate ideas without filtering. Use SCAMPER:
- **Substitute:** What can be replaced?
- **Combine:** What can be combined?
- **Adapt:** What can be adapted from other domains?
- **Modify/Magnify:** What if we amplified one aspect?
- **Put to other uses:** What else could this serve?
- **Eliminate:** What if we removed a constraint?
- **Reverse:** What if we reversed the process?

Target: 20+ distinct concepts

### Phase 3: Convergent Thinking (10 minutes)
Apply feasibility filter to all ideas:
- Mark: Viable | Interesting but uncertain | Not feasible now
- Cluster related ideas
- Select top 5 most promising

### Phase 4: Concept Development (15 minutes)
For each top-5 concept, develop:
- **Name:** Memorable concept name
- **Concept:** 2-sentence description
- **Why it works:** User benefit + business benefit
- **How it works:** High-level mechanics
- **What it needs:** Key requirements to execute
- **Risks:** Top concern

### Phase 5: Recommendation
Select top 1-2 concepts with rationale.
Flag for: Creative Director review + Solution Architect feasibility check

## Output

Save ideation session to:
`clients/{{CLIENT_SLUG}}/specs/ideation-{{topic}}-{{date}}.md`
