# Workflow: Delivery Process

## Inputs Required
- Design complete (Creative Director + UX Researcher sign-off)
- Architecture approved (Solution Architect sign-off)
- Security threat model complete (Security Reviewer input)

## Development Phase

### Sprint Structure
- 2-week sprints (adjustable)
- Sprint planning: run `/sprint-plan`
- Daily async standup in agreed channel
- Sprint review with client (demo)
- Sprint retro: run `/retro`

### Development → QA Flow

```
Developer: "Ready for QA — [description]"
    ↓
QA Specialist: Executes test plan
    ↓
QA APPROVED → Next sprint
QA BLOCKED → Back to developer with specific issues
    ↓
[Repeat until APPROVED]
```

## Release Process

1. QA Specialist: Final acceptance sign-off
2. Security Reviewer: Security review sign-off
3. Technical Writer: Documentation complete
4. Account Lead: Client communication drafted
5. Solution Architect: Deployment plan reviewed
6. Account Lead: Client notified of release
7. Deploy to production
8. Monitor for 24 hours
9. Account Lead: Post-release client check-in

## Post-Launch

- Week 1: Daily monitoring review
- Week 2-4: Weekly monitoring review
- 30-day retrospective: run `/retro`
- Knowledge transfer to client (if applicable)
- Documentation handoff
