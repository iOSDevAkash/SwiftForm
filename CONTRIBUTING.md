# Contributing to SwiftForm

Thank you for your interest in contributing to SwiftForm.

## Getting Started

1. Fork the repository
2. Create a feature branch from `main`: `git checkout -b feature/your-feature`
3. Make your changes
4. Run `swift build` and `swift test`
5. Submit a pull request

## Requirements

- Xcode 26+ / Swift 6.2+
- iOS 18+ / macOS 15+ deployment targets

## Coding Conventions

Follow the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/).

### Hard Rules

- **No force unwrap** (`!`) — use `guard`, `if let`, or `??` with a safe default
- **No force cast** (`as!`) — use `as?` with proper error handling
- **All public types must be `Sendable`** — the framework uses Swift 6 strict concurrency
- **No singletons** — use dependency injection
- **No `NotificationCenter`** — use protocols and delegates
- **No `UIKit` imports outside `SwiftFormCapture`** — Core, Schema, State, Renderer, and all other modules must remain UIKit-free

### The `AnyView` Boundary

`AnyView` is permitted **only** inside `ComponentFactory`'s return type in `SwiftFormRenderer`. This is the one place where type erasure is unavoidable (the component registry maps arbitrary types to views at runtime).

`AnyView` must **not** appear in:
- `SwiftFormSchema`
- `SwiftFormState`
- `SwiftFormRules`
- `SwiftFormCore`
- Any other module

### The UIKit Boundary

All UIKit/AVFoundation bridging lives in `SwiftFormCapture`. This includes Camera, Barcode, QR, Signature, and Document Picker components. If you're adding a component that needs `UIViewControllerRepresentable` or `UIViewRepresentable`, it goes in `SwiftFormCapture`.

### Value Types

Prefer structs over classes. Use classes only when `@Observable` requires it (e.g., `FieldState`).

## Testing

Every public type, protocol, and function requires tests. Focus on meaningful business logic tests (validation rules, state transitions, schema encoding) over trivial coverage.

Use the Swift Testing framework (`import Testing`, `@Test`, `#expect`).

## Documentation

All public APIs require DocC documentation comments. Include:
- A brief description
- Parameter documentation where non-obvious
- Example usage for complex APIs

## Commit Messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add email validation rule
fix: correct state transition on field blur
docs: update VISION.md with layout engine details
refactor: extract expression parser into separate type
test: add cross-field validation tests
```

## Versioning

SwiftForm uses [Semantic Versioning](https://semver.org/):

- **Major** — breaking API changes
- **Minor** — new features, backward-compatible
- **Patch** — bug fixes, backward-compatible

Breaking changes require a migration guide in `docs/`.

## Architecture Decision Records

Significant architectural decisions are documented in `docs/adr/`. If you're proposing a change that affects the framework's architecture, write an ADR first and include it in your PR.

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md).
