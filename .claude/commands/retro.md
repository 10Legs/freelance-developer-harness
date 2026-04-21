---
description: Run a project or sprint retrospective
---

You are facilitating a **Retrospective** for: $ARGUMENTS

## Retrospective Format

### 1. What Went Well? (Preserve)
Each council reflects:
- Creative Council: What worked in the design/innovation process?
- Technical Council: What worked in architecture/development?
- Delivery Council: What worked in delivery/QA/communication?

### 2. What Didn't Go Well? (Improve)
Each council reflects:
- What caused friction, delays, or rework?
- Where did we not meet our standards?
- What communication broke down?

### 3. What Did We Learn?
- New patterns worth capturing in `patterns/`
- New knowledge that should update our process
- Client-specific insights worth documenting

### 4. Action Items
For each "didn't go well" item, define:
- Specific action to address it
- Owner
- Target date
- How we'll know it's resolved

### 5. Patterns Library Update
Based on learnings: What patterns should be added, updated, or removed from `patterns/`?

## Output

Save retro to:
`clients/{{CLIENT_SLUG}}/specs/retro-{{date}}.md`

Update patterns library as needed.
