# Requirement Document Formats Reference

## Table of Contents

1. [Business & Product Documents](#business--product-documents)
2. [Technical Design Documents](#technical-design-documents)
3. [Specialized Specifications](#specialized-specifications)
4. [Format Comparison](#format-comparison)
5. [Selection Guide](#selection-guide)

---

## Business & Product Documents

### Business Requirements Document (BRD)

- **Audience:** Business stakeholders, executives, clients
- **Purpose:** Align business goals and scope at project initiation
- **Key Contents:** Goals, high-level business needs, scope, constraints, stakeholder list, high-level requirements, cost-benefit, assumptions
- **Formality:** High
- **When to Use:** At project initiation to establish business justification and scope boundaries

### Product Requirements Document (PRD)

- **Audience:** Product managers, UX, engineering
- **Purpose:** Communicate product vision and scope; keeps teams aligned on "what" to build
- **Structure:**
  - Purpose
  - Goals & KPIs
  - Features
  - User Scenarios
  - Constraints
  - Timeline
- **Formality:** Medium
- **When to Use:** For building or enhancing a product; vision-driven, readable by both technical and non-technical audiences

### Market Requirements Document (MRD)

- **Audience:** Product/marketing leadership, strategy teams
- **Purpose:** Validate product-market fit and define demand
- **Key Contents:** Market analysis, target users, competitor review, product positioning, high-level features
- **When to Use:** Before or alongside PRD to validate market need

### Scope Statement

- **Audience:** Project stakeholders, project managers
- **Purpose:** Define what is in scope and out of scope
- **Key Contents:** Scope boundaries, assumptions, deliverables, exclusions
- **When to Use:** Early in the project to prevent scope creep

---

## Technical Design Documents

### Software Requirements Specification (SRS) — IEEE 830/29148

- **Audience:** Technical team, architects, QA
- **Structure:**
  1. Introduction (Purpose, Scope, Definitions, References)
  2. Overall Description (Product perspective, assumptions, constraints, stakeholders, operating environment)
  3. Specific Requirements (Functional, Non-functional, Interfaces, Data, Error handling, Validation, Dependencies)
  4. Appendices (Glossary, Diagrams, Traceability matrices, Revision history)
- **Formality:** High
- **Machine-Readable:** No
- **When to Use:** Large, regulated, or mission-critical systems. Often serves as a formal contract baseline.

### Functional Requirements Document (FRD)

- **Audience:** Analysts, developers, testers
- **Purpose:** Translate business needs into implementable functions
- **Structure:** Feature ID, Description, Priority, Dependencies, UI Mockups, API Contracts
- **Formality:** Medium
- **When to Use:** After BRD, for feature-focused incremental delivery

### High-Level Design (HLD)

- **Audience:** Architects, tech leads, stakeholders
- **Focus:**
  - Major systems and service boundaries
  - Integrations and data flow
  - Infrastructure shape
  - Technology stack decisions
- **When to Use:** After PRD, to establish architecture before detailed implementation

### Low-Level Design (LLD)

- **Audience:** Engineers building the feature
- **Focus:**
  - Modules, classes, functions
  - Schemas and data models
  - API contracts and sequence logic
  - Validation rules
- **When to Use:** For complex features requiring module/class/function-level detail

### Architecture Decision Record (ADR)

- **Audience:** Current and future engineering team
- **Structure:**
  - Decision made
  - Context and rationale
  - Alternatives considered
  - Tradeoffs and consequences
- **When to Use:** For long-term traceability of significant technical decisions

---

## Specialized Specifications

### API Specification

- **Focus:** Endpoints, request/response models, auth, status codes, rate limits, examples, versioning
- **Formats:** OpenAPI/Swagger (YAML/JSON), GraphQL schema, protobuf
- **When to Use:** Backend microservices, API contracts, service interfaces

### Data Design Spec

- **Focus:** Entities, relationships, schemas, indexing, storage choice, retention, lineage, migration impact
- **When to Use:** Database-heavy features, schema migrations, data lineage tracking

### Integration Design Spec

- **Focus:** Source/target systems, protocols, contracts, retries, error handling, event/message formats, third-party dependencies
- **When to Use:** Multi-system interop, event-driven architecture, partner integrations

### Security Design Spec

- **Focus:** Authn/authz, secrets handling, encryption, PII/data classification, threat model, abuse cases, audit logging, compliance
- **When to Use:** Enterprise and regulated systems, features handling sensitive data

### Infrastructure / Deployment Spec

- **Focus:** Environments, hosting, networking, CI/CD, scaling, secrets, observability, rollback strategy
- **When to Use:** DevOps, SRE, and platform team handoffs

### Test Design Spec

- **Focus:** Unit, integration, E2E coverage, performance testing, security testing, acceptance criteria, test data needs
- **When to Use:** Quality-critical features where testing strategy must be designed, not assumed

### Migration / Transition Spec

- **Focus:** Current state, target state, cutover plan, backward compatibility, data migration, rollback, deprecation timeline
- **When to Use:** Replacing or modernizing an existing system

### Operational Runbook

- **Focus:** Alerts, dashboards, known failure modes, recovery steps, on-call actions, maintenance tasks
- **When to Use:** Post-release support documentation

### Performance / Scalability Spec

- **Focus:** Latency targets, throughput, concurrency, caching, scaling limits, load assumptions
- **When to Use:** SLA-driven features with specific performance requirements

### Observability Spec

- **Focus:** Logs, metrics, traces, alerts, dashboards, SLOs
- **When to Use:** Systems requiring measurable operational health

### UI Technical Spec

- **Focus:** State handling, component structure, routing, API bindings, analytics, accessibility, responsive behavior
- **When to Use:** Complex frontend features

### AI / ML System Spec

- **Focus:** Prompts/model choice, context sources, evaluation criteria, guardrails, fallback logic, human review, monitoring, cost controls
- **When to Use:** AI-enabled systems

---

## Format Comparison

| Format | Best For | Formality | Machine-Readable | Agile-Friendly |
|--------|----------|-----------|-------------------|----------------|
| SRS (IEEE) | Regulated systems | High | No | No |
| User Stories | Agile teams | Low | No | Yes |
| Use Cases | UX and testing | Medium | No | Yes |
| FRD | Feature breakdown | Medium | No | Yes |
| PRD | Product vision | Medium | No | Yes |
| OpenAPI | API specs | Low | Yes | Yes |
| Markdown modular | Dev-first teams | Medium | Yes | Yes |
| Hybrid | Mixed teams | Medium | Partial | Yes |

---

## Selection Guide

Use this decision tree to select the right document format:

1. **Is this a regulated or contractual project?**
   - Yes → Start with SRS (IEEE 830/29148)
   - No → Continue

2. **Is the primary audience business stakeholders?**
   - Yes → Start with BRD, then PRD
   - No → Continue

3. **Is the team using Agile methodology?**
   - Yes → PRD + User Stories with Gherkin acceptance criteria
   - No → FRD or SRS depending on formality needs

4. **Is this primarily an API or backend service?**
   - Yes → OpenAPI spec as primary, with supporting HLD
   - No → Continue

5. **Is this a product with user-facing features?**
   - Yes → PRD + UX Flows + HLD
   - No → HLD + relevant specialized specs

6. **Default recommendation:** PRD (anchor) + HLD + API Spec + UX Flows — this covers most software projects with cross-functional teams.
