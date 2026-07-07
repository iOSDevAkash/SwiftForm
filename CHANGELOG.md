# Changelog

All notable changes to SwiftForm will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] — Unreleased

Initial public release.

### Added

- **SwiftFormCore** — foundational types, errors, and versioning
- **SwiftFormSchema** — schema protocols and field definitions
- **SwiftFormState** — reactive form state management
- **SwiftFormValidation** — sync/async validation engine with severity levels
- **SwiftFormRules** — rule engine with custom expression parser for conditional logic
- **SwiftFormDSL** — Swift result-builder DSL for declarative form definitions
- **SwiftFormTheme** — design-token-based theming system
- **SwiftFormComponents** — 14 built-in field components
- **SwiftFormRenderer** — schema-to-SwiftUI rendering engine
- **SwiftFormLayouts** — 8 layout engines (stack, card, wizard, accordion, grid, tabs, grouped, stepper)
- **SwiftFormJSON** — bidirectional JSON serialization
- **SwiftFormNetworking** — server-driven UI with caching and offline fallback
- **SwiftFormPlugins** — plugin architecture for extensibility
- **SwiftFormAccessibility** — VoiceOver, Dynamic Type, RTL, keyboard navigation
- **SwiftFormAnalytics** — lifecycle event hooks
- **SwiftFormCapture** — platform bridging utilities
- **SwiftFormUtilities** — shared helpers
- **SwiftForm** — umbrella module re-exporting all of the above
