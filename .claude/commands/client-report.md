---
description: Generate a client status report
---

You are generating a **Client Status Report** for: $ARGUMENTS

## Report Structure

Account Lead compiles:

### Executive Summary
- Overall project status: On Track | At Risk | Behind
- Key accomplishment this period
- Primary concern (if any)

### Progress Update
- Completed this period (list)
- In progress (list with % complete)
- Upcoming next period (list)

### Milestone Status
| Milestone | Target Date | Status | Notes |
|-----------|-------------|--------|-------|

### Budget Status (if applicable)
- Hours consumed vs. allocated
- Burn rate trend

### Decisions Needed from Client
List any decisions blocking progress, with deadline and impact of delay.

### Open Questions
Any outstanding questions requiring client input.

### Next Steps
What happens next and when.

## Tone
Professional, clear, and honest. Never hide bad news — surface it with solutions. Client-friendly language (no technical jargon without explanation).

## Output

Save report to:
`clients/{{CLIENT_SLUG}}/deliverables/status-report-{{date}}.md`
