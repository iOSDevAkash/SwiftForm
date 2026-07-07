# SwiftForm Vision

SwiftForm is an enterprise-grade, schema-driven SwiftUI framework — the modern successor to Eureka.

This is **not** a form library. It is a **Schema-Driven UI Engine**.

## Architecture Flow

```
Swift DSL
    │
    ▼
Schema Builder
    │
    ▼
Form Schema          ◄── JSON Input
    │
    ▼
Rule Engine
    │
    ▼
Validation Engine
    │
    ▼
State Engine
    │
    ▼
Layout Engine
    │
    ▼
Renderer
    │
    ▼
SwiftUI Views        ──► JSON Output
```

Schema is always the source of truth. Views never own business logic — views only render state.

## Clean Architecture

```
Public DSL → Schema → Renderer → Components → Design System → Platform
```

## Platforms

- iOS 18+ / macOS 15+
- Swift tools version 6.2
- Swift 6 strict concurrency

## Module Map

| Module | Responsibility |
|--------|---------------|
| **SwiftFormCore** | Foundational types: identifiers, values, configuration, errors |
| **SwiftFormSchema** | Schema protocols: field, section, form descriptors |
| **SwiftFormState** | Observable state: interaction states, field state containers |
| **SwiftFormValidation** | Validation rules, results, severity, composable validators |
| **SwiftFormRules** | Conditional rules, actions, custom expression evaluator |
| **SwiftFormTheme** | Design tokens: colors, spacing, typography, radius, elevation |
| **SwiftFormDSL** | Result builders for declarative form construction |
| **SwiftFormRenderer** | Rendering engine, component factory, component registry |
| **SwiftFormComponents** | Built-in component protocols and configurations |
| **SwiftFormLayouts** | Layout engine: form, card, wizard, grid, tabs, stepper |
| **SwiftFormJSON** | JSON encoding/decoding for schemas |
| **SwiftFormPlugins** | Plugin lifecycle hooks and context |
| **SwiftFormAccessibility** | Accessibility descriptors, traits, configuration |
| **SwiftFormAnalytics** | Form event tracking without SDK dependencies |
| **SwiftFormNetworking** | Remote schema fetching, caching |
| **SwiftFormUtilities** | Shared utilities and extensions |
| **SwiftFormCapture** | UIKit/AVFoundation bridging (camera, barcode, signature) |

## Design Principles

- **Swift 6** with strict concurrency checking
- **Observation framework** (`@Observable`, not Combine/ObservableObject)
- **Result Builders** for DSL
- **Protocol-Oriented** composition over inheritance
- **Dependency Injection** — no singletons, no NotificationCenter
- **Sendable** on all public types
- **No UIKit** outside `SwiftFormCapture`
- **No force unwrap / force cast** anywhere
- **`AnyView`** only in `ComponentFactory` return type (in `SwiftFormRenderer`)
- **Value types** preferred; reference types only when observation requires it

## State System

Every component supports 17 interaction states:

`normal` · `focused` · `active` · `loading` · `disabled` · `readOnly` · `selected` · `hovered` · `pressed` · `success` · `info` · `warning` · `error` · `skeleton` · `collapsed` · `expanded` · `hidden`

Each state carries: visual style, animation, accessibility metadata, icon, message.

## Validation

Built-in rules: required, email, phone, regex, number, range, date, password, cross-field, conditional, server validation, async validation with debounce.

Severity levels: error (blocking), warning (non-blocking), info.

## Rule Engine

Conditional logic: `visibleWhen`, `hiddenWhen`, `enabledWhen`, `disabledWhen`, `requiredWhen`, `validationWhen`.

Uses a custom recursive-descent expression parser (not NSPredicate) for Swift 6 Sendable safety and secure evaluation of server-driven expressions.

## Components

Built-in: TextField, SecureField, Email, Phone, OTP, Currency, Date, Time, Toggle, Checkbox, Radio, Segment, Dropdown, Search, Autocomplete, TextEditor, Slider, Rating, Progress, ImagePicker, Camera, Barcode, QR, Signature, DocumentPicker, Location, Map, Charts, Markdown, RichText, Custom.

Components requiring UIKit bridging (Camera, Barcode, QR, Signature, DocumentPicker) live in `SwiftFormCapture`.

## Layout Engine

Form, Cards, Wizard, Accordion, Grid, Responsive Grid, Tabs, Sections, Nested Sections, Stepper, Adaptive Layouts.

## JSON Support

Bidirectional: Input JSON → Schema → UI, and UI state → Output JSON.

Supports nested objects, arrays, dates, decimals, currency, optionals, custom encoding/decoding. Schema versioning for migration.

## Server-Driven UI

Download JSON, cache, offline support, versioning, migration, feature flags, A/B testing, diff updates. All incoming JSON treated as untrusted input.

## AI-First

Schema layer exposes metadata so AI tools can generate Swift DSL, Schema, JSON, documentation, and tests without reflecting on opaque SwiftUI view trees.
