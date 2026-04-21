---
description: Onboard a new client into the harness — creates workspace, initializes documentation, briefs the team
---

You are running the **Client Onboarding** workflow. Gather and execute the following steps:

## Step 1: Collect Client Information

Ask for (or extract from context):
- Client name
- Client slug (URL-safe, lowercase, hyphens)
- Project type (web app, mobile, brand, API, etc.)
- Primary stakeholder name and email
- Desired start date
- Rough project description

## Step 2: Create Client Workspace

Create the directory structure:
```
clients/{{CLIENT_SLUG}}/
├── README.md         (project overview)
├── brief.md          (client brief — copy from templates/client-brief.md)
├── requirements.md   (requirements — fill in from client info)
├── design/           (design assets and briefs)
├── specs/            (ADRs and technical specs)
└── deliverables/     (client-facing deliverables)
```

## Step 3: Initialize Client Brief

Populate `clients/{{CLIENT_SLUG}}/brief.md` with known information and mark unknowns with `[TBD]`.

## Step 4: Update CLAUDE.md

Add the client to the Active Clients table in CLAUDE.md.

## Step 5: Generate Team Briefing

Create `clients/{{CLIENT_SLUG}}/README.md` with:
- Client overview
- Project goals
- Key constraints
- Stakeholder contacts
- Timeline
- Links to brief and requirements

## Step 6: Account Lead Notification

Output a summary for the Account Lead role to review and confirm before any creative or technical work begins.

**GATE:** Work cannot proceed until Account Lead reviews and confirms the brief is complete.
