# ADR-0002: Renderer Architecture

## Status
Accepted

## Context
The renderer must map schema field descriptors to SwiftUI views at runtime. Since the component registry allows third-party components, the renderer cannot know concrete view types at compile time.

## Decision
Adopt a **Registry + ComponentFactory** pattern:

```
ComponentRegistry → ComponentFactory → AnyView
```

- `ComponentRegistry` maps `ComponentType` identifiers to `ComponentFactory` instances.
- `ComponentFactory` produces `AnyView` from a `FieldSchema` + `FormStateContainer`.
- `FormRenderer` iterates schema sections/fields, consults the registry, and assembles the view tree.

**`AnyView` is permitted strictly inside `ComponentFactory`'s return type.** It must not appear in Schema, State, Rules, or any other module. This is the one boundary where type erasure is unavoidable.

## Consequences
- **Positive:** Apps register custom components without modifying framework source. Third-party component libraries can extend SwiftForm.
- **Positive:** The renderer is thin — it delegates all view construction to factories.
- **Negative:** `AnyView` prevents SwiftUI from optimizing the diffing of factory-produced views. For forms with hundreds of fields, lazy rendering mitigates this.
- **Negative:** Type safety is lost at the factory boundary. Runtime errors possible if a factory receives an unexpected schema type.
