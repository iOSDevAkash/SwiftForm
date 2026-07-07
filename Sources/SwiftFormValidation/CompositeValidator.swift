import SwiftFormCore

/// Composes multiple validation rules into a sequential pipeline.
///
/// Rules run in order. Stops at the first rule that fails by default,
/// or can collect all failures.
public struct CompositeValidator: Validator {

    public let rules: [any ValidationRule]
    public let collectAll: Bool

    public init(rules: [any ValidationRule], collectAll: Bool = false) {
        self.rules = rules
        self.collectAll = collectAll
    }

    public func validate(_ value: any FormValue, context: ValidationContext) async -> ValidationResult {
        var allMessages: [ValidationMessage] = []

        for rule in rules {
            let result = await rule.validate(value, context: context)
            if !result.isValid {
                if collectAll {
                    allMessages.append(contentsOf: result.messages)
                } else {
                    return result
                }
            }
        }

        return allMessages.isEmpty ? .valid : .invalid(allMessages)
    }
}

/// Wraps a validation rule to produce warnings instead of errors.
public struct WarningRule: ValidationRule {

    private let inner: any ValidationRule

    public init(_ rule: any ValidationRule) {
        self.inner = rule
    }

    public func validate(_ value: any FormValue, context: ValidationContext) async -> ValidationResult {
        let result = await inner.validate(value, context: context)
        guard !result.isValid else { return .valid }
        let warnings = result.messages.map { ValidationMessage($0.text, severity: .warning) }
        return .invalid(warnings)
    }
}

/// Cross-field validation that compares two fields.
public struct CrossFieldRule: ValidationRule {

    private let otherFieldID: FormFieldIdentifier
    private let comparison: @Sendable (any FormValue, any FormValue) -> Bool
    private let message: String

    public init(
        otherField: FormFieldIdentifier,
        message: String,
        comparison: @escaping @Sendable (any FormValue, any FormValue) -> Bool
    ) {
        self.otherFieldID = otherField
        self.message = message
        self.comparison = comparison
    }

    public func validate(_ value: any FormValue, context: ValidationContext) async -> ValidationResult {
        guard let otherValue = context.formValues(otherFieldID) else {
            return .valid
        }
        if comparison(value, otherValue) {
            return .valid
        }
        return .invalid([ValidationMessage(message)])
    }
}
