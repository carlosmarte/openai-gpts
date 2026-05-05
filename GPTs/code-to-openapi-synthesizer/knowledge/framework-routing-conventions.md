# Framework Routing Conventions

Pattern dictionary for fingerprinting a repository and locating its API surface. For each framework: detection signals, routing idiom, parameter binding, response shape, and where error handling typically lives.

## Express.js (Node.js)

**Detection:** `package.json` lists `"express"`. Files import `from 'express'` or `require('express')`. Common path: `src/routes/*.ts`, `src/app.ts`.

**Routing idiom:**

```ts
import { Router } from 'express';
const router = Router();
router.get('/v2/billing/invoice', authMiddleware, listInvoices);
router.post('/v2/billing/invoice', authMiddleware, validate(InvoiceCreate), createInvoice);
```

**Parameter binding:** `req.params.id`, `req.query.limit`, `req.body`, `req.headers['x-api-key']`. Path params declared as `/users/:id`.

**Response shape:** `res.status(201).json(...)`, `res.send(...)`, `res.set(...)`.

**Error handling:** Express middleware with signature `(err, req, res, next) => {}`, registered last. Often delegated to a single handler in `src/middleware/error.ts`.

**Search anchors:** `rg "router\.(get|post|put|delete|patch|use)"`, `rg "app\.(get|post|put|delete|patch|use)"`.

## Fastify (Node.js)

**Detection:** `package.json` lists `"fastify"`. Imports `from 'fastify'`.

**Routing idiom:**

```ts
fastify.get('/invoices', { schema: listInvoicesSchema, preHandler: auth }, listInvoices);
fastify.post('/invoices', { schema: createInvoiceSchema }, createInvoice);
```

**Parameter binding:** `request.params`, `request.query`, `request.body`, `request.headers`. JSON Schema declared inline via `schema:` — **harvest these directly into OpenAPI components**, they often map 1:1.

**Response shape:** `reply.code(201).send(...)`. Plugins like `@fastify/swagger` may already produce an OpenAPI doc — if found, treat as authoritative ground truth.

**Search anchors:** `rg "fastify\.(get|post|put|delete|patch|route)"`, `rg "@fastify/swagger"`.

## Spring Boot (Java / Kotlin)

**Detection:** `pom.xml`/`build.gradle` lists `spring-boot-starter-web`. Files annotated with `@RestController` or `@Controller`.

**Routing idiom:**

```java
@RestController
@RequestMapping("/v2/billing")
public class InvoiceController {
    @GetMapping("/invoice/{id}")
    public ResponseEntity<Invoice> get(@PathVariable UUID id) { ... }

    @PostMapping("/invoice")
    public ResponseEntity<Invoice> create(@Valid @RequestBody InvoiceCreate req) { ... }
}
```

**Parameter binding:** `@PathVariable`, `@RequestParam`, `@RequestBody`, `@RequestHeader`, `@CookieValue`.

**Response shape:** `ResponseEntity.status(HttpStatus.CREATED).body(invoice)`. Status codes also declared via `@ResponseStatus`.

**Error handling:** `@ControllerAdvice` + `@ExceptionHandler`. Look in `*ExceptionHandler.java` for the global error envelope.

**Validation:** `@Valid` on the body triggers Bean Validation; constraints (`@NotNull`, `@Size`, `@Email`) live on the DTO class fields and translate directly to OpenAPI `required`/`minLength`/`format`.

**Search anchors:** `rg "@(Get|Post|Put|Delete|Patch)Mapping|@RequestMapping|@RestController"`.

## FastAPI (Python)

**Detection:** `pyproject.toml`/`requirements.txt` lists `fastapi`. Files import `from fastapi import ...`.

**Routing idiom:**

```python
from fastapi import APIRouter, Depends
router = APIRouter(prefix="/v2/billing", tags=["billing"])

@router.get("/invoice/{id}", response_model=Invoice)
def get_invoice(id: UUID, user=Depends(current_user)): ...

@router.post("/invoice", response_model=Invoice, status_code=201)
def create_invoice(req: InvoiceCreateRequest, user=Depends(current_user)): ...
```

**Parameter binding:** Path params via function arg name matching `{id}`. Query params via type hints (`limit: int = 20`). Body via Pydantic model arg. Headers via `Header()`. Cookies via `Cookie()`.

**Response shape:** Return value serialized via `response_model`. Status code via `status_code=` decorator arg or `Response(status_code=...)`.

**Error handling:** `raise HTTPException(status_code=422, detail=...)`. Custom handlers via `@app.exception_handler(...)`.

**Bonus:** FastAPI auto-generates `/openapi.json`. If the repo has a deployed instance, fetching that spec is a goldmine — but it may diverge from current code. Cross-validate against source.

**Search anchors:** `rg "@(app|router)\.(get|post|put|delete|patch)"`, `rg "APIRouter\("`.

## Flask (Python)

**Detection:** `requirements.txt` lists `flask`. `from flask import Flask, request, jsonify`.

**Routing idiom:**

```python
@app.route("/v2/billing/invoice", methods=["POST"])
def create_invoice():
    data = request.get_json()
    ...
    return jsonify(invoice), 201
```

**Parameter binding:** `request.args` (query), `request.get_json()` (body), `request.headers`, `request.cookies`. Path params via `@app.route("/users/<int:id>")` and function args.

**Response shape:** `jsonify(...)` or tuple `(body, status, headers)`. Often wrapped via Flask-RESTful or Flask-Smorest — both worth checking; the latter generates OpenAPI directly.

**Error handling:** `@app.errorhandler(SomeException)`, `abort(422, description=...)`.

**Search anchors:** `rg "@app\.route|@.*\.route|@bp\.route"`.

## Django (Python)

**Detection:** `manage.py` exists. `settings.py` includes `'django'`. URL patterns in `*/urls.py`.

**Routing idiom:**

```python
# urls.py
urlpatterns = [
    path("v2/billing/invoice/", views.invoice_collection),
    path("v2/billing/invoice/<uuid:id>/", views.invoice_detail),
]

# views.py — function-based
def invoice_detail(request, id): ...

# views.py — class-based / DRF
class InvoiceViewSet(viewsets.ModelViewSet):
    queryset = Invoice.objects.all()
    serializer_class = InvoiceSerializer
```

**Django REST Framework** is the dominant API toolkit. Routing also flows through `DefaultRouter().register(...)`. Serializers (`*Serializer`) define request/response schemas — harvest directly.

**Search anchors:** `rg "path\(|re_path\(|router\.register\("`.

## Ruby on Rails

**Detection:** `Gemfile` lists `rails`. Routes in `config/routes.rb`.

**Routing idiom:**

```ruby
# config/routes.rb
Rails.application.routes.draw do
  namespace :v2 do
    resources :invoices, only: [:index, :show, :create, :update, :destroy]
  end
end
```

**Controllers:** `app/controllers/v2/invoices_controller.rb` with action methods (`index`, `show`, `create`, etc.).

**Parameter binding:** `params[:id]`, `params[:limit]`, `params.require(:invoice).permit(:total, :currency)`.

**Response shape:** `render json: invoice, status: :created`.

**Search anchors:** Read `config/routes.rb` first — it's the topology map. Then map each `resources :x` to the corresponding controller's standard CRUD actions.

## ASP.NET Core (C#)

**Detection:** `*.csproj` references `Microsoft.AspNetCore.*`. Controllers inherit `ControllerBase`.

**Routing idiom:**

```csharp
[ApiController]
[Route("v2/billing/[controller]")]
public class InvoiceController : ControllerBase
{
    [HttpGet("{id:guid}")]
    public ActionResult<Invoice> Get(Guid id) { ... }

    [HttpPost]
    public ActionResult<Invoice> Create([FromBody] InvoiceCreateRequest req) { ... }
}
```

**Parameter binding:** `[FromRoute]`, `[FromQuery]`, `[FromBody]`, `[FromHeader]`. Often inferred when the type is unambiguous.

**Response shape:** `Ok(...)`, `Created(uri, body)`, `BadRequest(...)`, `NotFound()`, `StatusCode(422, body)`.

**Error handling:** Middleware in `Program.cs` (`app.UseExceptionHandler(...)`) or global `IExceptionFilter`.

**Search anchors:** `rg "\[Http(Get|Post|Put|Delete|Patch)\]|\[Route\(|\[ApiController\]"`.

## Generic Detection Heuristics

If no manifest is provided, fingerprint by:

1. File extensions (`.ts/.js`, `.py`, `.java/.kt`, `.cs`, `.rb`, `.go`, `.rs`).
2. Imports/usings/packages of known framework names.
3. Decorator/annotation prefixes (`@`, `[Attribute]`, `func.HandleFunc`).
4. Project files (`package.json`, `pyproject.toml`, `pom.xml`, `Gemfile`, `*.csproj`, `go.mod`, `Cargo.toml`).

Surface unknown framework signals as `[ASSUMPTION] framework appears to be X based on Y` and proceed.
