# Requirement Classification Guide

## Table of Contents

1. [Requirement ID Scheme](#requirement-id-scheme)
2. [Functional Requirements (FR)](#functional-requirements-fr)
3. [Non-Functional Requirements (NFR)](#non-functional-requirements-nfr)
4. [Priority Systems](#priority-systems)
5. [Acceptance Criteria — Gherkin Format](#acceptance-criteria--gherkin-format)
6. [User Story Format](#user-story-format)

---

## Requirement ID Scheme

Every requirement receives a unique, prefixed identifier for traceability across documents.

| Prefix | Category | Example |
|--------|----------|---------|
| `FR-` | Functional Requirement | FR-001, FR-042 |
| `NFR-` | Non-Functional Requirement | NFR-001, NFR-015 |
| `API-` | API Requirement / Endpoint | API-001, API-023 |
| `UX-` | UX Flow / Interaction | UX-001, UX-008 |
| `DATA-` | Data Model / Schema | DATA-001, DATA-012 |
| `SEC-` | Security Requirement | SEC-001, SEC-007 |
| `INFRA-` | Infrastructure Requirement | INFRA-001, INFRA-004 |

### Conventions

- IDs are sequential within each prefix: FR-001, FR-002, FR-003
- IDs are permanent — deleted requirements leave gaps (do not renumber)
- Sub-requirements use dot notation: FR-007.1, FR-007.2
- Cross-references use the full ID: "See FR-003", "Implements NFR-012"

---

## Functional Requirements (FR)

Functional requirements describe what the system must do — features, behaviors, use cases, and business rules.

### Template

```
**FR-[ID]:** [Title]
- **Description:** [What the system does — concrete, specific behavior]
- **Actor:** [Who triggers or interacts with this requirement]
- **Preconditions:** [What must be true before this can execute]
- **Flow:**
  1. [Step 1]
  2. [Step 2]
  3. [Step 3]
- **Postconditions:** [Expected system state after execution]
- **Acceptance Criteria:**
  - Given [context], When [action], Then [outcome]
- **Priority:** [Must / Should / Could / Won't]
- **Dependencies:** [Other requirement IDs this depends on]
- **Traces to:** [HLD section, API endpoint, UX flow]
```

### Example — E-Commerce Cart

```
**FR-014:** Add Item to Shopping Cart
- **Description:** Authenticated users can add a product to their shopping cart from the product detail page. The cart updates in real-time without a full page reload.
- **Actor:** Authenticated User
- **Preconditions:** User is logged in. Product is in stock (inventory > 0).
- **Flow:**
  1. User views product detail page
  2. User selects quantity (default: 1)
  3. User clicks "Add to Cart" button
  4. System validates inventory availability
  5. System adds item to user's cart
  6. Cart icon updates with new item count
  7. Confirmation toast appears for 3 seconds
- **Postconditions:** Item is persisted in the user's cart. Inventory is soft-reserved for 30 minutes.
- **Acceptance Criteria:**
  - Given a product with 5 units in stock, When the user adds 2 to cart, Then the cart shows the item with quantity 2 and the cart badge increments by 2.
  - Given a product with 0 units in stock, When the user views the product page, Then the "Add to Cart" button is disabled and displays "Out of Stock".
- **Priority:** Must
- **Dependencies:** FR-010 (User Authentication), FR-012 (Product Catalog)
- **Traces to:** HLD §4.1 Cart Service, API-008 POST /cart/items, UX Flow §1.3 Shopping Flow
```

---

## Non-Functional Requirements (NFR)

Non-functional requirements describe how the system must perform — quality attributes, constraints, and operational characteristics.

### Categories

| Category | What It Covers | Example Metrics |
|----------|---------------|-----------------|
| **Performance** | Speed, latency, throughput | Response time < 200ms at p95 |
| **Reliability** | Uptime, fault tolerance, recovery | 99.9% availability, < 5min RTO |
| **Security** | Access control, encryption, compliance | OWASP Top 10, SOC 2 compliance |
| **Usability** | Ease of use, accessibility, learnability | WCAG 2.1 AA, < 3 clicks to core action |
| **Maintainability** | Code quality, testability, modularity | 80% test coverage, < 2hr deploy cycle |
| **Scalability** | Growth capacity, resource efficiency | Handle 10x current load, horizontal scaling |

### Template

```
**NFR-[ID]:** [Title]
- **Category:** [Performance | Reliability | Security | Usability | Maintainability | Scalability]
- **Description:** [Measurable quality attribute — specific, not vague]
- **Target:** [Concrete metric or threshold]
- **Measurement:** [How to verify — tool, test, or process]
- **Priority:** [Must / Should / Could / Won't]
- **Traces to:** [HLD section, infrastructure component]
```

### Examples by Category

**Performance:**
```
**NFR-003:** API Response Latency
- **Category:** Performance
- **Description:** All API endpoints return responses within acceptable latency thresholds under normal load.
- **Target:** p50 < 100ms, p95 < 200ms, p99 < 500ms for read endpoints. p95 < 500ms for write endpoints.
- **Measurement:** Application Performance Monitoring (APM) dashboards with percentile tracking. Load test with 1000 concurrent users.
- **Priority:** Must
- **Traces to:** HLD §6.1 Infrastructure, INFRA-002 CDN Configuration
```

**Reliability:**
```
**NFR-007:** System Availability
- **Category:** Reliability
- **Description:** The production system maintains high availability with automated failover.
- **Target:** 99.9% uptime (< 8.76 hours downtime per year). Recovery Time Objective (RTO) < 5 minutes. Recovery Point Objective (RPO) < 1 minute.
- **Measurement:** Uptime monitoring with alerting. Monthly availability reports. Quarterly disaster recovery drills.
- **Priority:** Must
- **Traces to:** HLD §6.2 High Availability, INFRA-005 Failover Configuration
```

**Security:**
```
**NFR-011:** Data Encryption
- **Category:** Security
- **Description:** All sensitive data is encrypted at rest and in transit.
- **Target:** TLS 1.3 for transit. AES-256 for data at rest. PII fields encrypted at application layer.
- **Measurement:** SSL Labs scan (A+ rating). Database encryption audit. Penetration test annually.
- **Priority:** Must
- **Traces to:** HLD §5.1 Security Architecture, SEC-003 Encryption Standards
```

**Usability:**
```
**NFR-015:** Accessibility Compliance
- **Category:** Usability
- **Description:** All user-facing interfaces meet accessibility standards for users with disabilities.
- **Target:** WCAG 2.1 Level AA compliance. All interactive elements keyboard-navigable. Screen reader compatible.
- **Measurement:** Automated accessibility scan (axe-core). Manual screen reader testing. Quarterly accessibility audit.
- **Priority:** Must
- **Traces to:** UX Flow §5.0 Accessibility, FR-045 Keyboard Navigation
```

---

## Priority Systems

### MoSCoW (Recommended Default)

| Priority | Meaning | Guidance |
|----------|---------|----------|
| **Must** | Non-negotiable for this release | System is unusable without it. Failure to deliver = project failure. |
| **Should** | Important but not critical | Significant value. Workaround exists. Include unless time/resource constrained. |
| **Could** | Desirable enhancement | Nice to have. Include if capacity allows. First to be cut. |
| **Won't** | Explicitly excluded from this scope | Acknowledged but deferred. Documented to prevent scope creep. |

### P0-P3 (Alternative)

| Priority | Meaning | Equivalent |
|----------|---------|------------|
| **P0** | Critical / Blocker | Must |
| **P1** | High priority | Must / Should |
| **P2** | Medium priority | Should / Could |
| **P3** | Low priority / Nice to have | Could / Won't |

### Mapping Between Systems

| MoSCoW | P-Level | Typical % of Requirements |
|--------|---------|--------------------------|
| Must | P0-P1 | ~60% |
| Should | P1-P2 | ~20% |
| Could | P2-P3 | ~15% |
| Won't | — | ~5% (documented exclusions) |

---

## Acceptance Criteria — Gherkin Format

Write acceptance criteria using the Given-When-Then pattern for clarity and testability.

### Structure

```
Given [precondition / context]
When [action / trigger]
Then [expected outcome / observable result]
```

### Rules

- Each acceptance criterion tests one specific behavior
- Use concrete values, not vague descriptions ("5 items", not "some items")
- Cover the happy path AND key edge cases
- Each criterion should be independently verifiable

### Examples

**User Authentication:**
```
Given a user with valid credentials,
When they submit the login form,
Then they are redirected to the dashboard and a session token is set.

Given a user with an incorrect password,
When they submit the login form,
Then an error message "Invalid email or password" is displayed and no session is created.

Given a user who has failed login 5 times in 10 minutes,
When they attempt a 6th login,
Then the account is temporarily locked for 15 minutes and a lockout notification email is sent.
```

**Search with Pagination:**
```
Given a search query returning 150 results with page size 20,
When the user loads the first page,
Then results 1-20 are displayed with a pagination control showing 8 pages.

Given the user is on page 3 of search results,
When they apply a new filter,
Then results reset to page 1 with the filter applied.
```

**File Upload:**
```
Given a user on the upload page,
When they select a PDF file under 10MB,
Then the file uploads successfully and a confirmation with the file name is displayed.

Given a user attempting to upload a file larger than 10MB,
When they select the file,
Then the upload is rejected before transfer begins with the message "File size exceeds the 10MB limit."
```

---

## User Story Format

For Agile teams, requirements can also be expressed as user stories that map to formal FR entries.

### Template

```
As a [role/persona],
I want [goal/capability],
So that [benefit/value].
```

### Rules

- The role should be a specific persona, not "user" (e.g., "store manager", "first-time visitor")
- The goal should be a concrete action, not a feature name
- The benefit should explain business or user value, not restate the goal
- Each story maps to one or more FR entries

### Example

```
As a hiring manager,
I want to filter candidate applications by years of experience and skill tags,
So that I can quickly shortlist qualified candidates without reviewing every application.

→ Maps to: FR-023 (Candidate Filtering), FR-024 (Skill Tag Search)
```
