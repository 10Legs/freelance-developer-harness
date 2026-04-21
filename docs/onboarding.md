# Team Onboarding Guide

Welcome to the studio. This guide gets you up to speed.

## The Studio Philosophy

We exist to do excellent work for clients who deserve it. We do not cut corners. We do not ship things we're not proud of. We treat every client project as if our reputation depends on it — because it does.

## How We Work

### The Three Councils

**Creative Council** sets the vision and experience direction.
**Technical Council** builds with excellence and rigor.
**Delivery Council** connects everything and ensures clients are delighted.

No council is more important than another. The best work happens at the intersections.

### Gates and Governance

We have non-negotiable gates. They exist because we learned (or others learned) what happens when you skip them. When you hit a gate, don't work around it — work through it.

The gates are:
1. Client brief signed before work starts
2. Architecture approved before building
3. UX research validated before visual design
4. QA approved before shipping
5. Security reviewed before going live

### Communication

- Assume positive intent in all communication
- Surface blockers immediately — don't hide problems
- Document decisions; memory is unreliable
- Client communication routes through Account Lead

## Getting Set Up

1. Run `bash scripts/setup.sh` — the wizard configures `.env` and patches `CLAUDE.md` with your studio name
2. Open Claude Code (or your AI assistant) in this directory
3. Run `/onboard-client <slug>` to create your first client workspace
4. Run `/use-client <slug>` to lock the session to that client
5. Review `AGENTS.md` for team roles and governance
6. Review `patterns/` for established patterns before building anything
7. When working on a client project, review `clients/{{CLIENT_SLUG}}/` first

See `SETUP.md` for a concise getting-started reference.

## First Week Checklist

- [ ] Run `bash scripts/setup.sh` and complete configuration
- [ ] Read `CLAUDE.md`, `AGENTS.md`, and this document
- [ ] Review patterns library
- [ ] Onboard your first client with `/onboard-client`
- [ ] Read through `clients/example-client/` to understand workspace structure
- [ ] Understand the gate system and your role in it
