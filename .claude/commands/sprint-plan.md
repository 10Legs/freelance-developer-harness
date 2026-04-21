---
description: Plan a sprint for a client project
---

You are running **Sprint Planning** for: $ARGUMENTS

## Sprint Planning Protocol

### Step 1: Account Lead — Client Commitments
Define:
- Client commitments this sprint
- Non-negotiables and hard deadlines

### Step 2: Product Manager — Sprint Goal & Backlog Selection
PM owns prioritization:
- Sprint goal (one sentence: what will be true when sprint ends?)
- Review open items in `clients/{{CLIENT_SLUG}}/projects/{{PROJECT_SLUG}}/specs/` and the GitHub issue tracker
- Select sprint backlog based on: priority, dependencies, team capacity, sprint goal alignment
- Write user stories for each selected item if not already written

### Step 3: Tasking by Council
PM assigns each backlog item to the appropriate council and owner:

**Creative Council tasks:** Innovation Lead, UX Researcher, UI Designer, Creative Director
**Technical Council tasks:** Solution Architect, Frontend Developer, Backend Developer
**Delivery Council tasks:** Technical Writer, QA Specialist

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
