# Document Templates

Ready-to-use section templates for PRD, HLD, API Spec, and UX Flows. Adapt placeholders (`[brackets]`) to the specific project domain.

## Table of Contents

1. [PRD Template](#prd-template)
2. [HLD Template](#hld-template)
3. [API Specification Template](#api-specification-template)
4. [UX Flows Template](#ux-flows-template)
5. [Extended Deliverables — When to Include](#extended-deliverables--when-to-include)
6. [Traceability Checklist](#traceability-checklist)
7. [Mermaid Diagram Templates](#mermaid-diagram-templates)

---

## PRD Template

```markdown
# [Product/Feature Name] — Product Requirements Document

## 1. Product Overview

### 1.1 Purpose
[What is being built and why. The problem it solves.]

### 1.2 Target Users
[Who uses this — personas, roles, segments.]

### 1.3 Goals & Success Metrics
| Goal | Metric | Target |
|------|--------|--------|
| [Goal 1] | [How measured] | [Threshold] |
| [Goal 2] | [How measured] | [Threshold] |

### 1.4 Scope
**In scope:** [What this PRD covers]
**Out of scope:** [What is explicitly excluded and why]

---

## 2. Tasks (Features)

### 2.1 [Feature Name]

**FR-[ID]:** [Feature Title]
- **Description:** [What the system does]
- **Actor:** [Who triggers it]
- **Use Case:** [Primary scenario]
- **Preconditions:** [What must be true]
- **Flow:**
  1. [Step]
  2. [Step]
- **Postconditions:** [Expected outcome]
- **Acceptance Criteria:**
  - Given [context], When [action], Then [outcome]
- **Priority:** [Must / Should / Could / Won't]
- **Dependencies:** [Other FR IDs]

<!-- Repeat for each feature -->

---

## 3. Sub-tasks

### 3.1 [Parent Feature] — Sub-tasks

**FR-[ID].1:** [Sub-task Title]
- **Description:** [Granular breakdown]
- **Acceptance Criteria:** [Given/When/Then]
- **Priority:** [Must / Should / Could / Won't]

<!-- Repeat for complex features -->

---

## 4. Build Validation

| FR ID | Feature | Validation Method | Acceptance Gate |
|-------|---------|-------------------|-----------------|
| FR-001 | [Feature] | [Unit test / Integration test / Manual QA] | [Pass criteria] |

---

## 5. Non-Functional Requirements

**NFR-[ID]:** [Title]
- **Category:** [Performance | Reliability | Security | Usability | Maintainability | Scalability]
- **Target:** [Metric]
- **Measurement:** [How verified]
- **Priority:** [Must / Should / Could / Won't]

---

## 6. Constraints

| Type | Constraint | Impact |
|------|-----------|--------|
| Technology | [e.g., Must use PostgreSQL] | [Why this constrains design] |
| Regulatory | [e.g., GDPR compliance] | [What this requires] |
| Timeline | [e.g., Launch by Q3] | [What this limits] |
| Budget | [e.g., No paid third-party APIs] | [What this excludes] |

---

## 7. Assumptions & Dependencies

### Assumptions
- [Assumption 1 — what must be true for this plan to work]
- [Assumption 2]

### External Dependencies
| Dependency | Owner | Status | Risk if Unavailable |
|-----------|-------|--------|---------------------|
| [System/Service] | [Team] | [Available / In Progress / Unknown] | [Impact] |

---

## 8. Stakeholders & Users

| Role | Name/Team | Relationship to Features |
|------|-----------|-------------------------|
| Product Owner | [Name] | Approves scope and priority |
| [Persona] | [Description] | Primary user of [features] |

---

## 9. Open Questions

| # | Question | Owner | Due Date | Resolution |
|---|----------|-------|----------|------------|
| 1 | [Unresolved question] | [Who decides] | [When] | [Pending] |

---

## Appendix

### Glossary
| Term | Definition |
|------|-----------|
| [Term] | [Definition] |
```

---

## HLD Template

```markdown
# [System Name] — High-Level Design

## 1. System Architecture

### 1.1 Architecture Overview
[Describe the overall architecture pattern: monolith, microservices, serverless, event-driven, etc.]

### 1.2 Component Diagram

<!-- Mermaid diagram here -->

### 1.3 Component Inventory
| Component | Responsibility | Technology | Traces to |
|-----------|---------------|------------|-----------|
| [Service A] | [What it does] | [Stack] | FR-001, FR-003 |

---

## 2. Data Flow

### 2.1 Primary Data Flows
[Describe how data moves between components for key use cases.]

### 2.2 Data Flow Diagram

<!-- Mermaid diagram here -->

---

## 3. Integrations

| External System | Protocol | Purpose | Data Exchanged | Traces to |
|----------------|----------|---------|----------------|-----------|
| [System] | [REST / gRPC / Events] | [Why] | [What data] | FR-[ID] |

---

## 4. Infrastructure Shape

### 4.1 Environments
| Environment | Purpose | Configuration |
|-------------|---------|---------------|
| Development | [Local dev] | [Details] |
| Staging | [Pre-production testing] | [Details] |
| Production | [Live traffic] | [Details] |

### 4.2 Scaling Approach
[Horizontal / Vertical / Auto-scaling triggers and thresholds]

---

## 5. Technology Stack

| Layer | Technology | Rationale |
|-------|-----------|-----------|
| Frontend | [Framework] | [Why chosen] |
| Backend | [Language/Framework] | [Why chosen] |
| Database | [DB engine] | [Why chosen] |
| Messaging | [Queue/Broker] | [Why chosen] |
| Infrastructure | [Cloud/Platform] | [Why chosen] |

---

## 6. Key Design Decisions

### ADR-001: [Decision Title]

- **Status:** [Accepted / Proposed / Deprecated]
- **Context:** [What prompted this decision]
- **Decision:** [What was decided]
- **Alternatives Considered:**
  | Option | Pros | Cons |
  |--------|------|------|
  | [Alt A] | [Pros] | [Cons] |
  | [Alt B] | [Pros] | [Cons] |
- **Consequences:** [What this means going forward]
- **Traces to:** [NFR or FR IDs]

---

## 7. Security Considerations

[High-level security posture: authn/authz model, data classification, encryption approach. Reference SEC- requirements.]

---

## 8. Open Design Questions

| # | Question | Impact | Owner |
|---|----------|--------|-------|
| 1 | [Question] | [What it blocks] | [Who decides] |
```

---

## API Specification Template

```markdown
# [Service Name] — API Specification

## 1. Overview

- **Base URL:** `[https://api.example.com/v1]`
- **Protocol:** [REST / GraphQL / gRPC]
- **Format:** [JSON / Protobuf]
- **Versioning Strategy:** [URL path / Header / Query param]

---

## 2. Authentication & Authorization

- **Mechanism:** [Bearer Token / API Key / OAuth 2.0]
- **Scopes / Roles:**
  | Scope/Role | Access Level | Description |
  |-----------|-------------|-------------|
  | [role] | [Read / Write / Admin] | [What they can do] |

---

## 3. Endpoints

### 3.1 [Resource Name]

#### `[METHOD] /[path]`

**API-[ID]:** [Endpoint Title]
- **Description:** [What this endpoint does]
- **Traces to:** FR-[ID]
- **Auth Required:** [Yes / No]
- **Rate Limit:** [Requests per window]

**Request:**
| Parameter | Location | Type | Required | Description |
|-----------|----------|------|----------|-------------|
| [param] | [path / query / header / body] | [type] | [Yes/No] | [What it is] |

**Request Body Example:**
```json
{
  "field": "value"
}
```

**Response — 200 OK:**
```json
{
  "field": "value"
}
```

**Error Responses:**
| Status | Code | Description | Retry |
|--------|------|-------------|-------|
| 400 | VALIDATION_ERROR | [When this occurs] | No |
| 401 | UNAUTHORIZED | [When this occurs] | No — re-authenticate |
| 404 | NOT_FOUND | [When this occurs] | No |
| 429 | RATE_LIMITED | [When this occurs] | Yes — after Retry-After header |
| 500 | INTERNAL_ERROR | [When this occurs] | Yes — with exponential backoff |

<!-- Repeat for each endpoint -->

---

## 4. Common Models

### [Model Name]
| Field | Type | Required | Description | Constraints |
|-------|------|----------|-------------|-------------|
| [field] | [string / number / boolean / object / array] | [Yes/No] | [What it is] | [Validation rules] |

---

## 5. Pagination

- **Style:** [Cursor-based / Offset-based]
- **Parameters:** `limit` (default: 20, max: 100), `cursor` / `offset`
- **Response envelope:**
```json
{
  "data": [],
  "pagination": {
    "next_cursor": "abc123",
    "has_more": true
  }
}
```

---

## 6. Rate Limits

| Tier | Limit | Window | Scope |
|------|-------|--------|-------|
| [Default] | [N requests] | [per minute / hour] | [Per user / Per API key] |

Rate limit headers: `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`
```

---

## UX Flows Template

```markdown
# [Product/Feature Name] — UX Flows

## 1. User Journeys

### 1.1 [Journey Name] — [Persona]

**UX-[ID]:** [Journey Title]
- **Persona:** [Who is performing this journey]
- **Goal:** [What they want to accomplish]
- **Entry Point:** [Where/how they start]
- **Traces to:** FR-[IDs]

**Flow:**
| Step | User Action | System Response | Screen/State |
|------|------------|-----------------|--------------|
| 1 | [What user does] | [What system shows/does] | [Screen name] |
| 2 | [What user does] | [What system shows/does] | [Screen name] |

**Success Criteria:** [How the user knows they succeeded]
**Time to Complete:** [Expected duration]

---

## 2. Screen / State Inventory

| Screen | Purpose | Key Elements | Traces to |
|--------|---------|-------------|-----------|
| [Screen name] | [What it shows] | [Main UI elements] | UX-[ID], FR-[ID] |

---

## 3. Interaction Patterns

### 3.1 Navigation
[How users move between screens — tabs, breadcrumbs, back navigation, deep links]

### 3.2 Input Handling
[Form patterns, validation timing (inline vs. on-submit), auto-save behavior]

### 3.3 Feedback Mechanisms
[Loading states, success confirmations, progress indicators, toast notifications]

---

## 4. Edge Cases & Error States

| Scenario | User Sees | Recovery Action | Traces to |
|----------|----------|-----------------|-----------|
| [Error condition] | [Error message / UI state] | [What user can do] | FR-[ID] |
| [Empty state] | [Empty state message / illustration] | [CTA to populate] | UX-[ID] |
| [Timeout] | [Timeout message] | [Retry / Contact support] | NFR-[ID] |

---

## 5. Accessibility

| Requirement | Implementation | WCAG Criterion |
|-------------|---------------|----------------|
| Keyboard navigation | [All interactive elements focusable, logical tab order] | 2.1.1 |
| Screen reader support | [ARIA labels, semantic HTML, live regions for dynamic content] | 4.1.2 |
| Color contrast | [Minimum 4.5:1 for normal text, 3:1 for large text] | 1.4.3 |
| Focus indicators | [Visible focus ring on all interactive elements] | 2.4.7 |
```

---

## Extended Deliverables — When to Include

| Document | Include When |
|----------|-------------|
| Low-Level Design (LLD) | Complex implementation requiring module/class/function-level detail |
| Data Design Spec | Database-heavy features, schema migrations, data lineage |
| Integration Design Spec | Multi-system interop, event-driven architecture, partner APIs |
| Security Design Spec | Auth flows, PII handling, compliance requirements, threat models |
| Infrastructure / Deployment Spec | CI/CD, environments, scaling, secrets, observability |
| Test Design Spec | Quality-critical features needing explicit test strategy |
| Migration / Transition Spec | Replacing or modernizing an existing system |
| Operational Runbook | Post-release support, alerting, known failure modes |
| Performance / Scalability Spec | SLA-driven features, latency targets, load assumptions |
| Observability Spec | Logging, metrics, traces, dashboards, SLOs |

---

## Traceability Checklist

Use this checklist after generating a full document set to validate cross-references:

```markdown
## Traceability Validation

### PRD → HLD
- [ ] Every FR maps to at least one HLD component
- [ ] Every NFR maps to an infrastructure or architecture decision
- [ ] All external dependencies appear in HLD Integrations section

### PRD → API Spec
- [ ] Every user-facing feature has corresponding API endpoints
- [ ] API auth model aligns with PRD security requirements
- [ ] Error handling covers all PRD edge cases

### PRD → UX Flows
- [ ] Every user-facing FR has a corresponding UX journey
- [ ] All personas in PRD appear in UX Flows
- [ ] Edge cases and error states are mapped

### Cross-Document
- [ ] Terminology is consistent (check Glossary)
- [ ] Data models match across API Spec and HLD
- [ ] Priority levels are consistent for shared requirements
- [ ] No orphaned requirements (IDs referenced but not defined)
- [ ] All open questions are surfaced in relevant documents
```

---

## Mermaid Diagram Templates

### System Architecture (C4 Style)

```
graph TB
    subgraph "External"
        User[User / Browser]
        ExtAPI[External API]
    end
    subgraph "Application"
        FE[Frontend<br/>React / Next.js]
        API[API Gateway]
        SvcA[Service A]
        SvcB[Service B]
    end
    subgraph "Data"
        DB[(Database)]
        Cache[(Cache)]
        Queue[Message Queue]
    end

    User --> FE
    FE --> API
    API --> SvcA
    API --> SvcB
    SvcA --> DB
    SvcA --> Cache
    SvcB --> Queue
    SvcB --> ExtAPI
```

### Sequence Diagram

```
sequenceDiagram
    actor User
    participant FE as Frontend
    participant API as API Server
    participant DB as Database

    User->>FE: [User action]
    FE->>API: [API request]
    API->>DB: [Query]
    DB-->>API: [Result]
    API-->>FE: [Response]
    FE-->>User: [UI update]
```

### State Machine

```
stateDiagram-v2
    [*] --> Draft
    Draft --> Submitted: User submits
    Submitted --> InReview: Auto-assign reviewer
    InReview --> Approved: Reviewer approves
    InReview --> Rejected: Reviewer rejects
    Rejected --> Draft: User revises
    Approved --> Published: Admin publishes
    Published --> [*]
```

### Data Flow

```
flowchart LR
    Input[User Input] --> Validate[Validation]
    Validate --> Process[Business Logic]
    Process --> Store[Database]
    Process --> Notify[Notification Service]
    Store --> Response[API Response]
    Response --> Display[UI Update]
```
