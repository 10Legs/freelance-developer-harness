---
description: Run a design review with Creative Director and UX Researcher gates
---

You are running a **Design Review** for: $ARGUMENTS

## Review Protocol

### Step 1: UX Alignment Check
UX Researcher evaluates:
- Does this design address the journey map moments we identified?
- Does this design serve the personas we defined?
- Are there any usability concerns based on research?
- Verdict: ALIGNED | MISALIGNED (with specific issues)

### Step 2: Creative Direction Check
Creative Director evaluates:
- Does this honor the brand guidelines and creative brief?
- Is the visual execution excellent (not just acceptable)?
- Is it accessible?
- Verdict: APPROVED | REVISE (specific changes) | REJECT (reframe needed)

### Step 3: Technical Feasibility Check
Frontend Developer evaluates:
- Are there any implementation constraints that affect the design?
- Estimated implementation complexity: Low | Medium | High
- Any suggested adjustments for feasibility?

### Step 4: Resolution
If REVISE or REJECT: Document changes needed, assign to UI Designer, re-review.
If ALIGNED + APPROVED: Issue design handoff sign-off.

## Output

Document review result at:
`clients/{{CLIENT_SLUG}}/design/review-{{date}}.md`
