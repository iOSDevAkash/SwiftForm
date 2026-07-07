import SwiftFormCore

/// Describes the schema for a single form field.
public protocol FieldSchema: Sendable {
    var id: FormFieldIdentifier { get }
    var componentType: ComponentType { get }
    var title: String { get }
    var subtitle: String? { get }
    var placeholder: String? { get }
    var isRequired: Bool { get }
}
