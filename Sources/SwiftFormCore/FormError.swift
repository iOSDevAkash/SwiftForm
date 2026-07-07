/// Structured error type for the SwiftForm framework.
public enum FormError: Error, Sendable, Hashable {
    case fieldNotFound(FormFieldIdentifier)
    case typeMismatch(field: FormFieldIdentifier, expected: String, actual: String)
    case validationFailed(field: FormFieldIdentifier, reasons: [String])
    case schemaInvalid(reason: String)
    case encodingFailed(reason: String)
    case decodingFailed(reason: String)
    case componentNotRegistered(ComponentType)
    case pluginError(name: String, reason: String)
    case networkError(reason: String)
    case expressionError(reason: String)
}
