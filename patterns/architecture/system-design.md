# Pattern: System Design

**Category:** Architecture
**Owner:** Solution Architect
**Last Updated:** [Date]

## When to Use

Starting any new system or subsystem design. Always produces an Architecture Document before implementation.

## System Design Document Template

### 1. Overview
- System name and purpose
- Key users and use cases
- Non-functional requirements (performance, availability, scalability)

### 2. Context Diagram
High-level view: What systems does this interact with?

### 3. Component Architecture
- What are the major components?
- What does each component do?
- How do they communicate?

### 4. Data Architecture
- Data models (key entities and relationships)
- Data flow (where does data come from, where does it go?)
- Data storage (what stores what, and why?)
- Data security (who can access what?)

### 5. API Design
- Key interfaces between components
- Authentication/authorization approach
- Error handling approach

### 6. Infrastructure
- Deployment topology
- Scaling approach
- Monitoring approach

### 7. Security Architecture
- Authentication
- Authorization
- Data encryption (in transit, at rest)
- Secrets management

### 8. Trade-offs and Decisions
- Key decisions made with rationale
- Reference to ADRs

### 9. Open Questions
- Unresolved design questions requiring further input

## Review Checklist

Before architecture sign-off:
- [ ] All non-functional requirements addressed
- [ ] Security reviewed
- [ ] Single points of failure identified and mitigated
- [ ] Monitoring and observability designed in
- [ ] ADRs written for major decisions
