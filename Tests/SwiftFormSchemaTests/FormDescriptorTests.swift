import Testing
import Foundation
@testable import SwiftFormSchema
import SwiftFormCore

@Suite("FormDescriptor")
struct FormDescriptorTests {

    @Test func createFieldDescriptor() {
        let field = FormFieldDescriptor(
            id: "email",
            componentType: .email,
            title: "Email Address",
            placeholder: "you@example.com",
            isRequired: true
        )
        #expect(field.id.rawValue == "email")
        #expect(field.componentType == .email)
        #expect(field.isRequired)
        #expect(field.placeholder == "you@example.com")
    }

    @Test func createSectionDescriptor() {
        let section = FormSectionDescriptor(
            id: "profile",
            title: "Profile",
            fields: [
                FormFieldDescriptor(id: "name", componentType: .text, title: "Name", isRequired: true),
                FormFieldDescriptor(id: "email", componentType: .email, title: "Email"),
            ]
        )
        #expect(section.id == "profile")
        #expect(section.fields.count == 2)
    }

    @Test func createFormDescriptor() {
        let form = FormDescriptor(
            id: "registration",
            title: "Registration",
            sections: [
                FormSectionDescriptor(
                    id: "main",
                    title: "Main",
                    fields: [
                        FormFieldDescriptor(id: "name", componentType: .text, title: "Name"),
                    ]
                ),
            ]
        )
        #expect(form.id == "registration")
        #expect(form.sections.count == 1)
        #expect(form.sections[0].fields.count == 1)
    }

    @Test func fieldWithOptions() {
        let field = FormFieldDescriptor(
            id: "country",
            componentType: .dropdown,
            title: "Country",
            options: [
                FieldOption(id: "us", label: "United States", value: .string("US")),
                FieldOption(id: "in", label: "India", value: .string("IN")),
            ]
        )
        #expect(field.options?.count == 2)
        #expect(field.options?[0].label == "United States")
    }

    @Test func fieldWithMetadata() {
        let field = FormFieldDescriptor(
            id: "phone",
            componentType: .phone,
            title: "Phone",
            metadata: ["countryCode": "+1", "maxLength": 10]
        )
        #expect(field.metadata?["countryCode"]?.stringValue == "+1")
        #expect(field.metadata?["maxLength"]?.intValue == 10)
    }

    @Test func formDescriptorCodableRoundTrip() throws {
        let original = FormDescriptor(
            id: "test",
            title: "Test Form",
            version: Version(1, 2, 3),
            sections: [
                FormSectionDescriptor(
                    id: "s1",
                    title: "Section 1",
                    fields: [
                        FormFieldDescriptor(
                            id: "name",
                            componentType: .text,
                            title: "Name",
                            isRequired: true,
                            defaultValue: .string("John")
                        ),
                    ]
                ),
            ],
            submitTitle: "Submit"
        )

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(FormDescriptor.self, from: data)

        #expect(decoded.id == original.id)
        #expect(decoded.title == original.title)
        #expect(decoded.version == original.version)
        #expect(decoded.sections.count == 1)
        #expect(decoded.sections[0].fields[0].id.rawValue == "name")
        #expect(decoded.sections[0].fields[0].defaultValue?.stringValue == "John")
        #expect(decoded.submitTitle == "Submit")
    }
}
