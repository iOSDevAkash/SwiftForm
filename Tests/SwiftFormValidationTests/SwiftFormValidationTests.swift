import Testing
@testable import SwiftFormValidation
import SwiftFormCore

@Suite("SwiftFormValidation")
struct SwiftFormValidationTests {

    @Test func validationSeverityOrdering() {
        #expect(ValidationSeverity.info < .warning)
        #expect(ValidationSeverity.warning < .error)
    }

    @Test func validResult() {
        let result = ValidationResult.valid
        #expect(result.isValid == true)
        #expect(result.messages.isEmpty)
    }

    @Test func invalidResult() {
        let result = ValidationResult.invalid([
            ValidationMessage("Field is required", severity: .error),
            ValidationMessage("Consider adding more detail", severity: .warning),
        ])
        #expect(result.isValid == false)
        #expect(result.messages.count == 2)
        #expect(result.messages[0].severity == .error)
    }

    @Test func validationMessageDefaults() {
        let msg = ValidationMessage("Required")
        #expect(msg.severity == .error)
    }
}
