# SOP: Architecture Review

## When to Run

- Before any new system or significant feature begins development
- When a significant architectural change is proposed
- When deviating from established patterns
- Command: `/arch-review [context]`

## Participants

| Role | Involvement | Authority |
|------|------------|-----------|
| Solution Architect | Reviews and decides | BLOCKING gate |
| Security Reviewer | Reviews security implications | BLOCKING gate (security aspects) |
| Backend Developer | Presents implementation plan | Advisory |
| Frontend Developer | Presents client-side implications | Advisory |
| Account Lead | Ensures client context is represented | Advisory |

## Review Checklist

See `/arch-review` command for complete checklist.

## Verdicts

**APPROVED:** Implementation may begin
**APPROVED WITH CONDITIONS:** Implementation may begin after listed conditions met
**BLOCKED:** Fundamental redesign required

## ADR Requirement

Any APPROVED architecture with significant decisions produces an ADR at:
`clients/{{CLIENT_SLUG}}/specs/adr-{{N}}-{{title}}.md`

## Review Timeline

Reviews should complete within 24 hours of request.
If blocked, escalate to all-hands sync.
