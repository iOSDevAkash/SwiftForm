import Testing
@testable import SwiftFormAccessibility
@testable import SwiftFormSchema
import SwiftFormCore

@Suite("AccessibilityGenerator")
struct AccessibilityGeneratorTests {

    let generator = AccessibilityGenerator()

    @Test func requiredFieldHint() {
        let field = FormFieldDescriptor(
            id: "name",
            componentType: .text,
            title: "Full Name",
            isRequired: true
        )
        let descriptor = generator.descriptor(for: field, interactionState: "normal")
        #expect(descriptor.label == "Full Name")
        #expect(descriptor.hint?.contains("Required") == true)
    }

    @Test func placeholderInHint() {
        let field = FormFieldDescriptor(
            id: "email",
            componentType: .email,
            title: "Email",
            placeholder: "you@example.com"
        )
        let descriptor = generator.descriptor(for: field, interactionState: "normal")
        #expect(descriptor.hint?.contains("you@example.com") == true)
    }

    @Test func toggleGetsButtonTrait() {
        let field = FormFieldDescriptor(
            id: "accept",
            componentType: .toggle,
            title: "Accept Terms"
        )
        let descriptor = generator.descriptor(for: field, interactionState: "normal")
        #expect(descriptor.traits.contains(.button))
    }

    @Test func sliderGetsAdjustableTrait() {
        let field = FormFieldDescriptor(
            id: "volume",
            componentType: .slider,
            title: "Volume"
        )
        let descriptor = generator.descriptor(for: field, interactionState: "normal")
        #expect(descriptor.traits.contains(.adjustable))
    }

    @Test func disabledState() {
        let field = FormFieldDescriptor(
            id: "locked",
            componentType: .text,
            title: "Locked"
        )
        let descriptor = generator.descriptor(for: field, interactionState: "disabled")
        #expect(descriptor.traits.contains(.disabled))
    }

    @Test func validationMessagesInHint() {
        let field = FormFieldDescriptor(
            id: "email",
            componentType: .email,
            title: "Email"
        )
        let descriptor = generator.descriptor(
            for: field,
            interactionState: "error",
            validationMessages: ["Invalid email"]
        )
        #expect(descriptor.hint?.contains("Invalid email") == true)
    }
}
