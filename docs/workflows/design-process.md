# Workflow: Design Process

## Inputs Required
- UX Research complete (UX Researcher sign-off)
- Creative Brief approved (Creative Director sign-off)
- Technical constraints documented (Solution Architect input)

## Design Phases

### Phase 1: Concept Exploration (1-2 weeks)
1. UI Designer creates 2-3 visual direction options
2. Creative Director reviews and selects direction
3. Present to client for direction alignment

### Phase 2: Design System Foundation (1-2 weeks)
1. UI Designer builds design tokens and core components
2. Creative Director reviews component quality
3. Frontend Developer reviews implementation feasibility

### Phase 3: Screen Design (2-4 weeks)
1. UI Designer designs key screens, high-fidelity
2. UX Researcher validates against research/journey map
3. Creative Director approves visual quality
4. Run `/design-review` for each major section

### Phase 4: Interaction Design (1 week)
1. UI Designer specifies all interaction patterns and animations
2. Frontend Developer reviews for feasibility
3. Creative Director final review

### Phase 5: Design Handoff
1. UI Designer prepares handoff documentation
2. Run `/design-review` for final sign-off
3. Account Lead notifies client of design complete milestone

## Design Gate

Before moving to development:
- [ ] All screens designed at high fidelity
- [ ] All states designed (hover, focus, active, disabled, error, loading)
- [ ] Responsive breakpoints addressed
- [ ] UX Researcher: ALIGNED
- [ ] Creative Director: APPROVED
- [ ] Client: design milestone signed off
