# ADR-0009: Platform and Minimum OS

## Status
Accepted

## Context
The minimum deployment target determines which APIs are available and which users can adopt the framework. Key constraint: the Observation framework (`@Observable`) requires iOS 17+ / macOS 14+.

## Decision
- **iOS 18+** / **macOS 15+** minimum deployment target
- **No visionOS** initially (can be added later without breaking changes)
- **Swift tools version 6.2** (Xcode 26+)
- **Swift 6 strict concurrency** enabled

iOS 18+ (rather than 17+) was chosen because:
1. iOS 18 adoption is already high, and by the time SwiftForm reaches 1.0, iOS 17 will represent a small fraction of active devices
2. iOS 18 includes refinements to Observation and SwiftUI that simplify implementation
3. Targeting iOS 18+ avoids workarounds for iOS 17-era Observation edge cases

## Consequences
- **Positive:** Full access to Observation framework, modern SwiftUI APIs, and Swift 6 concurrency features without compatibility shims.
- **Positive:** No `ObservableObject` / `@Published` / Combine fallback paths to maintain.
- **Negative:** Apps targeting iOS 17 cannot adopt SwiftForm. This is an acceptable tradeoff given the framework's enterprise focus and timeline.
- **Negative:** No visionOS out of the box. Adding it later requires testing Capture components with `#if os(visionOS)` guards.
