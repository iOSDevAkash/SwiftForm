import SwiftFormCore

/// Context provided to validation rules during evaluation.
public struct ValidationContext: Sendable {
    public let fieldID: FormFieldIdentifier
    public let formValues: @Sendable (FormFieldIdentifier) -> (any FormValue)?

    public init(
        fieldID: FormFieldIdentifier,
        formValues: @escaping @Sendable (FormFieldIdentifier) -> (any FormValue)?
    ) {
        self.fieldID = fieldID
        self.formValues = formValues
    }
}

/// A single validation rule that can be applied to a field value.
public protocol ValidationRule: Sendable {
    func validate(_ value: any FormValue, context: ValidationContext) async -> ValidationResult
}

/// Composes multiple validation rules into a pipeline.
public protocol Validator: Sendable {
    var rules: [any ValidationRule] { get }
    func validate(_ value: any FormValue, context: ValidationContext) async -> ValidationResult
}
