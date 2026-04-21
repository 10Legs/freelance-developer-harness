# SOP: Design Review

## When to Run

- After any significant design milestone
- Before design handoff to development
- When client requests a design review
- Command: `/design-review [context]`

## Participants

| Role | Involvement | Authority |
|------|------------|-----------|
| UI Designer | Presents work | Implements feedback |
| UX Researcher | Validates against research | BLOCKING gate |
| Creative Director | Reviews quality | BLOCKING gate |
| Frontend Developer | Advises on feasibility | Advisory |
| Account Lead | Contextualizes client needs | Advisory |

## Review Structure

1. **Context setting (5 min):** Designer walks through what's being reviewed and the context
2. **Silent review (10 min):** Everyone reviews without commenting
3. **UX alignment check (10 min):** Researcher validates against research artifacts
4. **Creative review (15 min):** Creative Director provides feedback
5. **Feasibility input (5 min):** Developer notes any implementation concerns
6. **Resolution (10 min):** Actions and verdicts documented

## Verdicts

**APPROVED:** Work proceeds to next phase
**REVISE:** Specific changes required, then re-review
**REJECT:** Direction is fundamentally wrong, requires redesign

## Documentation

All reviews documented at:
`clients/{{CLIENT_SLUG}}/design/review-{{YYYY-MM-DD}}.md`
