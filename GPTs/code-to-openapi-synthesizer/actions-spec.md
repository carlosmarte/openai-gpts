# Actions Specification — Code to OpenAPI Synthesizer

## v1: No Live Actions

The v1 release of this Custom GPT operates entirely on user-pasted code or files uploaded to Code Interpreter. No external HTTP actions are wired up.

**Rationale:**

1. The research source explicitly notes that Custom GPTs are **architecturally unsuited** for automated, repo-scale documentation pipelines (no CI/CD hooks, manual uploads break version-control freshness, model versions drift silently). Wiring custom actions to internal repos would inherit those limitations without solving them.
2. The most valuable external integration — Model Context Protocol (MCP) servers exposing live repository `search`/`fetch` tools — is **not invocable from Custom GPT actions**. MCP integration belongs in the Responses API surface, not here.
3. Code Interpreter already covers archive uploads, AST parsing, and YAML output without an external dependency.

## Forward-Looking Optional Action: OpenAPI Validator

If a future iteration wants to add server-side validation, this is the minimum viable shape. Treat as a design sketch, not a deployed contract.

### Overview

- **Purpose:** Validate the GPT's emitted OpenAPI 3.1 YAML against the official schema before delivering it to the user, surfacing structural errors the model can self-correct against.
- **Authentication:** API Key (header: `X-API-Key`)
- **Privacy Policy URL:** Required if this GPT is published publicly with the action enabled. The validator must not log or persist submitted YAML beyond request lifecycle.

### Endpoint

#### `POST /validate`

- **Method:** POST
- **URL:** `https://<your-validator-host>/v1/validate`
- **Description:** Submits an OpenAPI document and returns a list of validation errors plus a normalized canonical form.
- **Parameters:**

| Name      | Type   | Required | Description                                       |
| --------- | ------ | -------- | ------------------------------------------------- |
| `format`  | string | yes      | `yaml` or `json`                                  |
| `version` | string | yes      | `3.1.0` (only 3.1 supported in v1)                |
| `strict`  | bool   | no       | Reject documents with warnings (default `false`)  |

- **Request Body:**

```json
{
  "format": "yaml",
  "version": "3.1.0",
  "strict": true,
  "document": "<raw OpenAPI YAML string>"
}
```

- **Response (200):**

```json
{
  "valid": true,
  "errors": [],
  "warnings": [
    { "path": "paths./v2/billing.post.responses.422", "message": "missing description field" }
  ],
  "canonical": "<normalized YAML>"
}
```

- **Response (422 — validation failure):**

```json
{
  "valid": false,
  "errors": [
    { "path": "components.schemas.Invoice.required", "message": "must be array of strings" }
  ],
  "warnings": [],
  "canonical": null
}
```

- **Error Handling:** On 5xx or network errors, the GPT degrades gracefully: emits the OpenAPI spec without the validator pass and notes "validation skipped" under Top 3 risks.

### OpenAPI Schema (forward-looking, not yet deployed)

```yaml
openapi: 3.1.0
info:
  title: OpenAPI Validator (forward-looking)
  version: 0.0.1-draft
servers:
  - url: https://<your-validator-host>/v1
paths:
  /validate:
    post:
      operationId: validateOpenApi
      summary: Validate an OpenAPI 3.1 document
      security:
        - apiKey: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ValidateRequest'
      responses:
        '200':
          description: Validation result
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ValidateResult'
        '422':
          description: Document is structurally invalid
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ValidateResult'
components:
  securitySchemes:
    apiKey:
      type: apiKey
      in: header
      name: X-API-Key
  schemas:
    ValidateRequest:
      type: object
      required: [format, version, document]
      properties:
        format: { type: string, enum: [yaml, json] }
        version: { type: string, enum: ["3.1.0"] }
        strict: { type: boolean, default: false }
        document: { type: string, description: Raw OpenAPI document text }
    ValidateResult:
      type: object
      required: [valid, errors, warnings]
      properties:
        valid: { type: boolean }
        errors:
          type: array
          items: { $ref: '#/components/schemas/Issue' }
        warnings:
          type: array
          items: { $ref: '#/components/schemas/Issue' }
        canonical:
          type: [string, "null"]
          description: Normalized YAML when valid
    Issue:
      type: object
      required: [path, message]
      properties:
        path: { type: string, description: JSON-pointer-style path }
        message: { type: string }
```

## Wiring Status

| Aspect              | Status   |
| ------------------- | -------- |
| v1 actions enabled  | **No**   |
| Validator deployed  | No       |
| Privacy policy URL  | N/A      |
| OAuth / API key set | N/A      |

When (or if) the validator is deployed, flip `Actions enabled` in the GPT Builder, paste the schema above, and add the `X-API-Key` credential.
