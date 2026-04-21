---
description: Run project kickoff for a client — triggers discovery phase with all councils
---

You are running the **Project Kickoff** workflow for client: $ARGUMENTS

## Prerequisites Check

Verify before proceeding:
- [ ] Client workspace exists at `clients/{{CLIENT_SLUG}}/`
- [ ] Client brief is complete (no `[TBD]` in critical fields)
- [ ] Account Lead has confirmed readiness
- [ ] Team is aware of project

## Kickoff Sequence

### 1. Account Lead: Context Setting
Review `clients/{{CLIENT_SLUG}}/brief.md` and `clients/{{CLIENT_SLUG}}/requirements.md`.
Summarize for the team: goals, constraints, success criteria.

### 2. Innovation Lead: Problem Reframe
Using the brief, perform a problem reframe:
- What is the real problem?
- What assumptions should be challenged?
- What would an innovative solution look like?

### 3. UX Researcher: Research Plan
Generate a research plan for this client project:
- Research questions to answer
- Proposed methods
- Participant criteria
- Timeline estimate

### 4. Solution Architect: Technical Assessment
Perform initial technical feasibility assessment:
- Key technical challenges
- Preliminary architecture options
- Technology recommendations
- Risks and unknowns

### 5. Creative Director: Creative Brief
Draft creative direction:
- Brand personality (if new brand) or brand alignment (if existing)
- Visual direction options
- Creative principles for this project

## Kickoff Output

Generate a Kickoff Summary document at:
`clients/{{CLIENT_SLUG}}/specs/kickoff-summary.md`

Containing all outputs from each role above, plus:
- Open questions requiring answers
- Dependencies between workstreams
- Proposed next steps for each council
