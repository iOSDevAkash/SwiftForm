# ADR-0008: UIKit Bridging Boundary

## Status
Accepted

## Context
Several form components have no pure SwiftUI implementation today: Camera, Barcode/QR scanning, Signature capture, and Document Picker all require `UIViewControllerRepresentable` or AVFoundation. Allowing UIKit imports to spread across modules would couple the framework to a single platform and complicate macOS support.

## Decision
Create a dedicated **`SwiftFormCapture`** module that isolates all UIKit and AVFoundation bridging:

- Camera, Barcode, QR, Signature, and Document Picker components live in `SwiftFormCapture`
- `CaptureComponent` protocol marks UIKit-bridged components
- Platform-conditional compilation (`#if canImport(UIKit)`) gates iOS-specific code
- **No other module may import UIKit.** `SwiftFormCore`, `SwiftFormSchema`, `SwiftFormState`, `SwiftFormRenderer`, and all other modules remain UIKit-free.

## Consequences
- **Positive:** Core modules remain platform-agnostic. macOS, and future visionOS support, are not blocked by UIKit dependencies.
- **Positive:** Clear boundary for contributors — if it needs UIKit, it goes in Capture.
- **Positive:** Apps that don't need camera/barcode/signature can exclude `SwiftFormCapture` entirely.
- **Negative:** Components in Capture cannot share view code with pure SwiftUI components in `SwiftFormComponents`. Some duplication of wrapper patterns may occur.
