import Testing
@testable import SwiftFormCore

@Suite("SwiftFormCore")
struct SwiftFormCoreTests {

    @Test func fieldIdentifierCreation() {
        let id = FormFieldIdentifier("username")
        #expect(id.rawValue == "username")
        #expect(id.description == "username")
    }

    @Test func fieldIdentifierStringLiteral() {
        let id: FormFieldIdentifier = "email"
        #expect(id.rawValue == "email")
    }

    @Test func fieldIdentifierEquality() {
        let a: FormFieldIdentifier = "name"
        let b = FormFieldIdentifier("name")
        #expect(a == b)
    }

    @Test func componentTypeCreation() {
        let type = ComponentType("custom_widget")
        #expect(type.rawValue == "custom_widget")
    }

    @Test func builtInComponentTypes() {
        #expect(ComponentType.text.rawValue == "text")
        #expect(ComponentType.email.rawValue == "email")
        #expect(ComponentType.toggle.rawValue == "toggle")
        #expect(ComponentType.camera.rawValue == "camera")
    }

    @Test func versionComparison() {
        let v1 = Version(1, 0, 0)
        let v2 = Version(1, 1, 0)
        let v3 = Version(2, 0, 0)
        #expect(v1 < v2)
        #expect(v2 < v3)
        #expect(v1.description == "1.0.0")
    }

    @Test func formConfigurationDefaults() {
        let config = FormConfiguration()
        #expect(config.validateOnChange == true)
        #expect(config.validateOnBlur == true)
        #expect(config.autosaveEnabled == false)
        #expect(config.accessibilityEnabled == true)
        #expect(config.analyticsEnabled == false)
    }

    @Test func formErrorCases() {
        let error = FormError.fieldNotFound("missing_field")
        if case .fieldNotFound(let id) = error {
            #expect(id.rawValue == "missing_field")
        } else {
            Issue.record("Expected fieldNotFound")
        }
    }

    @Test func formValueConformance() {
        func acceptFormValue<V: FormValue>(_ value: V) -> V { value }
        #expect(acceptFormValue("hello") == "hello")
        #expect(acceptFormValue(42) == 42)
        #expect(acceptFormValue(3.14) == 3.14)
        #expect(acceptFormValue(true) == true)
    }
}
