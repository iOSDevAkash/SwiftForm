import Testing
@testable import SwiftFormJSON
@testable import SwiftFormSchema
import SwiftFormCore
import Foundation

@Suite("SwiftFormJSON")
struct SwiftFormJSONFullTests {

    @Test func encodeAndDecodeSchema() throws {
        let original = FormDescriptor(
            id: "registration",
            title: "Registration",
            version: Version(1, 0, 0),
            sections: [
                FormSectionDescriptor(
                    id: "profile",
                    title: "Profile",
                    fields: [
                        FormFieldDescriptor(
                            id: "name",
                            componentType: .text,
                            title: "Name",
                            placeholder: "Enter name",
                            isRequired: true
                        ),
                        FormFieldDescriptor(
                            id: "email",
                            componentType: .email,
                            title: "Email",
                            isRequired: true
                        ),
                    ]
                ),
            ]
        )

        let encoder = JSONSchemaEncoder()
        let data = try encoder.encode(original)

        let decoder = JSONSchemaDecoder()
        let decoded = try decoder.decode(from: data)

        guard let result = decoded as? FormDescriptor else {
            Issue.record("Expected FormDescriptor")
            return
        }

        #expect(result.id == "registration")
        #expect(result.title == "Registration")
        #expect(result.version == Version(1, 0, 0))
        #expect(result.sections.count == 1)
        #expect(result.sections[0].fields.count == 2)
        #expect(result.sections[0].fields[0].id.rawValue == "name")
    }

    @Test func decodeFromRawJSON() throws {
        let json = """
        {
            "id": "survey",
            "title": "Customer Survey",
            "version": {"major": 2, "minor": 0, "patch": 1},
            "sections": [
                {
                    "id": "feedback",
                    "title": "Feedback",
                    "fields": [
                        {
                            "id": "rating",
                            "componentType": "rating",
                            "title": "Rate our service",
                            "isRequired": true
                        }
                    ],
                    "isCollapsible": false,
                    "isCollapsed": false
                }
            ]
        }
        """.data(using: .utf8)!

        let decoder = JSONSchemaDecoder()
        let schema = try decoder.decode(from: json)

        guard let form = schema as? FormDescriptor else {
            Issue.record("Expected FormDescriptor")
            return
        }

        #expect(form.id == "survey")
        #expect(form.version == Version(2, 0, 1))
        #expect(form.sections[0].fields[0].componentType.rawValue == "rating")
    }

    @Test func encodeFormOutput() throws {
        let values: [FormFieldIdentifier: AnyCodableValue] = [
            "name": .string("John"),
            "age": .int(30),
            "active": .bool(true),
        ]

        let encoder = FormOutputEncoder()
        let data = try encoder.encode(values)

        let decoder = FormOutputDecoder()
        let decoded = try decoder.decode(from: data)

        #expect(decoded[FormFieldIdentifier("name")]?.stringValue == "John")
        #expect(decoded[FormFieldIdentifier("age")]?.intValue == 30)
        #expect(decoded[FormFieldIdentifier("active")]?.boolValue == true)
    }

    @Test func invalidJSONThrowsError() {
        let badJSON = "not json".data(using: .utf8)!
        let decoder = JSONSchemaDecoder()

        #expect(throws: FormError.self) {
            _ = try decoder.decode(from: badJSON)
        }
    }
}
