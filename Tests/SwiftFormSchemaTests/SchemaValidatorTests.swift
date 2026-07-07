import Testing
@testable import SwiftFormSchema
import SwiftFormCore

@Suite("SchemaValidator")
struct SchemaValidatorTests {

    let validator = SchemaValidator()

    @Test func validFormPasses() {
        let form = FormDescriptor(
            id: "test",
            title: "Test",
            sections: [
                FormSectionDescriptor(
                    id: "s1",
                    title: "Section",
                    fields: [
                        FormFieldDescriptor(id: "name", componentType: .text, title: "Name"),
                    ]
                ),
            ]
        )
        let issues = validator.validate(form)
        #expect(issues.isEmpty)
    }

    @Test func emptyFormID() {
        let form = FormDescriptor(id: "", title: "Test", sections: [
            FormSectionDescriptor(id: "s1", fields: [
                FormFieldDescriptor(id: "f1", componentType: .text, title: "F"),
            ]),
        ])
        let issues = validator.validate(form)
        #expect(issues.contains(.formIDEmpty))
    }

    @Test func emptyTitle() {
        let form = FormDescriptor(id: "t", title: "", sections: [
            FormSectionDescriptor(id: "s1", fields: [
                FormFieldDescriptor(id: "f1", componentType: .text, title: "F"),
            ]),
        ])
        let issues = validator.validate(form)
        #expect(issues.contains(.formTitleEmpty))
    }

    @Test func noSections() {
        let form = FormDescriptor(id: "t", title: "T", sections: [])
        let issues = validator.validate(form)
        #expect(issues.contains(.noSections))
    }

    @Test func duplicateFieldIDs() {
        let form = FormDescriptor(
            id: "t",
            title: "T",
            sections: [
                FormSectionDescriptor(id: "s1", fields: [
                    FormFieldDescriptor(id: "name", componentType: .text, title: "Name"),
                    FormFieldDescriptor(id: "name", componentType: .text, title: "Name 2"),
                ]),
            ]
        )
        let issues = validator.validate(form)
        #expect(issues.contains(.duplicateFieldID(FormFieldIdentifier("name"))))
    }

    @Test func duplicateSectionIDs() {
        let form = FormDescriptor(
            id: "t",
            title: "T",
            sections: [
                FormSectionDescriptor(id: "s1", fields: [
                    FormFieldDescriptor(id: "f1", componentType: .text, title: "F"),
                ]),
                FormSectionDescriptor(id: "s1", fields: [
                    FormFieldDescriptor(id: "f2", componentType: .text, title: "F"),
                ]),
            ]
        )
        let issues = validator.validate(form)
        #expect(issues.contains(.duplicateSectionID("s1")))
    }

    @Test func selectionFieldMissingOptions() {
        let form = FormDescriptor(
            id: "t",
            title: "T",
            sections: [
                FormSectionDescriptor(id: "s1", fields: [
                    FormFieldDescriptor(id: "country", componentType: .dropdown, title: "Country"),
                ]),
            ]
        )
        let issues = validator.validate(form)
        #expect(issues.contains(.selectionFieldMissingOptions(FormFieldIdentifier("country"))))
    }

    @Test func emptyFieldTitle() {
        let form = FormDescriptor(
            id: "t",
            title: "T",
            sections: [
                FormSectionDescriptor(id: "s1", fields: [
                    FormFieldDescriptor(id: "f1", componentType: .text, title: ""),
                ]),
            ]
        )
        let issues = validator.validate(form)
        #expect(issues.contains(.fieldTitleEmpty(FormFieldIdentifier("f1"))))
    }
}
