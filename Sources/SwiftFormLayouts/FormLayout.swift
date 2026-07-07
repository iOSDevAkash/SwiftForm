import SwiftFormCore

/// Protocol for form layout metadata.
public protocol FormLayout: Sendable {
    var layoutType: LayoutType { get }
}
