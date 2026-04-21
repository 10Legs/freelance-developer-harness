# Pattern: Design System Setup

**Category:** Design
**Owner:** UI Designer + Creative Director
**Last Updated:** [Date]
**Used In:** [list of client projects]

## When to Use

Starting any new client UI project that will have > 3 screens.

## Pattern Overview

A design system is the foundation for all visual decisions. It ensures consistency, speeds up design and development, and makes maintenance tractable.

## Structure

```
tokens/
├── colors.json        (brand, semantic, neutral palettes)
├── typography.json    (font families, scale, line heights)
├── spacing.json       (spacing scale, layout grid)
├── radius.json        (border radius tokens)
├── shadow.json        (elevation system)
└── motion.json        (transition tokens, easing curves)

components/
├── atoms/             (Button, Input, Icon, Badge, Avatar)
├── molecules/         (Card, FormField, Tooltip, Dropdown)
└── organisms/         (Header, Nav, DataTable, Modal)

documentation/
├── principles.md      (visual design principles)
├── brand.md           (brand usage guidelines)
└── accessibility.md   (accessibility requirements and patterns)
```

## Token Naming Convention

```
{category}-{semantic}-{variant}-{state}

Examples:
color-brand-primary-default
color-brand-primary-hover
color-semantic-error-default
spacing-component-padding-sm
```

## Implementation Notes

- Tokens in Figma should map 1:1 to CSS custom properties
- Component documentation includes: variants, states, do/don't examples, accessibility notes
- Changes to tokens require Creative Director approval

## Checklist

- [ ] Brand colors extracted and tokenized (with semantic naming)
- [ ] Typography scale defined (min 5 sizes, responsive)
- [ ] Spacing scale defined (8px base grid recommended)
- [ ] Core components: Button (5 variants), Input, Select, Card, Modal, Nav
- [ ] All components have: default, hover, focus, active, disabled states
- [ ] Dark mode tokens (if required)
- [ ] Design token export for developers
