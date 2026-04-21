---
description: Run an architecture review with Solution Architect gate
---

You are running an **Architecture Review** for: $ARGUMENTS

## Review Checklist

Solution Architect evaluates:

### Pattern Compliance
- [ ] Does this follow established patterns in `patterns/architecture/`?
- [ ] If new pattern, has it been documented?
- [ ] Are there reusable patterns being duplicated unnecessarily?

### Design Principles
- [ ] Is this the simplest design that meets requirements?
- [ ] Is it designed for change (extensible)?
- [ ] Are all decisions documented?

### Security
- [ ] Has Security Reviewer been consulted for security-sensitive decisions?
- [ ] Are there any obvious security concerns?

### Scalability
- [ ] Does this design hold under 10x current expected load?
- [ ] Are there single points of failure?

### ADR Requirement
- [ ] Have all significant decisions been recorded as ADRs?

## Verdict
- **APPROVED** — Implementation may proceed
- **APPROVED WITH CONDITIONS** — Implementation may proceed after addressing listed conditions
- **BLOCKED** — Fundamental redesign needed (specific issues listed)

## Output

Document review at:
`clients/{{CLIENT_SLUG}}/specs/arch-review-{{date}}.md`
