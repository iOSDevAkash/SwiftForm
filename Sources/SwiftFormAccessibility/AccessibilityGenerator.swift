import SwiftFormCore
import SwiftFormSchema

/// Generates accessibility descriptors from field schema.
public struct AccessibilityGenerator: Sendable {

    public init() {}

    public func descriptor(
        for field: any FieldSchema,
        interactionState: String,
        validationMessages: [String] = []
    ) -> FieldAccessibilityDescriptor {
        var hints: [String] = []

        if field.isRequired {
            hints.append("Required field")
        }

        if let placeholder = field.placeholder {
            hints.append(placeholder)
        }

        if !validationMessages.isEmpty {
            hints.append(contentsOf: validationMessages)
        }

        var traits: Set<AccessibilityTrait> = []
        switch field.componentType {
        case .toggle, .checkbox:
            traits.insert(.button)
        case .slider, .rating:
            traits.insert(.adjustable)
        case .imagePicker, .camera:
            traits.insert(.image)
        default:
            break
        }

        if interactionState == "disabled" {
            traits.insert(.disabled)
        }

        return FieldAccessibilityDescriptor(
            label: field.title,
            hint: hints.isEmpty ? nil : hints.joined(separator: ". "),
            value: nil,
            traits: traits
        )
    }
}

/// Concrete accessibility descriptor for a form field.
public struct FieldAccessibilityDescriptor: AccessibilityDescriptor, Sendable, Hashable {
    public let label: String
    public let hint: String?
    public let value: String?
    public let traits: Set<AccessibilityTrait>

    public init(
        label: String,
        hint: String? = nil,
        value: String? = nil,
        traits: Set<AccessibilityTrait> = []
    ) {
        self.label = label
        self.hint = hint
        self.value = value
        self.traits = traits
    }
}
