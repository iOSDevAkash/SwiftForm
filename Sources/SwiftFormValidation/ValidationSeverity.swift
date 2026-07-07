import SwiftFormCore

/// Severity level for validation results.
public enum ValidationSeverity: String, Sendable, Hashable, Comparable {
    case info
    case warning
    case error

    public static func < (lhs: ValidationSeverity, rhs: ValidationSeverity) -> Bool {
        let order: [ValidationSeverity] = [.info, .warning, .error]
        guard let l = order.firstIndex(of: lhs), let r = order.firstIndex(of: rhs) else { return false }
        return l < r
    }
}
