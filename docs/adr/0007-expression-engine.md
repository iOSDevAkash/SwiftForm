# ADR-0007: Expression Engine

## Status
Accepted

## Context
The Rule Engine needs an expression evaluator for conditions like `age >= 18`, `country == "India"`, `business == true`. Two options were considered:

1. **NSPredicate/NSExpression** — available on Apple platforms, fast to implement
2. **Custom recursive-descent parser** — more work upfront, fully controlled

Since expressions may arrive from a server (Server-Driven UI), security is a primary concern.

## Decision
Build a **custom recursive-descent parser/interpreter**.

Reasons:
- **Security:** `NSExpression` can evaluate arbitrary Objective-C key paths and method calls. Accepting untrusted server-supplied expression strings through `NSExpression` is a known risk vector. A custom parser evaluates only explicitly supported operators against a controlled value dictionary.
- **Swift 6 / Sendable:** `NSPredicate` and `NSExpression` are not `Sendable`. A custom `Expression` protocol can be fully `Sendable`-compliant.
- **Type safety:** The custom parser produces a typed AST (`Expression` protocol), not opaque strings. Errors are caught at parse time, not evaluation time.
- **Testability:** Pure Swift value types. No Foundation/Objective-C runtime dependency.

Supported operators (initial): `==`, `!=`, `>`, `>=`, `<`, `<=`, `&&`, `||`, `!`.

## Consequences
- **Positive:** Safe for server-driven expressions. Fully typed, Sendable, testable.
- **Negative:** More upfront implementation work than NSPredicate.
- **Negative:** Must manually add support for new operators/functions over time.
