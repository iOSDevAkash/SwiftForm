# ADR-0005: State Engine

## Status
Accepted

## Context
Form state management requires observable, reactive updates that integrate cleanly with SwiftUI. The framework targets iOS 18+ / macOS 15+, where the Observation framework is native.

## Decision
Use the **Observation framework** (`@Observable`) exclusively:

- `FieldState<Value>` — `@Observable` class holding field value, interaction state, and validation state
- `FormStateContainer` — protocol for form-level state access
- 17 `InteractionState` cases covering the full spectrum of field states
- No Combine, no `ObservableObject`, no `@Published`

## Consequences
- **Positive:** Native SwiftUI integration. No Combine import. Granular observation — views only re-render when their specific observed properties change.
- **Positive:** `@Observable` classes work with SwiftUI's `@State` and `@Bindable` naturally.
- **Negative:** Requires iOS 18+ minimum deployment target (already decided in ADR-0009).
- **Negative:** `@Observable` classes are reference types, which adds potential for unintended sharing. The `FormStateContainer` protocol boundary mitigates this.
