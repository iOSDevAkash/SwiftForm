# ADR-0006: JSON Renderer

## Status
Accepted

## Context
Server-driven UI and dynamic forms require rendering forms from JSON and serializing form state back to JSON. The JSON format must be versioned for forward/backward compatibility.

## Decision
Bidirectional JSON pipeline through the schema layer:

- **Input:** JSON data → `SchemaDecoder` → `FormSchema` → Renderer → SwiftUI
- **Output:** Form state → `SchemaEncoder` → JSON data
- `JSONSchemaVersion` tags every schema for migration support
- All incoming JSON treated as untrusted — component types resolved through the registry (not arbitrary class instantiation), expressions evaluated through the sandboxed custom parser

## Consequences
- **Positive:** Server-driven UI is a natural extension of the schema-first architecture. No separate "JSON mode" — same renderer, same components.
- **Positive:** Schema versioning enables safe migration when the JSON format evolves.
- **Negative:** The JSON format must be expressive enough to represent all schema features, including rules and validation. Complex schemas produce verbose JSON.
- **Negative:** Custom `Codable` conformances needed for protocol-typed properties (e.g., `any FieldSchema`).
