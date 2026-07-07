# ADR-0004: Plugin System

## Status
Accepted

## Context
SwiftForm needs extensibility beyond custom components — lifecycle hooks for analytics, persistence, logging, and third-party integrations. The extension mechanism must not couple the core to any specific SDK.

## Decision
Protocol-based plugins with lifecycle hooks:

- `FormPlugin` protocol with async hooks: `onFormLoaded`, `onFieldChanged`, `onFormSubmitted`
- Default implementations (no-ops) so plugins only override what they need
- `PluginContext` provides form metadata and configuration
- Plugins registered via dependency injection — no singletons, no NotificationCenter

## Consequences
- **Positive:** Analytics, autosave, logging, and custom behaviors added without modifying core.
- **Positive:** Plugins are Sendable and testable in isolation.
- **Negative:** Plugin execution order matters for some use cases (e.g., validation before analytics). Requires a defined ordering mechanism in future phases.
- **Negative:** Async hooks add complexity to the form lifecycle.
