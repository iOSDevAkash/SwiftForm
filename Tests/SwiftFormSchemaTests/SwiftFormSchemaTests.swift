import Testing
@testable import SwiftFormSchema
import SwiftFormCore

struct TestField: FieldSchema {
    let id: FormFieldIdentifier
    let componentType: ComponentType
    let title: String
    let subtitle: String? = nil
    let placeholder: String? = nil
    let isRequired: Bool
}

struct TestSection: SectionSchema {
    let id: String
    let title: String?
    let subtitle: String? = nil
    let fields: [TestField]
}

struct TestFormSchema: FormSchema {
    let id: String
    let title: String
    let version: Version
    let sections: [TestSection]
}

@Suite("SwiftFormSchema")
struct SwiftFormSchemaTests {

    @Test func fieldSchemaConformance() {
        let field = TestField(
            id: "name",
            componentType: .text,
            title: "Full Name",
            isRequired: true
        )
        #expect(field.id.rawValue == "name")
        #expect(field.componentType == .text)
        #expect(field.isRequired == true)
    }

    @Test func sectionSchemaConformance() {
        let section = TestSection(
            id: "profile",
            title: "Profile",
            fields: [
                TestField(id: "name", componentType: .text, title: "Name", isRequired: true),
            ]
        )
        #expect(section.fields.count == 1)
    }

    @Test func formSchemaConformance() {
        let form = TestFormSchema(
            id: "registration",
            title: "Registration",
            version: Version(1, 0, 0),
            sections: []
        )
        #expect(form.id == "registration")
        #expect(form.version == Version(1, 0, 0))
    }
}
