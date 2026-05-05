# Business Requirement Document Template

Section skeleton for the BRD half of the deliverable. Every business rule and user story must trace back to a `path:line` reference in the source. Follow this section order exactly.

## Required Section Order

1. Executive Summary
2. Business Context & Stakeholders
3. Functional Business Rules
4. User Stories
5. Edge Cases & Error Handling
6. Non-Functional Requirements
7. Constraints & Assumptions
8. Traceability Matrix
9. Glossary (optional, only if domain terms warrant it)

## Section Templates

### 1. Executive Summary

> **What this service does:** _One paragraph (3–5 sentences). State the core capability, primary user, and business value. No implementation details._
>
> **In scope:** _Bullet list of capabilities covered by the extracted spec._
>
> **Out of scope:** _Bullet list of capabilities the source code does NOT cover but that adjacent services might._

### 2. Business Context & Stakeholders

| Stakeholder      | Role / Interest                                                 |
| ---------------- | --------------------------------------------------------------- |
| _e.g., End user_ | Initiates invoice creation through the public dashboard.        |
| _e.g., Operator_ | Reconciles invoices in the admin console.                       |
| _e.g., Auditor_  | Reviews historical invoice immutability for compliance.         |

Briefly describe the business problem the service solves and the regulatory or organizational constraints that shaped its design (when discoverable from the source — e.g., GDPR-related field deletions, SOC2 audit logging).

### 3. Functional Business Rules

Numbered. Each rule is a single sentence in active voice. Each rule ends with a `Source:` reference.

> **BR-1.** An invoice can only be created when the requesting user has the `billing:write` scope.
> Source: `src/middleware/auth.ts:31`, `src/controllers/InvoiceController.ts:88`
>
> **BR-2.** Invoice totals must be greater than zero; zero or negative totals are rejected with HTTP 422.
> Source: `src/services/InvoiceService.ts:42`
>
> **BR-3.** Once an invoice's `status` reaches `paid`, no field other than `notes` may be modified.
> Source: `src/services/InvoiceService.ts:108`

Group related rules under H3 subheadings if there are more than ~10 (e.g., `### Authorization`, `### Validation`, `### State Transitions`).

### 4. User Stories

Use the standard `As a … I want … so that …` form. Tag each story with the rules it depends on.

> **US-1 — Create invoice (end user)**
> As a finance operator, I want to create a new invoice with a customer, total, and currency, so that the customer can be billed for services rendered.
> _Depends on:_ BR-1, BR-2.
> _Endpoint:_ `POST /v2/billing/invoice`
>
> **US-2 — Mark invoice paid (admin)**
> As an admin, I want to mark an invoice as paid once payment clears, so that the customer's account ledger is updated.
> _Depends on:_ BR-3.
> _Endpoint:_ `PATCH /v2/billing/invoice/{id}/status`

### 5. Edge Cases & Error Handling

For every endpoint, document non-happy-path behavior. Pull this directly from the extraction trace.

| Scenario                                    | Trigger                                | HTTP Code | Response Body                            | Source                                     |
| ------------------------------------------- | -------------------------------------- | --------- | ---------------------------------------- | ------------------------------------------ |
| Missing auth header                         | No `Authorization: Bearer …`           | 401       | `{ "type": "...", "title": "..." }`      | `src/middleware/auth.ts:18`                |
| Invalid currency code                       | `currency` not in ISO 4217 list        | 422       | Validation error envelope                | `src/services/InvoiceService.ts:55`        |
| Concurrent update race                      | Two PATCH calls on same invoice        | 409       | Conflict error                           | `src/services/InvoiceService.ts:130`       |
| Database connection failure                 | Postgres timeout                       | 503       | Generic 503 envelope                     | `src/middleware/error.ts:42`               |

**Flag silent error swallowing.** If the source has a broad `try/catch` that converts errors into 200 responses, call it out explicitly here AND in the Top 3 risks of the assessment.

### 6. Non-Functional Requirements

| Category          | Requirement (extracted or inferred)                                              | Evidence                                              |
| ----------------- | -------------------------------------------------------------------------------- | ----------------------------------------------------- |
| Performance       | _e.g., List endpoint paginates at 20/page max 100._                              | `src/controllers/InvoiceController.ts:64`             |
| Security          | _e.g., All endpoints require Bearer JWT; tokens validated via JWKS endpoint._    | `src/middleware/auth.ts:9`                            |
| Observability     | _e.g., Each request logged with correlation-id header `X-Request-ID`._           | `src/middleware/logging.ts:14`                        |
| Rate limiting     | _e.g., 100 req/min per token, enforced via Redis token bucket._                  | `src/middleware/rate-limit.ts:22`                     |
| Data retention    | _e.g., Invoices retained indefinitely; soft-delete via `deleted_at` timestamp._  | `db/migrations/0042_invoices.sql:12`                  |
| Idempotency       | _e.g., POST accepts `Idempotency-Key` header; replays return cached response._   | `src/middleware/idempotency.ts:28`                    |

Mark inferred requirements with `[ASSUMPTION]` if they are derived from convention rather than explicit code.

### 7. Constraints & Assumptions

- _e.g., Database is single-region Postgres; no multi-master writes assumed._ Source: `db/config.ts:8`
- _e.g., All monetary amounts stored as integer minor units (cents)._ Source: `src/models/Invoice.ts:14`
- `[ASSUMPTION]` _e.g., Currency conversion assumed to happen upstream — no FX logic was found._

### 8. Traceability Matrix

The single most important section for audit. Every business rule maps to a source location AND an OpenAPI operation.

| Rule  | Endpoint                                  | Operation ID    | Source Reference                               |
| ----- | ----------------------------------------- | --------------- | ---------------------------------------------- |
| BR-1  | `POST /v2/billing/invoice`                | createInvoice   | `src/middleware/auth.ts:31`                    |
| BR-2  | `POST /v2/billing/invoice`                | createInvoice   | `src/services/InvoiceService.ts:42`            |
| BR-3  | `PATCH /v2/billing/invoice/{id}`          | updateInvoice   | `src/services/InvoiceService.ts:108`           |
| BR-4  | `GET /v2/billing/invoice`                 | listInvoices    | `src/controllers/InvoiceController.ts:64`      |

### 9. Glossary (optional)

Include only when domain terms are non-obvious or come from regulated domains (healthcare, finance, legal).

| Term            | Definition                                                                  |
| --------------- | --------------------------------------------------------------------------- |
| _e.g., Dunning_ | The process of methodically communicating with customers to collect debts. |

## Style Rules

- **Active voice.** "The system rejects negative totals" — not "Negative totals will be rejected."
- **One claim per rule.** Compound rules ("…and also…") split into two.
- **Quantify when possible.** "Within 200 ms p95" beats "fast."
- **No future tense unless future-scoped.** Document what the code does, not what someone plans to add.
- **Cite or assume.** Every claim is either sourced or `[ASSUMPTION]`-tagged. No bare assertions.
