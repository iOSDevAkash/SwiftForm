import Testing
@testable import SwiftFormCapture
@testable import SwiftFormSchema
import SwiftFormCore

@Suite("SwiftFormCapture")
struct SwiftFormCaptureTests {

    @Test func captureComponentProtocolExists() {
        func acceptCapture(_ component: any CaptureComponent) {
            #expect(type(of: component.requiresUIKit) == Bool.self)
        }
    }

    @Test func signatureComponentType() {
        let field = FormFieldDescriptor(
            id: "sig",
            componentType: .signature,
            title: "Signature"
        )
        #expect(field.componentType == .signature)
    }

    @Test func imagePickerComponentType() {
        let field = FormFieldDescriptor(
            id: "photo",
            componentType: .imagePicker,
            title: "Photo"
        )
        #expect(field.componentType == .imagePicker)
    }

    @Test func documentPickerComponentType() {
        let field = FormFieldDescriptor(
            id: "doc",
            componentType: .documentPicker,
            title: "Document"
        )
        #expect(field.componentType == .documentPicker)
    }

    @Test func documentPickerAllowedTypesMetadata() {
        let field = FormFieldDescriptor(
            id: "doc",
            componentType: .documentPicker,
            title: "Document",
            metadata: ["allowedTypes": .string("pdf,txt")]
        )
        let types = field.metadata?["allowedTypes"]?.stringValue
        #expect(types == "pdf,txt")
    }

    @Test func signatureMetadata() {
        let field = FormFieldDescriptor(
            id: "sig",
            componentType: .signature,
            title: "Signature",
            metadata: ["strokeColor": .string("#000000"), "lineWidth": .double(3.0)]
        )
        #expect(field.metadata?["strokeColor"]?.stringValue == "#000000")
        #expect(field.metadata?["lineWidth"]?.doubleValue == 3.0)
    }
}
