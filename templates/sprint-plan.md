---
sprint_number: {{NUMBER}}
status: active            # active | closed
start_date: {{YYYY-MM-DD}}
end_date: {{YYYY-MM-DD}}
closed_date:              # filled by /retro on close
client: {{CLIENT_SLUG}}
project: {{PROJECT_SLUG}}
goal: {{one-sentence sprint goal}}
---

# Sprint {{NUMBER}} Plan

**Client / Project:** {{CLIENT_SLUG}} / {{PROJECT_SLUG}}
**Sprint Dates:** {{start_date}} → {{end_date}}
**Sprint Goal:** {{one sentence}}

## Team Capacity
[Hours / availability per role this sprint]

## Milestones

Group backlog items by milestone. A milestone is a coherent deliverable or
gate the team commits to hitting inside this sprint.

| Milestone | Target Date | Owner | Exit Criteria |
|-----------|-------------|-------|---------------|
| {{M1}} | {{date}} | {{owner}} | {{what's true when done}} |
| {{M2}} | {{date}} | {{owner}} | {{what's true when done}} |

## Sprint Backlog

| ID | Milestone | Task | Owner | Estimate | Dependencies | PR(s) | Status |
|----|-----------|------|-------|----------|--------------|-------|--------|
|    |           |      |       |          |              |       | TODO   |

Status values: `TODO` · `IN_PROGRESS` · `BLOCKED` · `IN_REVIEW` · `DONE`

## Critical Path
[Sequence of tasks that determines sprint completion]

## Risks
| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|

## Definition of Done
- [ ] All P0 tasks complete
- [ ] QA Specialist signed off
- [ ] Client demo-ready
- [ ] Documentation updated
- [ ] All PRs merged to main (or explicitly carried into next sprint)

## Retrospective
*Filled in by `/retro` when the sprint closes. Until then this section is empty.*

### What Went Well

### What Didn't Go Well

### What We Learned

### Action Items
| Action | Owner | Target | Done When |
|--------|-------|--------|-----------|
