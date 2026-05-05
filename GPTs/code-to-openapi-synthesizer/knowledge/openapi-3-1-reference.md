# OpenAPI 3.1 Reference

Compact, pragmatic reference for emitting OpenAPI 3.1.0 documents. Curated for high recall during synthesis — not a substitute for the official spec when in doubt.

## 1. Required Top-Level Structure

```yaml
openapi: 3.1.0       # required, exact string
info:                # required
  title: <string>
  version: <string>
  description: <string>          # optional but recommended
  summary: <string>              # 3.1 only — short description
  contact: { name, url, email }  # optional
  license: { name, identifier }  # 3.1: SPDX identifier preferred over url
servers:             # optional but include for non-trivial APIs
  - url: <string>
    description: <string>
    variables: { ... }
paths: { ... }       # required (or webhooks, or components)
webhooks: { ... }    # 3.1 only — incoming-webhook contracts
components: { ... }  # optional — reusable schemas, parameters, responses, etc.
security: [ ... ]    # default security requirements
tags: [ { name, description } ]
externalDocs: { url, description }
```

## 2. Paths & Operations

```yaml
paths:
  /v2/billing/invoice:
    summary: Invoice resource
    description: ...
    get:
      operationId: listInvoices       # required for code-gen friendliness
      summary: List invoices
      tags: [billing]
      parameters:
        - name: limit
          in: query
          required: false
          schema: { type: integer, minimum: 1, maximum: 100, default: 20 }
      responses:
        '200':
          description: OK
          content:
            application/json:
              schema:
                type: array
                items: { $ref: '#/components/schemas/Invoice' }
    post:
      operationId: createInvoice
      summary: Create invoice
      tags: [billing]
      requestBody:
        required: true
        content:
          application/json:
            schema: { $ref: '#/components/schemas/InvoiceCreateRequest' }
      responses:
        '201':
          description: Created
          headers:
            Location:
              schema: { type: string, format: uri }
          content:
            application/json:
              schema: { $ref: '#/components/schemas/Invoice' }
        '422': { $ref: '#/components/responses/ValidationError' }
        '401': { $ref: '#/components/responses/Unauthorized' }
```

**Operation field order (recommended for readability):** `operationId, summary, description, tags, parameters, requestBody, responses, security, deprecated`.

## 3. Parameter Locations

| `in`     | Use for                                  |
| -------- | ---------------------------------------- |
| `path`   | URL template segments. **Always required.** |
| `query`  | `?key=value` filters, paginators         |
| `header` | Custom headers (avoid for `Authorization` — use security schemes) |
| `cookie` | Cookie-based session tokens              |

Path parameters must be declared in both the URL template (`/users/{id}`) and the `parameters` array.

## 4. Components

```yaml
components:
  schemas:
    Invoice:
      type: object
      required: [id, total, currency, status]
      properties:
        id: { type: string, format: uuid }
        total: { type: number, minimum: 0 }
        currency: { type: string, example: USD }
        status:
          type: string
          enum: [draft, sent, paid, void]
        notes:
          type: [string, "null"]   # 3.1 idiom — replaces `nullable: true`
      example:
        id: "8f1c..."
        total: 199.00
        currency: USD
        status: draft
  responses:
    ValidationError:
      description: Request failed validation
      content:
        application/json:
          schema: { $ref: '#/components/schemas/ErrorEnvelope' }
    Unauthorized:
      description: Missing or invalid credentials
      content:
        application/json:
          schema: { $ref: '#/components/schemas/ErrorEnvelope' }
  parameters:
    PageSize:
      name: limit
      in: query
      schema: { type: integer, minimum: 1, maximum: 100, default: 20 }
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
    apiKeyAuth:
      type: apiKey
      in: header
      name: X-API-Key
    oauth2:
      type: oauth2
      flows:
        authorizationCode:
          authorizationUrl: https://example.com/oauth/authorize
          tokenUrl: https://example.com/oauth/token
          scopes:
            read: Read access
            write: Write access
```

## 5. Key 3.1-vs-3.0 Deltas

| Topic | 3.0 | 3.1 |
|-------|-----|-----|
| JSON Schema dialect | Subset of draft-05 | Full **JSON Schema 2020-12** |
| Nullable | `nullable: true` | `type: [string, "null"]` |
| Examples | `example` only | `example` + `examples: [...]` (multiple) |
| Webhooks | Not supported | First-class `webhooks` top-level |
| License URL | `license.url` | `license.identifier` (SPDX) preferred |
| `info.summary` | Absent | Available |
| `paths` requirement | Required | Optional if `webhooks` or `components` present |
| Path-item refs | Refs only at component level | `$ref` allowed inline in `paths` |

**Always emit 3.1.0** unless the user explicitly asks for 3.0.x.

## 6. Common Idioms

**Nullable field:**

```yaml
notes:
  type: [string, "null"]
  description: Optional internal notes
```

**Polymorphic union (oneOf + discriminator):**

```yaml
PaymentMethod:
  oneOf:
    - $ref: '#/components/schemas/CardPayment'
    - $ref: '#/components/schemas/BankTransfer'
  discriminator:
    propertyName: kind
    mapping:
      card: '#/components/schemas/CardPayment'
      bank: '#/components/schemas/BankTransfer'
```

**Pagination response envelope:**

```yaml
PaginatedInvoiceList:
  type: object
  required: [data, page]
  properties:
    data:
      type: array
      items: { $ref: '#/components/schemas/Invoice' }
    page:
      type: object
      required: [limit, offset, total]
      properties:
        limit: { type: integer }
        offset: { type: integer }
        total: { type: integer }
```

**Error envelope (RFC 7807-style):**

```yaml
ErrorEnvelope:
  type: object
  required: [type, title, status]
  properties:
    type: { type: string, format: uri }
    title: { type: string }
    status: { type: integer }
    detail: { type: string }
    errors:
      type: array
      items:
        type: object
        properties:
          field: { type: string }
          message: { type: string }
```

## 7. Validation Self-Checks

Before emitting, verify:

- `openapi: 3.1.0` is present and exact.
- `info.title` and `info.version` are non-empty.
- Every `$ref` resolves to a defined component.
- Every path parameter in the URL template appears in `parameters` with `required: true`.
- Every operation has at least one response.
- Every `requestBody` and response `content` has at least one media type.
- `enum` arrays match the declared `type`.
- No `nullable: true` (3.0 idiom — replace with `type: [..., "null"]`).
- `operationId` values are unique across the document.

## 8. Common Mistakes

- Using `swagger: "2.0"` instead of `openapi: 3.1.0`.
- Defining schemas inline when they're reused — promote to `components.schemas` and `$ref`.
- Forgetting `requestBody.required: true` (defaults to `false`).
- Mixing `application/json` with form/multipart without declaring both under `content`.
- Declaring auth in `parameters: header` instead of `security` + `securitySchemes`.
- Path params not URL-template-bracketed: use `/users/{id}`, not `/users/:id`.
