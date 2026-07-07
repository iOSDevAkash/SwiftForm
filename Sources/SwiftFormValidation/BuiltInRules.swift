import SwiftFormCore
import Foundation

/// Validates that a value is present and non-empty.
public struct RequiredRule: ValidationRule {

    private let message: String

    public init(message: String = "This field is required") {
        self.message = message
    }

    public func validate(_ value: any FormValue, context: ValidationContext) async -> ValidationResult {
        if let str = value as? String, str.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .invalid([ValidationMessage(message)])
        }
        return .valid
    }
}

/// Validates email format.
public struct EmailRule: ValidationRule {

    private let message: String
    nonisolated(unsafe) private static let pattern = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/

    public init(message: String = "Invalid email address") {
        self.message = message
    }

    public func validate(_ value: any FormValue, context: ValidationContext) async -> ValidationResult {
        guard let str = value as? String, !str.isEmpty else { return .valid }
        if str.wholeMatch(of: Self.pattern) != nil {
            return .valid
        }
        return .invalid([ValidationMessage(message)])
    }
}

/// Validates phone number format.
public struct PhoneRule: ValidationRule {

    private let message: String
    nonisolated(unsafe) private static let pattern = /^\+?[\d\s\-()]{7,20}$/

    public init(message: String = "Invalid phone number") {
        self.message = message
    }

    public func validate(_ value: any FormValue, context: ValidationContext) async -> ValidationResult {
        guard let str = value as? String, !str.isEmpty else { return .valid }
        if str.wholeMatch(of: Self.pattern) != nil {
            return .valid
        }
        return .invalid([ValidationMessage(message)])
    }
}

/// Validates against a custom regex pattern.
public struct RegexRule: ValidationRule, @unchecked Sendable {

    private let regex: NSRegularExpression
    private let message: String

    public init(pattern: String, message: String = "Invalid format") throws {
        self.regex = try NSRegularExpression(pattern: pattern)
        self.message = message
    }

    public func validate(_ value: any FormValue, context: ValidationContext) async -> ValidationResult {
        guard let str = value as? String, !str.isEmpty else { return .valid }
        let range = NSRange(str.startIndex..., in: str)
        if regex.firstMatch(in: str, range: range) != nil {
            return .valid
        }
        return .invalid([ValidationMessage(message)])
    }
}

/// Validates string length within a range.
public struct LengthRule: ValidationRule {

    private let min: Int?
    private let max: Int?
    private let message: String?

    public init(min: Int? = nil, max: Int? = nil, message: String? = nil) {
        self.min = min
        self.max = max
        self.message = message
    }

    public func validate(_ value: any FormValue, context: ValidationContext) async -> ValidationResult {
        guard let str = value as? String, !str.isEmpty else { return .valid }
        let length = str.count

        if let min, length < min {
            let msg = message ?? "Must be at least \(min) characters"
            return .invalid([ValidationMessage(msg)])
        }

        if let max, length > max {
            let msg = message ?? "Must be at most \(max) characters"
            return .invalid([ValidationMessage(msg)])
        }

        return .valid
    }
}

/// Validates a numeric value within a range.
public struct RangeRule: ValidationRule {

    private let min: Double?
    private let max: Double?
    private let message: String?

    public init(min: Double? = nil, max: Double? = nil, message: String? = nil) {
        self.min = min
        self.max = max
        self.message = message
    }

    public func validate(_ value: any FormValue, context: ValidationContext) async -> ValidationResult {
        let number: Double?
        if let intVal = value as? Int {
            number = Double(intVal)
        } else if let dblVal = value as? Double {
            number = dblVal
        } else if let str = value as? String {
            number = Double(str)
        } else {
            return .valid
        }

        guard let num = number else { return .valid }

        if let min, num < min {
            let msg = message ?? "Must be at least \(min)"
            return .invalid([ValidationMessage(msg)])
        }

        if let max, num > max {
            let msg = message ?? "Must be at most \(max)"
            return .invalid([ValidationMessage(msg)])
        }

        return .valid
    }
}

/// Validates password strength.
public struct PasswordRule: ValidationRule {

    public struct Requirements: Sendable {
        public var minLength: Int
        public var requiresUppercase: Bool
        public var requiresLowercase: Bool
        public var requiresDigit: Bool
        public var requiresSpecialCharacter: Bool

        public init(
            minLength: Int = 8,
            requiresUppercase: Bool = true,
            requiresLowercase: Bool = true,
            requiresDigit: Bool = true,
            requiresSpecialCharacter: Bool = false
        ) {
            self.minLength = minLength
            self.requiresUppercase = requiresUppercase
            self.requiresLowercase = requiresLowercase
            self.requiresDigit = requiresDigit
            self.requiresSpecialCharacter = requiresSpecialCharacter
        }
    }

    private let requirements: Requirements

    public init(requirements: Requirements = Requirements()) {
        self.requirements = requirements
    }

    public func validate(_ value: any FormValue, context: ValidationContext) async -> ValidationResult {
        guard let str = value as? String, !str.isEmpty else { return .valid }
        var messages: [ValidationMessage] = []

        if str.count < requirements.minLength {
            messages.append(ValidationMessage("Must be at least \(requirements.minLength) characters"))
        }
        if requirements.requiresUppercase && !str.contains(where: { $0.isUppercase }) {
            messages.append(ValidationMessage("Must contain an uppercase letter"))
        }
        if requirements.requiresLowercase && !str.contains(where: { $0.isLowercase }) {
            messages.append(ValidationMessage("Must contain a lowercase letter"))
        }
        if requirements.requiresDigit && !str.contains(where: { $0.isNumber }) {
            messages.append(ValidationMessage("Must contain a digit"))
        }
        if requirements.requiresSpecialCharacter {
            let specialChars = CharacterSet.alphanumerics.inverted
            if str.unicodeScalars.allSatisfy({ !specialChars.contains($0) }) {
                messages.append(ValidationMessage("Must contain a special character"))
            }
        }

        return messages.isEmpty ? .valid : .invalid(messages)
    }
}
