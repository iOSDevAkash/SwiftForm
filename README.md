# SwiftForm

Enterprise-grade, schema-driven SwiftUI form framework.

[![Swift 6.2](https://img.shields.io/badge/Swift-6.2-orange.svg)](https://swift.org)
[![iOS 18+](https://img.shields.io/badge/iOS-18+-blue.svg)](https://developer.apple.com/ios/)
[![macOS 15+](https://img.shields.io/badge/macOS-15+-blue.svg)](https://developer.apple.com/macos/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## What Is SwiftForm?

SwiftForm is a **Schema-Driven UI Engine** — not just a form library. It is the modern successor to [Eureka](https://github.com/xmartlabs/Eureka), built entirely in SwiftUI with Swift 6 strict concurrency.

```
Schema (source of truth)
    ↓
Rule Engine → Validation → State → Layout → Renderer
    ↓
SwiftUI Views
```

## Quick Start

```swift
import SwiftForm

// Define a form with the DSL
let schema = SwiftFormDSL.form("registration", title: "Register") {
    section("profile", title: "Profile") {
        textField("name", title: "Full Name", required: true)
        emailField("email", title: "Email", placeholder: "you@example.com", required: true)
        phoneField("phone", title: "Phone")
    }
    section("preferences", title: "Preferences") {
        toggle("newsletter", title: "Subscribe to newsletter")
        dropdown("role", title: "Role", options: [
            option("dev", label: "Developer"),
            option("designer", label: "Designer"),
            option("pm", label: "Product Manager"),
        ], required: true)
        rating("satisfaction", title: "Satisfaction")
    }
}

// Render it
struct ContentView: View {
    var body: some View {
        FormView(schema: schema) { values in
            print("Submitted:", values)
        }
    }
}
```

## Features

- **Schema-First Architecture** — forms defined as data, not views
- **Swift DSL** — declarative result-builder syntax
- **JSON ↔ UI** — bidirectional: render from JSON, serialize to JSON
- **Server-Driven UI** — download, cache (memory + disk), and render forms remotely with offline fallback
- **14 Built-in Components** — text, email, phone, date, time, toggle, checkbox, slider, dropdown, radio, segment, rating, secure field, text editor
- **8 Layout Engines** — stack, card, wizard, accordion, grid, tabs, grouped sections, stepper + responsive grid
- **Rule Engine** — conditional visibility, enablement, and validation with a custom expression parser
- **Validation Engine** — sync/async rules, cross-field validation, severity levels
- **Design System** — fully themeable via design tokens
- **Plugin Architecture** — extend behavior without modifying core
- **Accessibility** — VoiceOver, Dynamic Type, RTL, keyboard navigation
- **Analytics Hooks** — lifecycle events without SDK coupling

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/AkashShindworker/SwiftForm.git", from: "0.1.0")
]
```

Or in Xcode: File → Add Package Dependencies → paste the repository URL.

### Minimum Requirements

- iOS 18+ / macOS 15+
- Swift 6.2 / Xcode 26+

## Module Architecture

SwiftForm is organized into 17 focused modules. Import only what you need:

```swift
import SwiftForm          // Umbrella — everything
import SwiftFormCore      // Just foundational types
import SwiftFormSchema    // Schema protocols only
import SwiftFormJSON      // JSON encode/decode only
```

See [VISION.md](VISION.md) for the complete module map and architecture.

## Documentation

- [Vision & Architecture](VISION.md)
- [Contributing Guide](CONTRIBUTING.md)
- [Architecture Decision Records](docs/adr/)
- [Roadmap](docs/roadmap.md)

## License

SwiftForm is released under the [MIT License](LICENSE).
