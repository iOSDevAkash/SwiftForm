# SwiftForm Roadmap

## Phase 1 — Foundation ✅
- Package structure with 17 modules
- Foundational protocols and types
- Governance docs (LICENSE, CODE_OF_CONDUCT, CONTRIBUTING)
- Architecture Decision Records
- CI pipeline
- Unit test targets

## Phase 2 — Schema & DSL ✅
- Concrete schema types (FormFieldDescriptor, FormSectionDescriptor, FormDescriptor)
- Result builder DSL for form construction (FormBuilder, SectionBuilder, field helpers)
- Schema validation (SchemaValidator with unique ID, title, option checks)
- JSON encoding/decoding (JSONSchemaEncoder, JSONSchemaDecoder, FormOutputEncoder/Decoder)

## Phase 3 — State Engine ✅
- FormStateStore with @Observable, field registration, value get/set
- FieldState with generic FormValue support
- InteractionState enum (17 states: normal, focused, disabled, error, hidden, etc.)
- Dirty tracking, reset, bulk value operations
- FormStateContainer protocol with full value access API

## Phase 4 — Validation Engine ✅
- Built-in rules: Required, Email, Phone, Regex, Length, Range, Password
- Async validation (ValidationRule protocol with async validate)
- Cross-field validation (CrossFieldRule)
- CompositeValidator with stop-at-first / collect-all modes
- ValidationSeverity (info < warning < error), WarningRule wrapper

## Phase 5 — Rule Engine ✅
- Custom recursive-descent expression parser (ExpressionLexer → ExpressionParser → AST)
- ExpressionRule and RuleEngine for evaluating rules against form state
- RuleAction enum (show, hide, enable, disable, require, validate)
- DefaultExpressionEvaluator — server-safe, no NSPredicate

## Phase 6 — Theme & Design System ✅
- DesignTokens protocol hierarchy (Color, Spacing, Typography, Radius, Elevation)
- DefaultDesignTokens with platform-adaptive colors (UIKit/AppKit)
- ThemeProvider protocol with SwiftUI EnvironmentKey injection
- DefaultThemeProvider ready for use

## Phase 7 — Core Components & Renderer ✅
- 14 SwiftUI component views: Text, SecureField, Email, Phone, TextEditor, Date, Time, Toggle, Checkbox, Slider, Dropdown, Radio, Segment, Rating
- FormFieldView wrapper (title, required indicator, subtitle, validation messages, interaction state)
- BuiltInComponentFactory mapping ComponentType → SwiftUI views
- DefaultComponentRegistry.withBuiltIns() pre-registering all 14 types
- DefaultFormRenderer with real section/field rendering via registry
- FormView public entry point: FormView(schema:) with optional onSubmit
- 155 tests passing across 30 suites

## Phase 8 — Layouts ✅
- FormLayoutEngine protocol in SwiftFormRenderer (layout engines plug in without circular deps)
- StackFormLayout (default vertical scroll — extracts current behavior into protocol)
- SectionView made public for layout engine reuse
- 8 concrete layout engines: Card, Wizard, Accordion, Grid, Tabs, GroupedSections, Stepper, ResponsiveGrid
- BuiltInLayoutRegistry with `.withBuiltIns()` factory, 8 registered types
- LayoutType moved to SwiftFormCore (parallels ComponentType)
- FormView and DefaultFormRenderer accept `layout:` parameter
- 174 tests passing across 30 suites

## Phase 9 — Server-Driven UI & Networking ✅
- SchemaCache protocol with MemorySchemaCache (actor-based) and DiskSchemaCache (filesystem)
- CachedSchema with TTL expiry, version tracking
- CachingSchemaProvider: wraps any provider with cache + offline fallback
- CacheConfiguration: TTL, offline fallback toggle
- SchemaVersionCheck: needsMigration/isDowngrade/isCurrent
- SchemaMigrator protocol + DefaultSchemaMigrator (no-op passthrough)
- URLSchemaProvider: improved error handling with HTTP status, timeout config
- RemoteFormView: SwiftUI view for fetch + render lifecycle (loading/error/retry/form)
- MockSchemaProvider for testability
- 204 tests passing across 30 suites

## Phase 10 — Advanced Features
- Plugin system implementation
- Analytics provider integration
- OTP, Currency, Search, Autocomplete components
- Location / Map components
- Charts, Markdown, Rich Text components

## Phase 11 — Capture Components
- Camera, Barcode, QR (AVFoundation bridging)
- Signature capture
- Document picker
- Image picker

## Phase 12 — Polish & Release
- DocC documentation site
- Sample applications (Registration, Survey, KYC, Checkout, Settings)
- Performance benchmarks (1000+ fields)
- Snapshot tests
- 1.0 release
