import SwiftFormCore
import SwiftFormSchema

/// Accessibility metadata for a form field.
public protocol AccessibilityDescriptor: Sendable {
    var label: String { get }
    var hint: String? { get }
    var value: String? { get }
    var traits: Set<AccessibilityTrait> { get }
}

/// Accessibility traits for form components.
public enum AccessibilityTrait: String, Sendable, Hashable {
    case button
    case header
    case selected
    case disabled
    case adjustable
    case image
    case link
    case searchField
    case staticText
}

/// Configuration for accessibility behavior.
public struct AccessibilityConfiguration: Sendable, Hashable {
    public var announceValidation: Bool
    public var groupFields: Bool

    public init(
        announceValidation: Bool = true,
        groupFields: Bool = true
    ) {
        self.announceValidation = announceValidation
        self.groupFields = groupFields
    }
}
