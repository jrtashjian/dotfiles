Treat every unqualified rule as `MUST`; treat `Prefer` / `SHOULD` as a strong default; treat `Do not` / `Avoid` / `Never` as `MUST NOT` unless the user explicitly overrides it with justification for a specific case.

## Primary Directive

When uncertain or facing trade-offs, choose the option that:
1. Makes the **domain model clearer** and more precise using the ubiquitous language of its bounded context.
2. **Lowers long-term complexity**, technical debt, and defect probability.
3. Improves **readability**, **local reasoning**, and maintainability for the next human reader.
4. **Preserves or strengthens architectural boundaries** (inward-pointing dependencies; framework, persistence, and delivery independence).
5. Increases **production resilience** through explicit failure handling, isolation, observability, graceful degradation, timeouts, and back pressure.
6. Makes **data ownership, consistency semantics, idempotency, ordering scope, and schema evolution** explicit rather than implicit or accidental.

Write code primarily for humans. Keep it simple, direct, explicit, and at one level of abstraction. Optimize for correctness, clarity, and evolvability over cleverness, minimal keystrokes, or short-term convenience. Apply the Boy Scout Rule on every touch: leave touched code cleaner than you found it.

Never preserve bad structure just because it already exists. Remove duplication aggressively. Prefer explicit intent over implicit magic or surprising behavior.

## Code Quality Rules

### Naming
- Use **intention-revealing names** drawn from the **ubiquitous language** of the current bounded context. Names must explain purpose, role, or behavior without requiring extra comments.
- Avoid misleading, overloaded, visually confusable, cute, funny, cryptic, or private-joke names. Avoid abbreviations (unless established domain or platform standards), type prefixes, Hungarian notation, and implementation hints.
- Make distinctions meaningful. Do not create names that differ only cosmetically. Use one word per concept across the codebase; do not reuse synonyms for the same operation or concept.
- Use pronounceable, searchable names. Add context through modules, namespaces, or types when that is cleaner than longer names.
- Class, type, module, and package names should be nouns or noun phrases (e.g., `Order`, `PricingPolicy`, `Itinerary`, `CustomerId`).
- Function, method, and operation names should be verbs or verb phrases (e.g., `changeDestination`, `allocateInventory`, `applyDiscount`).
- Use problem-domain names for domain concepts and solution-domain names for technical concepts.
- Wrap primitives that carry meaning, validation, units, ranges, or rules in **Value Objects** (e.g., `Money`, `EmailAddress`, `Percentage`, `DateRange`, `TrackingNumber`). Validation and behavior belong with the concept.

### Functions, Methods, and Routines
- Keep functions **small**. Each function must do **one thing** and have **one clear reason to change**.
- Keep each function at **one level of abstraction**. Organize code top-down so readers see the high-level story before details.
- Minimize the number of parameters. Avoid boolean flag parameters (split behavior into separate functions instead). Avoid output parameters unless language conventions make them necessary.
- **Separate commands from queries**: a function that answers a question must not also mutate state.
- Eliminate hidden side effects. Make all side effects visible and intentional.
- Prefer straightforward control flow over clever or deeply nested logic. Use guard clauses to keep the happy path prominent and visible.
- Refactor deep nesting and excessive conditionals into clearer structures (extracted methods, polymorphism, named specifications/policies, or table-driven approaches where the mapping is stable).
- A reader should be able to understand the function with minimal jumping across files.

### Comments
- **Do not use comments to compensate for bad naming or bad structure.** Improve the code first, then decide whether a comment is still needed.
- Prefer self-explanatory code. Use comments only when they add information the code cannot express well:
  - Legal or licensing requirements
  - Non-obvious intent
  - Important warnings, constraints, or invariants
  - Rationale for a surprising decision
  - Clarification of external behavior or protocol assumptions
- Remove redundant, obsolete, obvious, noisy, and misleading comments immediately.
- Do not narrate the code line by line. Keep comments precise and maintain them when code changes.
- Avoid TODO comments unless they are actionable, specific, and necessary.
- Test names and data should reveal the behavior under test. Build small testing vocabularies or helper DSLs only when repeated setup hides intent; keep test code clean.

### Formatting, Structure, and Layout
- Use **consistent formatting** across the repository to reveal structure and intent.
- Keep related concepts close together. Keep files, classes, modules, and functions reasonably small.
- Use vertical ordering to tell the story from higher level to lower level.
- Use indentation to clarify scope, not to hide complexity.
- Avoid excessive line length that hurts readability. Avoid decorative alignment that becomes brittle during edits.
- Preserve a layout that supports fast scanning and local reasoning.

### Error Handling and Defensive Programming
- Design error handling deliberately. Keep the happy path easy to read.
- Provide enough context in error messages for diagnosis (what failed, relevant identifiers, why it matters).
- Use error types, exception classes, or explicit result types (according to project language norms) that support caller decisions. Prefer these over ad-hoc error codes.
- **Do not return or pass `null`** (or equivalent absence sentinels) when a safer model exists (e.g., explicit optionality, `Result`/`Either` types, empty collections, or special-case objects). Do not pass invalid states unless the API explicitly models that case.
- Validate inputs at trust boundaries. Use assertions or invariant checks where programmer assumptions matter.
- Distinguish recoverable conditions from programming errors. Fail in a way that preserves diagnosability. Do not silently continue from corrupted or impossible state.
- **Production stability requirements** (apply to all remote/outbound dependencies):
  - Every outbound/remote call **MUST** have an explicit timeout (chosen intentionally, not left to library defaults).
  - Retries **MUST** be disciplined: only where repeated attempts are safe and the operation is idempotent or guarded; bound retry count and total retry time; add jitter and exponential backoff to avoid synchronized storms; never retry validation errors or permanent failures.
  - Protect unstable dependencies with circuit breakers or fast-fail mechanisms when appropriate. Surface fallback or degraded mode explicitly.
  - Use bulkheads and resource isolation (separate pools for threads, connections, workers) so one failing integration does not consume capacity needed for core work.
  - Implement back pressure, load shedding, and graceful degradation: reject, defer, queue, or shed low-value work under overload to preserve core service. Unbounded acceptance of work is forbidden.
  - Queues are bounded buffers. Monitor length, age, throughput, and failure rate. Define explicit dead-letter or poison-message handling.

### Objects, Modules, Data Structures, and Classes
- **Separate behavior-rich objects from plain data carriers** intentionally. Domain objects (entities, aggregates, value objects, policies, specifications) contain business behavior and protect invariants. DTOs, request/response models, persistence records, and view models are simple carriers used at boundaries with explicit mapping.
- Hide implementation details behind clear interfaces. Expose behavior, not representation. Avoid train-wreck call chains and unnecessary internal knowledge.
- Keep classes and modules small with high cohesion and one primary responsibility (SRP). Split classes that accumulate unrelated behavior. Organize so likely changes remain local.
- Favor composition over complex inheritance unless inheritance is clearly the simpler and more stable model.
- Keep constructors and setup logic from overwhelming domain behavior. Move complex construction policy to factories or the composition root.
- Respect loose coupling and local boundaries. Public APIs should be small, obvious, and hard to misuse.

## Architectural Rules

### The Dependency Rule (Non-Negotiable)
Source code dependencies must point **inward**, toward higher-level policies.
- Inner layers (Domain and Application) **MUST NOT** import or depend on outer layers (frameworks, web handlers, UI libraries, database drivers, external services, messaging, queues, etc.).
- Business rules and domain logic must remain independent of delivery mechanisms, persistence technology, and frameworks.
- Outer layers implement interfaces/ports defined and owned by inner layers.

### Layered Architecture with Explicit Boundaries
Organize around **use cases, bounded contexts, and domain capabilities** while respecting layers. The architecture should scream the domain and application intent.

- **Domain Layer** (highest policy): Contains entities, value objects, aggregates, domain services, specifications/policies, and domain events.
  - Rich behavior and invariant protection where complexity exists.
  - Framework-free, persistence-ignorant, delivery-agnostic.
  - Uses the ubiquitous language of its bounded context.
  - **MUST NOT** perform I/O, read configuration or environment variables directly, or depend on outer details.

- **Application Layer**: Contains use cases and application services that orchestrate domain objects and required gateways/ports.
  - Coordinates one application action or workflow.
  - Owns input models (requests), output models or boundaries (responses), and transaction boundaries.
  - **MUST NOT** contain core business rules or invariants (those belong in the domain layer) or presentation/delivery concerns.

- **Interface Adapters Layer**: Contains controllers, presenters, view models, gateway adapters (repository implementations, external service clients), and mappers between external and internal models.
  - Translates between external formats and internal models.
  - Depends inward on application and domain code.
  - Isolates framework and vendor details.

- **Infrastructure Layer** (outermost): Contains framework bootstrap, object graph wiring and composition root, database access details, messaging clients, file systems, network concerns, and operational tooling.
  - Remains replaceable.
  - Implements interfaces owned by inner layers.
  - **MUST NOT** define business rules or dictate domain shapes.

Use feature-oriented packaging (e.g., `billing/`, `inventory/`, `shipping/`) or layer-oriented structure within a context when it clarifies ownership. Avoid generic `services/`, `utils/`, `helpers/`, `common/`, or `shared/` dumping grounds that obscure domain concepts, create sideways coupling, or hide boundary violations.

### Domain-Driven Design Rules
- **Bounded Contexts are mandatory** for every substantial domain area. A model is valid only inside its own bounded context. Concepts from another context must not be imported directly; translation must be explicit.
- Use the **ubiquitous language** exactly as understood by domain experts inside the bounded context. One concept gets one name; one name carries one meaning. Method names, test names, events, commands, and module names must use the same vocabulary. Rename code when domain understanding improves.
- **Entities**: Use when identity, lifecycle, continuity, and "which one" matter. Give entities explicit identity. Protect valid state transitions and invariants through intention-revealing methods on the aggregate root. Avoid public setters and passive record behavior in behavior-rich domains.
- **Value Objects**: Use aggressively wherever a concept is defined by its attributes, carries validation or behavior, or where passing a primitive would hide meaning. Immutable by default. Construction must guarantee validity. Equality is by value, not identity. Replace primitive obsession where units, ranges, codes, measurements, or descriptive wholes matter.
- **Aggregates**: Design as **small consistency boundaries** around invariants that must hold immediately. All modifications that affect aggregate invariants must go through the aggregate root. Internal members must remain encapsulated. Reference other aggregates by identity (not direct object references) unless stronger consistency is truly required. Prefer one aggregate modified per transaction; coordinate across aggregates via eventual consistency, events, policies, or process managers.
- **Repositories**: Exist for aggregate roots. Repository interfaces must be defined by the domain or application layer that uses them. Repositories return domain objects or domain-oriented results. Keep methods focused on aggregate access needs rather than generic table CRUD. Implementations hide query, mapping, and storage details. Do not become universal query utilities.
- **Factories**: Use when creation is complex, has business rules, involves multiple collaborating values, or the act of creation itself has domain meaning. Encode domain creation rules. Treat reconstitution from storage separately from new-object creation. Use constructors directly only when creation is simple, intention-revealing, and does not expose complex invariants.
- **Domain Services**: Use only for domain-significant behavior that does not naturally belong on a single entity or value object and still fits the ubiquitous language. Name in domain terms. Avoid moving behavior out of entities/value objects prematurely or creating god services that own unrelated policies.
- **Domain Events**: Publish for meaningful business facts (past tense). Use to coordinate across aggregates or contexts when immediate consistency is not required. Keep payloads meaningful and local to the model. Include stable identifiers and sufficient metadata for correlation and replay. Version events and support upcasters/translators when meaning evolves.
- **Specifications and Explicit Policies**: Extract repeated, combinable, or named business rules into explicit domain concepts (e.g., `OverbookingPolicy`, `RouteSpecification`, `AllocationRule`). Keep them in domain language and testable independently of persistence.
- **Context Mapping**: Make every integration relationship explicit in code and structure (Anticorruption Layer for legacy/foreign models, Published Language for stable contracts, Customer/Supplier, Open Host Service, etc.). Own translation responsibility. Do not let foreign terms, schemas, or models leak into the local core without explicit mapping. No direct imports of another context's domain classes or shared "common domain" packages that erase boundaries.
- **Distillation**: Invest the richest modeling effort and cleanest design in the **Core Domain** (the part that creates strategic advantage). Keep Supporting and Generic Subdomains simpler unless real complexity exists there. Protect the core from generic mechanisms, infrastructure, and vendor schemas.
- Validate models through concrete **scenario walkthroughs** that exercise real business decisions, object creation, lifecycle transitions, invariant protection, and cross-context translation. Awkward or procedural scenarios signal missing concepts or wrong boundaries.

### Business Logic Placement and Persistence
- Default to a rich **Domain Model** (entities with protected behavior and transitions, value objects, aggregates as consistency boundaries, specifications/policies, and domain events) whenever there is meaningful business complexity, invariants that must be protected immediately, lifecycle concerns, or collaboration between concepts. This is the preferred approach, especially in the core domain.
- Application services (in the Application Layer) orchestrate use cases: they load and persist aggregates through repositories, invoke domain behavior on the aggregates, coordinate side effects (e.g., publishing events), and manage transaction boundaries. Application services must remain thin and must not contain core business rules or invariants.
- Repositories are defined for aggregate roots. Their interfaces live in the domain or application layer so that the domain model stays persistence-ignorant. Implementations (in the adapters or infrastructure layer) use data mappers or equivalent translation to keep persistence details from leaking into the domain.
- In genuinely simple supporting or generic subdomains where rich modeling adds little value and there are few invariants or lifecycle rules, simpler service-oriented or procedural implementations may be acceptable. However, escalate promptly to richer domain modeling (introducing entities, value objects, aggregates, or explicit policies) as soon as duplication, special-case logic, or consistency requirements appear.
- Avoid anemic domain models (entities that are little more than bags of getters/setters with all rules living in services or controllers) in any area that has real business rules or invariants.

### Construction, Wiring, and Boundaries
- Separate constructing the system from using it. Keep object graph assembly, dependency injection, factories with complex policy, and framework bootstrapping in an explicit composition root (infrastructure or bootstrap area).
- Define narrow interfaces/ports around volatile dependencies (persistence gateways, external services, mailers, clocks, ID generators, message publishers, etc.). Inner layers own the abstractions; outer layers implement them.
- When a dependency does not exist yet, define interfaces from local domain and application needs, not from guesses about future implementations.
- Keep cross-cutting concerns from obscuring ordinary code flow. Use standards, frameworks, proxies, or AOP mechanisms only when they add demonstrable value without violating boundaries.

## Production Readiness and Data-Intensive Systems Rules

### Stability, Resilience, and Failure Isolation
- Assume production will be messy: every dependency can be slow, unavailable, or return wrong data; every queue can fill; every cache can miss or stampede; every timeout can cascade; every caller can retry badly; every "temporary" degraded state can persist for hours.
- Every remote/outbound dependency call **MUST** have an explicit timeout.
- Retries must be safe, bounded, jittered, and backoff-equipped. Never retry non-idempotent operations or permanent failures without explicit guards.
- Use circuit breakers or fast-fail to stop flooding unhealthy dependencies and to surface degraded mode explicitly.
- Use bulkheads and resource isolation so one failing component does not starve core capacity.
- Have a deliberate back-pressure, load-shedding, and graceful-degradation strategy: reject, defer, or shed low-value work under overload to preserve core service.
- Queues are bounded buffers with monitoring and explicit poison-message handling. Unbounded acceptance of work is forbidden.
- Make deployment, migration, and operational automation **idempotent and restartable** where practical (partial failure, rerun after error, coexisting versions during rollout).
- Startup must fail fast on missing critical configuration. Health checks must reflect actual ability to serve and real dependency state; they must not mask deadlocks or stuck subsystems.
- Treat all external input as untrusted. Validate syntax, shape, and business plausibility at trust boundaries. Normalize and sanitize once at the right boundary.

### Observability and Operability
- Emit structured logs with correlation identifiers at boundaries, decision points, and failure points. Include enough context to diagnose issues without exhaustive searching.
- Capture metrics for request rate, success/failure counts, latency (distribution and tail), dependency health, timeout/retry/circuit-breaker state, queue depth, saturation signals, and lag for derived data.
- Expose health information that reflects real dependency state and serving capability.
- Make runtime state, version, build, configuration, and dependency status visible for live diagnosis.
- After incidents, identify the failure chain, missing defenses, and detection gaps; feed findings back into design and tests.

### Data Semantics, Idempotency, Ordering, and Evolution
- Be explicit about source of truth, write acknowledgment semantics (when durable vs when visible), read-after-write expectations, staleness tolerance, and conflict detection/resolution model.
- Design handlers of commands, jobs, and events to tolerate retries, duplicates, reordering, and partial failure as normal. Prefer naturally idempotent state transitions or explicit deduplication keys. Never assume exactly-once delivery unless the system boundary truly provides it and the design proves safety.
- Ordering: require only the minimum ordering guarantees the business logic actually needs. Define ordering scope explicitly (per key, per stream/partition, per entity whose history is being updated). Do not assume global or total order.
- Schema and contract evolution: plan for change. Version contracts intentionally. Prefer backward- and forward-compatible changes where possible. Keep old readers and writers in mind during rollout. Distinguish internal refactors from contract changes that affect consumers.
- Events and streams: distinguish commands (requests for action) from events (facts that happened). Consumers must tolerate lag, duplicates, restart, and replay. Derived projections must be rebuildable where feasible. Include stable identifiers and metadata for correlation and versioning.
- Partitioning and locality: colocate data and work by the key that most often drives consistency or aggregation. Make hot-key and skew risk explicit and mitigated.
- Replication and consistency: choose strategy deliberately with explicit trade-offs (synchronous vs asynchronous, conflict model). Preserve stronger guarantees (read-your-writes, monotonic reads, consistent prefix) only where the product or workflow truly requires them and the design delivers them.
- Transactions: use local transactions where they cleanly solve a real consistency problem. Avoid distributed transactions as a default coordination strategy. Make atomicity scope explicit. Choose isolation level deliberately to protect invariants that correctness depends on (protect against lost updates, write skew, and phantoms where needed). Do not accept weaker isolation for correctness-critical invariants without a deliberate alternative design.
- Caching: treat as an optimization, not a source of truth unless explicitly designed that way. Plan for cache misses, stampedes, staleness, and outages. Define behavior when the cache is unavailable. Use request coalescing and appropriate expiry strategies.

### Concurrency, Async, and Background Work
- Do not introduce concurrency unless it provides a real, measured benefit. Get non-concurrent behavior correct first.
- Minimize shared mutable state. Prefer immutability, message passing, or clear ownership boundaries.
- Keep synchronized or locked sections as small as possible. Be explicit about shutdown, cancellation, timeouts, and cleanup.
- Test concurrent, retry, and overload behavior carefully under varied thread counts, schedules, and conditions where it matters.
- For scheduled and background work: spread demand so it does not concentrate at obvious clock boundaries. Use explicit failure/retry/backoff policy. Provide bounded waits, progress visibility, timeout, and cancellation strategy for long-running work.

## Testing Rules
- Treat tests as production-quality code: clean, readable, deterministic, isolated, order-independent, self-checking, and maintainable.
- A test should communicate one main idea. Prefer simple setup and clear assertions. One conceptual assertion per test when that improves clarity.
- Use test names and test data that reveal the business or technical behavior under test.
- **Core and domain tests first**: entities, value objects, aggregates (invariants, valid and invalid state transitions), domain services, specifications/policies, and use cases. These tests **MUST** run without the real framework, database, or network and must be fast and deterministic.
- Adapter and integration tests: mapping correctness, gateway behavior, controller translation, presenter formatting, external service integration, and boundary translation.
- Add or update tests for behavior changes, bug fixes, significant refactors, and to catch the specific failure mode that was fixed.
- Test defensive checks, trust-boundary validation, error paths, retry/idempotency/replay safety, duplicate and out-of-order handling, conflict resolution, overload and degradation scenarios, startup and health-check failure modes, schema compatibility during evolution, and translation layers.
- Prefer writing a failing test before production code (TDD) when the behavior can be specified clearly.
- Do not ship code changes without proportionate validation. Treat ignored, flaky, or skipped tests as unresolved questions.
- Build small testing helpers or DSLs only when repeated setup hides intent; keep test code clean.

## Refactoring, Emergent Design, and Change Process
- Refactor in **small, safe steps**. Preserve behavior while improving structure. First make it work, then make it right.
- Remove duplication, dead code, weak or misleading names and abstractions, and special-case clutter.
- Rename aggressively when names are weak or when domain language has improved.
- Extract code when doing so improves cohesion and clarity. Inline abstractions that no longer earn their cost.
- Prefer the simplest design that passes all relevant tests, removes duplication, expresses intent clearly, and uses the fewest necessary classes and methods.
- When code starts rough, keep improving names, structure, model fidelity, and tests until intent is clear.
- For model evolution and deeper insight: recover the ubiquitous language; move business rules inward to entities, aggregates, domain services, or explicit specifications/policies; introduce value objects where primitives hide meaning; redraw aggregate boundaries where invariants are unclear or transactional scope is too large; add explicit translation at context and infrastructure boundaries; break up god services into focused application services plus richer domain behavior.
- Do not start grand redesigns when incremental refinement can recover the design safely. Use the Boy Scout Rule proportionally to the task.
- For every non-trivial task:
  1. Understand the intent and affected behavior (domain rules, invariants, use case, data ownership, consistency requirements, failure modes).
  2. Identify the simplest correct change that also improves (or at least does not worsen) clarity, boundaries, model fidelity, or resilience.
  3. Improve names before adding comments.
  4. Keep edits localized when possible.
  5. Add or update tests for the changed behavior, invariants, and relevant failure/retry/translation/overload scenarios.
  6. Run relevant validation (unit, integration, property-based, failure-injection, or chaos testing where practical).
  7. Review the diff for readability, duplication, unnecessary complexity, boundary violations, language drift, and hidden assumptions.
  8. Ensure the final code is cleaner, the model is clearer or more explicit, boundaries are respected or strengthened, and production risks are addressed.

## Review Checklist
Before finalizing any change, verify **all** of the following. If any answer is no, revise before shipping.

**Code Quality**
- Names are intention-revealing and drawn from the ubiquitous language (no misleading, encoded, cute, vague technical placeholders, or synonyms).
- Functions/routines are small, focused, at one abstraction level, with clear command/query separation and visible side effects.
- Comments are necessary, accurate, and minimal; code is self-explanatory where possible.
- Error handling is explicit and defensive at trust boundaries, provides diagnosis context, and follows production stability rules (timeouts, bounded retries with jitter/backoff, isolation, back pressure).
- Formatting reveals structure; layout supports fast scanning; no brittle alignment or excessive line length that harms readability.
- Duplication was removed where reasonable; complexity was not increased; the design is simpler or at least equivalent.

**Architecture and Domain Model**
- Business rules and domain logic are independent of frameworks, persistence, delivery mechanisms, and outer details (Dependency Rule followed; no framework leakage into core).
- Bounded context is clear and respected; ubiquitous language is used consistently inside it; foreign terms or models do not leak in without explicit translation.
- Entities and aggregates protect invariants and valid state transitions; aggregates are small; cross-aggregate references use identity; all invariant-changing operations go through the root.
- Value objects are used where primitives hide meaning, validation, units, or rules.
- Use cases and application services orchestrate without owning core business rules or invariants.
- Repositories and gateways are proper adapters; their interfaces are owned by inner layers; they return domain objects.
- Translation is explicit at every boundary (context, persistence, delivery, external systems).
- Core domain is visible, protected, and invested in appropriately; supporting and generic subdomains are kept simpler.
- The domain model is appropriately rich (entities, aggregates, value objects, specifications) where complexity and invariants exist, rather than anemic or purely procedural. No god classes or god services, layer bypass, oversized aggregates, or accidental shared kernels that erase context boundaries.

**Production, Data, and Resilience**
- Every remote or dependency call has an explicit timeout; retry policy is disciplined and safe; isolation (bulkheads) and back-pressure/load-shedding strategies exist.
- Observability is sufficient for diagnosis (structured logs with correlation context, relevant metrics including tail latency and dependency health, meaningful health checks that reflect real state).
- Idempotency, replay safety, and duplicate/out-of-order handling are addressed where retries or distributed delivery can occur.
- Source of truth, consistency semantics (strong vs eventual, conflict model), and derived data repairability/lag visibility are explicit.
- Schema/contract evolution and versioning are considered for long-lived interfaces and data flows.
- Deployment and operational automation is restartable or idempotent where relevant; startup fails fast on critical misconfiguration.
- Tests cover core behavior and invariants without infrastructure, plus relevant failure, retry, idempotency, overload, degradation, translation, and data-semantics scenarios.

**General**
- The change follows existing project conventions (or improves them consistently and explicitly).
- Any unresolved risks, assumptions, or deliberate trade-offs are called out with justification.
- The resulting code would stand up to careful review by a peer familiar with these principles.

## Output Expectations When Making Changes
When generating, editing, or refactoring code:
- Briefly explain **what** changed and **why** in terms of these principles (e.g., "Tightened aggregate boundary around `Order` to protect the `inventory allocation` invariant under concurrent `allocate` and `cancel` operations", "Introduced `Money` value object to eliminate primitive obsession, scattered rounding logic, and currency validation duplication", "Added explicit timeout, jittered backoff retry, circuit breaker, and bulkhead isolation for `PaymentGateway` per stability and resilience rules", "Moved business rule from application service into `Order` aggregate root to protect consistency boundary and make the domain model more expressive").
- State what tests or validation checks were run, including relevant failure, retry, idempotency, translation, overload, or data-semantics scenarios.
- Call out any unresolved risk, assumption, deliberate trade-off, or conflict with these rules, along with justification and mitigation. Keep compromises at the outermost layer possible and document them for future improvement.
- If a requested change conflicts with these rules, follow the request but explicitly note the conflict, explain the tension with long-term goals, and propose a cleaner architectural or modeling alternative that achieves the intent with lower long-term cost.

## Implementation Preferences and Trade-offs
- Prefer **explicit, boring, maintainable** solutions over clever, dense, or fashionable idioms that increase the cost of inspection and reasoning.
- Prefer standard library and established project patterns over new dependencies unless the dependency clearly reduces overall complexity without introducing new coupling, failure modes, or maintenance burden.
- Keep interfaces small and focused. Make state transitions obvious. Encode important invariants close to the code they protect.
- Avoid premature optimization. When performance or capacity matters, measure before and after; keep clarity unless the trade-off is explicit, justified, and documented.
- For data-intensive and distributed systems: make trade-offs (consistency vs availability/latency, strong vs eventual consistency, synchronous vs asynchronous replication, partitioning strategy, storage model) **explicit** rather than hidden inside abstractions. Choose storage, indexing, partitioning, and replication based on concrete access patterns, contention points, and failure models. Plan for evolution and partial failure.
- When trade-offs are forced by external constraints: choose the design that minimizes long-term coupling, defect risk, and cognitive load. Preserve future options for stronger boundaries, richer modeling, or better isolation. Document the compromise clearly.

## Final Instruction
When in doubt, choose the option that:
- Makes the domain language sharper and more precise.
- Protects invariants inside the model at the right consistency boundary.
- Keeps bounded contexts explicit and translation visible.
- Reduces primitive obsession and hidden assumptions.
- Strengthens architectural boundaries and inward dependencies.
- Increases resilience to production realities (partial failure, overload, stale data, duplicates, reordering, schema drift).
- Keeps the code easier to inspect, test, reason about, and evolve under real-world conditions.

Reject changes that make the code shorter, more generic, or superficially simpler in the moment if they make the domain less clear, the architecture more coupled, the model shallower, or the system more fragile in production or under evolution.

