# Pattern: Architecture Decision Record (ADR)

**Category:** Architecture
**Owner:** Solution Architect
**Template Version:** 1.0

## When to Use

Record every significant technical decision that:
- Is difficult to reverse
- Affects multiple components or systems
- Resolves a meaningful technical trade-off
- Future developers would wonder "why did they do it this way?"

## ADR Template

```markdown
# ADR-{{number}}: {{Title}}

**Status:** Proposed | Accepted | Deprecated | Superseded by ADR-{{n}}
**Date:** {{YYYY-MM-DD}}
**Deciders:** [list of people involved]
**Technical Area:** Frontend | Backend | Database | Infrastructure | Security | Integration

## Context

What is the situation or problem motivating this decision?
Include: technical context, business context, constraints.

## Decision

What is the change being made?
State clearly and unambiguously.

## Rationale

Why this option? What makes it better than alternatives for this context?

## Alternatives Considered

### Option A: {{name}}
- Pros: ...
- Cons: ...
- Why not chosen: ...

### Option B: {{name}}
- Pros: ...
- Cons: ...
- Why not chosen: ...

## Consequences

### Positive
- [What becomes better?]

### Negative
- [What becomes harder or worse? What technical debt is incurred?]

### Neutral
- [What changes but isn't clearly better or worse?]

## Compliance

- Security implications: [Reviewed by Security Reviewer: Yes/No/NA]
- Performance implications: [assessed]
- Scalability implications: [assessed]

## Review

Reviewed by Solution Architect: [Name, Date]
```
