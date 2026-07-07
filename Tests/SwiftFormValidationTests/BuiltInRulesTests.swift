import Testing
@testable import SwiftFormValidation
import SwiftFormCore

@Suite("Built-in Validation Rules")
struct BuiltInRulesTests {

    let ctx = ValidationContext(fieldID: "test") { _ in nil }

    // MARK: - Required

    @Test func requiredPassesWithValue() async {
        let rule = RequiredRule()
        let result = await rule.validate("hello", context: ctx)
        #expect(result.isValid)
    }

    @Test func requiredFailsWithEmpty() async {
        let rule = RequiredRule()
        let result = await rule.validate("", context: ctx)
        #expect(!result.isValid)
    }

    @Test func requiredFailsWithWhitespace() async {
        let rule = RequiredRule()
        let result = await rule.validate("   ", context: ctx)
        #expect(!result.isValid)
    }

    // MARK: - Email

    @Test func emailValidAddress() async {
        let rule = EmailRule()
        let result = await rule.validate("user@example.com", context: ctx)
        #expect(result.isValid)
    }

    @Test func emailInvalidAddress() async {
        let rule = EmailRule()
        let result = await rule.validate("not-an-email", context: ctx)
        #expect(!result.isValid)
    }

    @Test func emailSkipsEmpty() async {
        let rule = EmailRule()
        let result = await rule.validate("", context: ctx)
        #expect(result.isValid)
    }

    // MARK: - Phone

    @Test func phoneValidNumber() async {
        let rule = PhoneRule()
        let result = await rule.validate("+1 (555) 123-4567", context: ctx)
        #expect(result.isValid)
    }

    @Test func phoneInvalidNumber() async {
        let rule = PhoneRule()
        let result = await rule.validate("abc", context: ctx)
        #expect(!result.isValid)
    }

    // MARK: - Length

    @Test func lengthTooShort() async {
        let rule = LengthRule(min: 5)
        let result = await rule.validate("ab", context: ctx)
        #expect(!result.isValid)
    }

    @Test func lengthTooLong() async {
        let rule = LengthRule(max: 3)
        let result = await rule.validate("abcdef", context: ctx)
        #expect(!result.isValid)
    }

    @Test func lengthWithinRange() async {
        let rule = LengthRule(min: 2, max: 10)
        let result = await rule.validate("hello", context: ctx)
        #expect(result.isValid)
    }

    // MARK: - Range

    @Test func rangeValidInt() async {
        let rule = RangeRule(min: 0, max: 100)
        let result = await rule.validate(50, context: ctx)
        #expect(result.isValid)
    }

    @Test func rangeTooLow() async {
        let rule = RangeRule(min: 18)
        let result = await rule.validate(15, context: ctx)
        #expect(!result.isValid)
    }

    @Test func rangeTooHigh() async {
        let rule = RangeRule(max: 100)
        let result = await rule.validate(150.0, context: ctx)
        #expect(!result.isValid)
    }

    // MARK: - Password

    @Test func passwordStrong() async {
        let rule = PasswordRule()
        let result = await rule.validate("MyPass123", context: ctx)
        #expect(result.isValid)
    }

    @Test func passwordTooShort() async {
        let rule = PasswordRule()
        let result = await rule.validate("Ab1", context: ctx)
        #expect(!result.isValid)
    }

    @Test func passwordMissingUppercase() async {
        let rule = PasswordRule()
        let result = await rule.validate("mypass123", context: ctx)
        #expect(!result.isValid)
    }

    @Test func passwordCustomRequirements() async {
        let rule = PasswordRule(requirements: .init(
            minLength: 12,
            requiresSpecialCharacter: true
        ))
        let result = await rule.validate("Short1!", context: ctx)
        #expect(!result.isValid)
    }
}

@Suite("Composite Validator")
struct CompositeValidatorTests {

    let ctx = ValidationContext(fieldID: "test") { _ in nil }

    @Test func stopAtFirst() async {
        let validator = CompositeValidator(rules: [
            RequiredRule(),
            EmailRule(),
        ])
        let result = await validator.validate("", context: ctx)
        #expect(!result.isValid)
        #expect(result.messages.count == 1)
    }

    @Test func collectAll() async {
        let validator = CompositeValidator(rules: [
            LengthRule(min: 5),
            EmailRule(),
        ], collectAll: true)
        let result = await validator.validate("ab", context: ctx)
        #expect(!result.isValid)
        #expect(result.messages.count == 2)
    }

    @Test func allPass() async {
        let validator = CompositeValidator(rules: [
            RequiredRule(),
            EmailRule(),
        ])
        let result = await validator.validate("user@example.com", context: ctx)
        #expect(result.isValid)
    }
}

@Suite("Warning Rule")
struct WarningRuleTests {

    let ctx = ValidationContext(fieldID: "test") { _ in nil }

    @Test func convertsToWarning() async {
        let rule = WarningRule(LengthRule(min: 10))
        let result = await rule.validate("short", context: ctx)
        #expect(!result.isValid)
        #expect(result.messages[0].severity == .warning)
    }
}

@Suite("Cross-Field Rule")
struct CrossFieldRuleTests {

    @Test func matchingFields() async {
        let ctx = ValidationContext(fieldID: "confirmPassword") { id in
            if id.rawValue == "password" { return "secret123" as String }
            return nil
        }

        let rule = CrossFieldRule(
            otherField: "password",
            message: "Passwords must match"
        ) { a, b in
            guard let s1 = a as? String, let s2 = b as? String else { return false }
            return s1 == s2
        }

        let result = await rule.validate("secret123" as String, context: ctx)
        #expect(result.isValid)
    }

    @Test func mismatchingFields() async {
        let ctx = ValidationContext(fieldID: "confirmPassword") { id in
            if id.rawValue == "password" { return "secret123" as String }
            return nil
        }

        let rule = CrossFieldRule(
            otherField: "password",
            message: "Passwords must match"
        ) { a, b in
            guard let s1 = a as? String, let s2 = b as? String else { return false }
            return s1 == s2
        }

        let result = await rule.validate("different" as String, context: ctx)
        #expect(!result.isValid)
        #expect(result.messages[0].text == "Passwords must match")
    }
}
