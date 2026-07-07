import SwiftFormCore

/// Outcome of a single validation check.
public struct ValidationResult: Sendable, Hashable {

    public let isValid: Bool
    public let messages: [ValidationMessage]

    public static let valid = ValidationResult(isValid: true, messages: [])

    public static func invalid(_ messages: [ValidationMessage]) -> ValidationResult {
        ValidationResult(isValid: false, messages: messages)
    }

    public init(isValid: Bool, messages: [ValidationMessage]) {
        self.isValid = isValid
        self.messages = messages
    }
}

/// A single validation message with severity.
public struct ValidationMessage: Sendable, Hashable {
    public let text: String
    public let severity: ValidationSeverity

    public init(_ text: String, severity: ValidationSeverity = .error) {
        self.text = text
        self.severity = severity
    }
}
