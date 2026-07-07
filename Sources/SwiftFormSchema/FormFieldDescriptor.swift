import SwiftFormCore
import Foundation

/// Concrete descriptor for a single form field.
public struct FormFieldDescriptor: FieldSchema, Codable, Hashable {

    public let id: FormFieldIdentifier
    public let componentType: ComponentType
    public let title: String
    public let subtitle: String?
    public let placeholder: String?
    public let isRequired: Bool
    public var defaultValue: AnyCodableValue?
    public var options: [FieldOption]?
    public var metadata: [String: AnyCodableValue]?

    public init(
        id: FormFieldIdentifier,
        componentType: ComponentType,
        title: String,
        subtitle: String? = nil,
        placeholder: String? = nil,
        isRequired: Bool = false,
        defaultValue: AnyCodableValue? = nil,
        options: [FieldOption]? = nil,
        metadata: [String: AnyCodableValue]? = nil
    ) {
        self.id = id
        self.componentType = componentType
        self.title = title
        self.subtitle = subtitle
        self.placeholder = placeholder
        self.isRequired = isRequired
        self.defaultValue = defaultValue
        self.options = options
        self.metadata = metadata
    }
}

/// A selectable option for dropdown, radio, segment, etc.
public struct FieldOption: Sendable, Codable, Hashable, Identifiable {
    public let id: String
    public let label: String
    public let value: AnyCodableValue
    public var isDisabled: Bool

    public init(
        id: String,
        label: String,
        value: AnyCodableValue,
        isDisabled: Bool = false
    ) {
        self.id = id
        self.label = label
        self.value = value
        self.isDisabled = isDisabled
    }
}
