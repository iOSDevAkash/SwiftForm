import Testing
import SwiftUI
@testable import SwiftFormComponents
@testable import SwiftFormRenderer
@testable import SwiftFormState
import SwiftFormSchema
import SwiftFormCore

@Suite("SwiftFormComponents")
struct SwiftFormComponentsTests {

    @Test func componentConfigurationCreation() {
        let config = ComponentConfiguration(
            id: "email",
            componentType: .email,
            isRequired: true
        )
        #expect(config.id.rawValue == "email")
        #expect(config.componentType == .email)
        #expect(config.isRequired == true)
        #expect(config.isDisabled == false)
    }

    @Test func formComponentProtocolExists() {
        func acceptComponent(_ component: any FormComponent) {
            _ = component.componentType
        }
    }

    @MainActor
    @Test func textFieldComponentCreation() {
        let descriptor = FormFieldDescriptor(
            id: "name",
            componentType: .text,
            title: "Name",
            placeholder: "Enter name"
        )
        let store = FormStateStore()
        store.register(id: descriptor.id)
        let component = TextFieldComponent(descriptor: descriptor, store: store)
        #expect(component.descriptor.title == "Name")
    }

    @MainActor
    @Test func toggleComponentCreation() {
        let descriptor = FormFieldDescriptor(
            id: "active",
            componentType: .toggle,
            title: "Active"
        )
        let store = FormStateStore()
        store.register(id: descriptor.id, initialValue: .bool(true))
        let component = ToggleComponent(descriptor: descriptor, store: store)
        #expect(component.descriptor.componentType == .toggle)
    }

    @MainActor
    @Test func ratingComponentCreation() {
        let descriptor = FormFieldDescriptor(
            id: "stars",
            componentType: .rating,
            title: "Rating"
        )
        let store = FormStateStore()
        store.register(id: descriptor.id)
        let component = RatingComponent(descriptor: descriptor, store: store)
        #expect(component.descriptor.title == "Rating")
    }

    @MainActor
    @Test func formFieldViewWrapsContent() {
        let descriptor = FormFieldDescriptor(
            id: "email",
            componentType: .email,
            title: "Email",
            isRequired: true
        )
        let store = FormStateStore()
        store.register(id: descriptor.id)
        let view = FormFieldView(descriptor: descriptor, store: store) {
            Text("inner")
        }
        #expect(view.descriptor.isRequired)
    }
}
