# ADR-0003: Design System

## Status
Accepted

## Context
Enterprise applications require visual consistency across forms and the ability to inject a corporate design system. Hardcoded colors, spacing, and typography make white-labeling impossible.

## Decision
Adopt a **Design Token** system with protocol-based token sets:

- `DesignTokens` — root protocol composing `ColorTokens`, `SpacingTokens`, `TypographyTokens`, `RadiusTokens`, `ElevationTokens`
- `ThemeProvider` — injects tokens into the SwiftUI environment
- All built-in components read tokens from the environment — never from hardcoded values

Applications provide their own `DesignTokens` conformance to theme the entire form system.

## Consequences
- **Positive:** Complete visual customization without subclassing or view replacement. White-label applications inject their design system once.
- **Positive:** Design tokens are Sendable value types — thread-safe by design.
- **Negative:** Every built-in component must read tokens from the environment, adding indirection.
- **Negative:** Defining a complete token set is non-trivial for adopters. A default theme implementation will ship as a convenience.
