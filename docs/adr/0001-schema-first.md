# ADR-0001: Schema-First Architecture

## Status
Accepted

## Context
Form frameworks typically take one of two approaches: view-first (build UI, derive data) or schema-first (define data shape, derive UI). View-first is simpler for basic cases but becomes unwieldy for server-driven UI, JSON round-tripping, rule engines, and AI-driven generation — all core requirements for SwiftForm.

## Decision
Schema is the single source of truth. All pathways converge on schema:

- **Swift DSL** → Schema → Renderer → SwiftUI
- **JSON** → Schema → Renderer → SwiftUI
- **UI State** → Schema → JSON (output)

Views never own business logic. They receive state and render it. The schema layer is pure data — no SwiftUI imports, no view types, no platform dependencies.

## Consequences
- **Positive:** JSON ↔ UI becomes trivial. Server-driven UI is a natural extension. AI tools can generate schemas without parsing view trees. Testing is straightforward — schemas are plain value types.
- **Positive:** Rule engine, validation, and state engine all operate on schema, not views, enabling clean separation.
- **Negative:** Simple one-off forms require more boilerplate than a view-first approach. The DSL layer mitigates this.
- **Negative:** Schema must be expressive enough to represent all component configurations, which increases the protocol surface area.
