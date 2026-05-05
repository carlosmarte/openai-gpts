# Extraction Methodology

Authoritative protocol for tracing source code into a synchronized OpenAPI 3.1 specification and Business Requirement Document. Read this file first when handed a new repository, archive, or paste.

## 1. Tracing Order (canonical)

Always follow this chain. Skipping a layer produces an underspecified contract.

1. **Inventory** — language, framework, build tool, test framework, project layout. Output 2–3 lines.
2. **Routing layer** — every URL→handler binding. Sources: Express `app.METHOD()` / `router.METHOD()`, Fastify `fastify.METHOD()`, Spring `@RequestMapping`/`@GetMapping`, FastAPI `@app.METHOD()`/`APIRouter`, Flask `@app.route`, Django `urls.py`, Rails `config/routes.rb`, ASP.NET `[HttpGet]`/`[Route]`.
3. **Controller / handler** — function signatures, parameter binding, decorators, middleware references.
4. **Service / business logic** — what computation, validation, and side effects occur. Note guard clauses, authorization checks, idempotency keys.
5. **Data access / persistence** — ORM models, repository methods, raw SQL, external API calls.
6. **Response shape** — status codes, response bodies, headers, error envelopes.
7. **Cross-cutting concerns** — auth middleware, telemetry, rate limiting, validation pipelines, error handlers.

Cite every claim using `path:line` (e.g., `src/routes/billing.ts:42`). Build the trace chain explicitly: `routes/x.ts:42 → controllers/Y.ts:88 → services/Z.ts:31`.

## 2. Why Code Interpreter, Not Vector Retrieval

Vector-chunked File Search shatters the abstract syntax tree (AST). A route in one file, the controller in another, and the schema in a third frequently end up in unrelated chunks, and the cross-references vanish in embedding space.

**Use Code Interpreter for:**

- AST traversal of Python (`ast` module) — extract every `def`, decorator, return type, raised exception.
- Regex sweeps for routing idioms in TypeScript/Java/C#/Ruby/Go (e.g., `rg "@(Get|Post|Put|Delete|Patch)Mapping"`).
- YAML/JSON parsing for build configs, OpenAPI fragments, manifest files (`pyyaml`, `json`).
- Iterative correction — if a parser misses, read the error, rewrite, retry.

**Recipes:**

```python
# Python: every route handler in a FastAPI/Flask file
import ast, pathlib
src = pathlib.Path("app.py").read_text()
tree = ast.parse(src)
for node in ast.walk(tree):
    if isinstance(node, ast.FunctionDef):
        for d in node.decorator_list:
            # capture @app.get("/path"), @router.post("/x"), @app.route("/y")
            ...
```

```python
# TS/JS: ripgrep-style sweep
import re, pathlib
pat = re.compile(r"(app|router|fastify)\.(get|post|put|delete|patch)\(['\"]([^'\"]+)['\"]")
for p in pathlib.Path("src").rglob("*.ts"):
    for i, line in enumerate(p.read_text().splitlines(), 1):
        for m in pat.finditer(line):
            print(f"{p}:{i} {m.group(2).upper()} {m.group(3)}")
```

## 3. Prompt-Caching Discipline

When the GPT is invoked repeatedly against the same codebase, ordering matters. Static repository context belongs at the **front** of the prompt; the dynamic user query at the **end**. This maximizes prompt-cache hits, drops input cost, and accelerates time-to-first-byte.

For Custom GPT users this manifests as: paste the project tree / package.json / framework manifest first, then ask the specific extraction question. Preserve the structural preamble across follow-ups.

## 4. Bias-to-Action Heuristics

- Default to drafting output. Mark inferences with `[ASSUMPTION]` rather than asking.
- Ask only when blocked: missing file contents, ambiguous framework, or a request that exceeds output budget without scoping.
- When you must ask, ask exactly one focused question, not a list.
- Read enough context to understand a controller before moving on. Avoid micro-thrashing (read 5 lines, jump, read 5 more).
- Batch file reads. In Code Interpreter, glob and read multiple files in one execution.

## 5. Edge-Case Extraction (mandatory)

For every endpoint, document:

- **Input validation** — what shape, what required fields, what type coercion.
- **Authorization** — auth scheme, required scopes/roles, anonymous access boundary.
- **Error branches** — explicit `throw`, `raise`, `return ResponseEntity.status(...)`, error middleware delegation.
- **Status codes** — every observed code and its trigger.
- **Side effects** — DB writes, queue publishes, external API calls, cache invalidations.
- **Idempotency** — keys, retry semantics, optimistic concurrency.

If a code path swallows errors with a broad `try/except` or `catch(e)` that returns 200, **flag it explicitly** in the BRD's Edge Cases section and Top 3 Risks.

## 6. Output Token Discipline

A complete BRD + OpenAPI spec for a mid-sized service can exceed model output limits. When the doc trends long:

- Split per-tag (one OpenAPI fragment per business domain) and stitch later.
- Or split per-resource (one fragment per `paths.*` entry) and stitch later.
- Always finish a fragment cleanly — never truncate mid-YAML.
- When splitting, surface this in Part 3 (Top 3 risks) so the user knows reassembly is required.

## 7. MCP Forward-Looking Note (for users graduating to API pipelines)

Custom GPTs cannot host live Model Context Protocol servers. For automated repo-scale documentation pipelines that stay synchronized with version control, users should re-implement against the OpenAI Responses API with an MCP server exposing `search` and `fetch` tools backed by their VCS or a read-only mirror. The methodology in this file translates directly — only the ingestion mechanism changes.

If a user expresses interest in automation, point them to this section and recommend they keep the BRD/OpenAPI templates and rubrics as their canonical artifact contract.
