---
description: Plan a sprint for a client project
---

You are running **Sprint Planning** for: $ARGUMENTS

## Sprint Planning Protocol

### Step 1: Account Lead — Sprint Goal
Define:
- Sprint goal (one sentence: what will be true when sprint ends?)
- Client commitments this sprint
- Non-negotiables

### Step 2: Backlog Review
Review open items in `clients/{{CLIENT_SLUG}}/requirements.md`.
Identify candidates for this sprint based on:
- Priority
- Dependencies (what must be done first)
- Team capacity
- Sprint goal alignment

### Step 3: Tasking by Council

**Creative Council tasks:** Assigned to Innovation Lead, UX Researcher, UI Designer, Creative Director
**Technical Council tasks:** Assigned to Solution Architect, Frontend Developer, Backend Developer
**Delivery Council tasks:** Assigned to Account Lead, Technical Writer, QA Specialist

### Step 4: Dependency Mapping
Identify cross-council dependencies:
- What must Creative Council deliver before Technical Council can proceed?
- What must Technical Council deliver before QA can proceed?
- What is the critical path?

### Step 5: Risk Assessment
For each high-complexity item: What could go wrong? What's the mitigation?

## Output

Create sprint plan at:
`clients/{{CLIENT_SLUG}}/specs/sprint-{{number}}-plan.md`

Include:
- Sprint goal
- All tasks with owner, estimated effort, dependencies
- Critical path highlighted
- Risk register for sprint
