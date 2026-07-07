import Testing
@testable import SwiftFormState
@testable import SwiftFormSchema
import SwiftFormCore

@Suite("FormStateStore")
struct FormStateStoreTests {

    @MainActor
    @Test func registerField() {
        let store = FormStateStore()
        store.register(id: "name", initialValue: .string("John"))
        #expect(store.value(for: "name")?.stringValue == "John")
    }

    @MainActor
    @Test func registerFromSchema() {
        let form = FormDescriptor(
            id: "test",
            title: "Test",
            sections: [
                FormSectionDescriptor(id: "s1", fields: [
                    FormFieldDescriptor(id: "name", componentType: .text, title: "Name", defaultValue: .string("Default")),
                    FormFieldDescriptor(id: "email", componentType: .email, title: "Email"),
                ]),
            ]
        )
        let store = FormStateStore()
        store.register(from: form)

        #expect(store.fieldIdentifiers.count == 2)
        #expect(store.value(for: "name")?.stringValue == "Default")
        #expect(store.value(for: "email") == nil)
    }

    @MainActor
    @Test func setAndGetValue() {
        let store = FormStateStore()
        store.register(id: "age")
        store.setValue(.int(25), for: "age")
        #expect(store.value(for: "age")?.intValue == 25)
    }

    @MainActor
    @Test func dirtyTracking() {
        let store = FormStateStore()
        store.register(id: "name")
        #expect(store.isDirty == false)

        store.setValue(.string("test"), for: "name")
        #expect(store.isDirty == true)
        #expect(store.isDirty("name") == true)

        store.markClean()
        #expect(store.isDirty == false)
    }

    @MainActor
    @Test func interactionState() {
        let store = FormStateStore()
        store.register(id: "field")
        #expect(store.interactionState(for: "field") == .normal)

        store.setInteractionState(.focused, for: "field")
        #expect(store.interactionState(for: "field") == .focused)
    }

    @MainActor
    @Test func validationState() {
        let store = FormStateStore()
        store.register(id: "email")

        store.setValidation(isValid: false, messages: ["Invalid email"], for: "email")
        #expect(store.isValid(for: "email") == false)
        #expect(store.validationMessages(for: "email") == ["Invalid email"])
        #expect(store.allValid == false)
    }

    @MainActor
    @Test func allValues() {
        let store = FormStateStore()
        store.register(id: "a", initialValue: .string("1"))
        store.register(id: "b", initialValue: .int(2))
        store.register(id: "c")

        let values = store.allValues()
        #expect(values.count == 2)
        #expect(values[FormFieldIdentifier("a")]?.stringValue == "1")
    }

    @MainActor
    @Test func reset() {
        let store = FormStateStore()
        store.register(id: "name")
        store.setValue(.string("test"), for: "name")
        store.setInteractionState(.error, for: "name")

        store.reset()
        #expect(store.value(for: "name") == nil)
        #expect(store.interactionState(for: "name") == .normal)
        #expect(store.isDirty == false)
    }

    @MainActor
    @Test func resetToValues() {
        let store = FormStateStore()
        store.register(id: "name")
        store.register(id: "age")

        store.reset(to: ["name": .string("John"), "age": .int(30)])
        #expect(store.value(for: "name")?.stringValue == "John")
        #expect(store.isDirty == false)
    }

    @MainActor
    @Test func nonexistentFieldReturnsDefaults() {
        let store = FormStateStore()
        #expect(store.value(for: "ghost") == nil)
        #expect(store.interactionState(for: "ghost") == .normal)
        #expect(store.isValid(for: "ghost") == true)
    }
}
