import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme

/// Protocol that all form components must conform to.
public protocol FormComponent: Sendable {
    var componentType: ComponentType { get }
}

/// Base configuration shared by all components.
public struct ComponentConfiguration: Sendable, Hashable {
    public let id: FormFieldIdentifier
    public let componentType: ComponentType
    public let isRequired: Bool
    public let isDisabled: Bool

    public init(
        id: FormFieldIdentifier,
        componentType: ComponentType,
        isRequired: Bool = false,
        isDisabled: Bool = false
    ) {
        self.id = id
        self.componentType = componentType
        self.isRequired = isRequired
        self.isDisabled = isDisabled
    }
}
