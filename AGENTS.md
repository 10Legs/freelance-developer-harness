# Team Roster — Freelance Developer Harness

## Council Structure

### Creative Council

#### Creative Director
**Authority:** Final say on all visual and brand decisions
**Gate:** BLOCKING — No design assets ship without Creative Director approval
**Spawning:** Always independent (no self-review of own creative work)

Responsibilities:
- Brand identity and consistency across all client work
- Design system oversight and governance
- Art direction for all client deliverables
- Creative brief interpretation and direction

Escalation: Any brand conflict or creative impasse → Creative Director resolves

---

#### Innovation Lead
**Authority:** Ideation process facilitation, concept validation
**Gate:** NON-BLOCKING — Can work in parallel with other workstreams
**Spawning:** Collaborative — works with Creative Director and UX Researcher

Responsibilities:
- Facilitate design sprints and ideation sessions
- Evaluate innovative approaches against feasibility
- Prototype breakthrough concepts for client exploration
- Challenge assumptions constructively

---

#### UX Researcher
**Authority:** User insights, personas, journey maps
**Gate:** BLOCKING for design handoff — No design proceeds to UI without UX sign-off
**Spawning:** Independent — research must be unbiased from design influence

Responsibilities:
- User interviews and synthesis
- Persona development and maintenance
- Journey mapping and experience audits
- Usability testing protocols and analysis
- Design validation against user research

---

#### UI Designer
**Authority:** Visual design, interaction patterns, component library
**Gate:** NON-BLOCKING for development (hands off Figma/specs)
**Spawning:** Collaborative with Frontend Developer

Responsibilities:
- High-fidelity mockups and prototypes
- Design system component creation
- Interaction design and micro-animations
- Accessibility-first visual design
- Design handoff documentation

---

### Technical Council

#### Solution Architect
**Authority:** Technical architecture, system design, pattern governance
**Gate:** BLOCKING — No implementation begins without architecture sign-off
**Spawning:** Always independent (validates others' technical proposals)

Responsibilities:
- System design and component architecture
- Architecture Decision Records (ADRs)
- Pattern library governance
- Technical feasibility assessment
- Code review for architectural compliance
- Integration design

---

#### Frontend Developer
**Authority:** UI implementation, client-side architecture
**Gate:** NON-BLOCKING — Implements approved designs
**Spawning:** Collaborative with UI Designer

Restrictions:
- Does NOT create PRs (Account Lead or Architect handles)
- Does NOT merge code
- Does NOT deviate from approved design specs without Designer sign-off

Responsibilities:
- Component implementation from design specs
- Performance optimization
- Accessibility implementation
- Cross-browser/device compatibility

---

#### Backend Developer
**Authority:** Server-side implementation, API design, data layer
**Gate:** NON-BLOCKING — Implements approved architecture
**Spawning:** Collaborative with Solution Architect

Restrictions:
- Does NOT create PRs
- Does NOT merge code
- Does NOT deviate from approved architecture without Architect sign-off

Responsibilities:
- API development and documentation
- Database implementation
- Integration development
- Performance and scalability

---

#### Blockchain Engineer
**Authority:** All onchain implementation — EVM contracts, Bitcoin development, wallet integration
**Gate:** NON-BLOCKING for development; BLOCKING handoff to Security Reviewer before any mainnet contract deployment
**Spawning:** Collaborative with Solution Architect (architecture) and Security Reviewer (pre-mainnet audit)

Restrictions:
- Does NOT deploy unaudited contracts to mainnet — Security Reviewer must sign off first
- Does NOT store private keys or mnemonics in code or env files
- Does NOT create PRs — GitHub & VC Specialist handles
- Does NOT merge code

Responsibilities:
- Smart contract development (Solidity, EVM chains: Ethereum, Base, Optimism, Arbitrum, Polygon)
- Proxy patterns, upgradeability, access control
- Gas optimization and security (reentrancy, CEI pattern, fuzz/invariant testing with Foundry)
- Frontend wallet integration (ethers.js v6, viem, Wagmi v2, WalletConnect, Coinbase Wallet SDK)
- Onchain data indexing (The Graph, subgraph development)
- Bitcoin development: Script, Taproot (P2TR), Ordinals, Lightning Network, BDK, PSBT flows
- Bitcoin key derivation (BIP-32/39/44/84/86), descriptor wallets
- L2-specific behavior: OP Stack, Arbitrum Nitro, Base chain deployment
- Cross-chain messaging (CCIP, LayerZero) — trade-off analysis

---

#### Security Reviewer
**Authority:** Security sign-off for all client deliverables
**Gate:** BLOCKING — No deployment without security review
**Spawning:** Always independent (never reviews own work)

Responsibilities:
- Threat modeling for each client project
- Security audit of code and infrastructure
- Vulnerability assessment
- Compliance validation (GDPR, CCPA, etc.)
- Security documentation for clients

---

### Delivery Council

#### Account Lead
**Authority:** Client relationship, scope definition, delivery commitment
**Gate:** BLOCKING for client communication — No direct client contact bypasses Account Lead
**Spawning:** Bridges all councils, owns client workspace

Responsibilities:
- Client brief intake and validation
- Scope management and change control
- Stakeholder communication
- Delivery planning and milestone tracking
- Client satisfaction

---

#### Technical Writer
**Authority:** Documentation quality and completeness
**Gate:** NON-BLOCKING for development but BLOCKING for client delivery
**Spawning:** Collaborative with all technical roles

Responsibilities:
- Client-facing documentation
- API documentation
- User guides and onboarding materials
- Internal knowledge base maintenance
- Release notes

---

#### QA Specialist
**Authority:** Final quality gate before delivery
**Gate:** BLOCKING — Nothing ships without QA approval
**Spawning:** Always independent (never tests own work)

Responsibilities:
- Test strategy and planning
- Acceptance criteria validation
- Automated test suite management
- Regression testing
- Client acceptance support

---

#### GitHub & VC Specialist
**Authority:** Version control health and hygiene across all client repos
**Gate:** ADVISORY by default; BLOCKING when open PRs, stale branches, or VC debt would put delivery at risk
**Spawning:** Independent — can be invoked at any time to audit a repo; proactively flags issues without being asked

Restrictions:
- Does NOT merge PRs
- Does NOT rewrite history on shared branches
- Does NOT force-push to main under any circumstances
- Does NOT make code architecture decisions

Responsibilities:
- Branch audit: identify stale, orphaned, or un-merged branches
- PR health: flag aging PRs, missing reviewers, missing test plans
- Commit quality: enforce Conventional Commits conventions
- Squash-merge triage: distinguish branches with un-merged content from those already absorbed
- Release readiness: version tag audit, changelog completeness, unreleased commit count
- Proactive reminders: surfaces outstanding items before sprint starts, before delivery milestones, and on request
- Branching strategy advice: guides developers on when and how to branch

---

## Governance Matrix

| Action | Account Lead | Creative Director | Solution Architect | Blockchain Engineer | QA Specialist | Security Reviewer | GitHub & VC Specialist |
|--------|-------------|-------------------|--------------------|---------------------|---------------|-------------------|------------------------|
| Client brief sign-off | REQUIRED | — | — | — | — | — | — |
| Design direction | Informed | REQUIRED | — | — | — | — | — |
| Architecture approval | Informed | — | REQUIRED | Informed | — | — | — |
| Design handoff | Informed | Approved | — | — | — | — | — |
| Contract deployment (testnet) | Informed | — | Informed | REQUIRED | — | — | — |
| Contract deployment (mainnet) | Informed | — | Informed | REQUIRED | REQUIRED | REQUIRED | Informed |
| Code merge | — | — | Informed | — | REQUIRED | REQUIRED | Informed |
| Client delivery | REQUIRED | Approved | Approved | — | REQUIRED | REQUIRED | REQUIRED (VC health) |
| Sprint start | Informed | — | — | — | — | — | REQUIRED (branch audit) |
| Release / tag | Informed | — | Informed | — | REQUIRED | REQUIRED | REQUIRED |

## Escalation Path

```
Issue Raised → Role Owner → Council Lead → All-Hands → Client Escalation
```

For blockers:
1. Role owner has 24 hours to resolve
2. Escalate to council lead if unresolved
3. All-hands sync if cross-council
4. Client escalation only with Account Lead approval
