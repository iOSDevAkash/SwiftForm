import Testing
import SwiftUI
@testable import SwiftFormRenderer
@testable import SwiftFormComponents
@testable import SwiftFormState
import SwiftFormSchema
import SwiftFormCore

@Suite("SwiftFormRenderer")
struct SwiftFormRendererTests {

    @Test func componentFactoryProtocolExists() {
        func acceptFactory(_ factory: any ComponentFactory) {
            _ = factory
        }
    }

    @Test func componentRegistryProtocolExists() {
        func acceptRegistry(_ registry: any ComponentRegistry) {
            _ = registry
        }
    }

    @Test func formRendererProtocolExists() {
        func acceptRenderer(_ renderer: any FormRenderer) {
            _ = renderer
        }
    }

    @MainActor
    @Test func builtInFactoryCoversAllTypes() {
        let factory = BuiltInComponentFactory()
        let store = FormStateStore()
        let types = BuiltInComponentFactory.supportedTypes

        for type in types {
            let descriptor = FormFieldDescriptor(
                id: FormFieldIdentifier(type.rawValue),
                componentType: type,
                title: "Test \(type.rawValue)"
            )
            store.register(id: descriptor.id)
            let view = factory.makeView(for: descriptor, state: store)
            #expect(view != nil, "Factory should produce view for \(type.rawValue)")
        }
    }

    @MainActor
    @Test func builtInFactoryReturnsNilForUnknown() {
        let factory = BuiltInComponentFactory()
        let store = FormStateStore()
        let descriptor = FormFieldDescriptor(
            id: "custom",
            componentType: ComponentType("myCustomWidget"),
            title: "Custom"
        )
        store.register(id: descriptor.id)
        let view = factory.makeView(for: descriptor, state: store)
        #expect(view == nil)
    }

    @MainActor
    @Test func defaultRegistryWithBuiltIns() {
        let registry = DefaultComponentRegistry.withBuiltIns()
        #expect(registry.factory(for: .text) != nil)
        #expect(registry.factory(for: .toggle) != nil)
        #expect(registry.factory(for: .slider) != nil)
        #expect(registry.factory(for: .rating) != nil)
        #expect(registry.registeredTypes.count == 24)
    }

    @MainActor
    @Test func defaultRendererProducesView() {
        let renderer = DefaultFormRenderer()
        let store = FormStateStore()
        let schema = FormDescriptor(
            id: "test",
            title: "Test Form",
            sections: [
                FormSectionDescriptor(
                    id: "s1",
                    title: "Section 1",
                    fields: [
                        FormFieldDescriptor(
                            id: "name",
                            componentType: .text,
                            title: "Name"
                        ),
                    ]
                ),
            ]
        )
        store.register(from: schema)
        let view = renderer.render(schema: schema, state: store)
        #expect(type(of: view) == AnyView.self)
    }

    @MainActor
    @Test func formViewInstantiation() {
        let schema = FormDescriptor(
            id: "test",
            title: "Test Form",
            sections: [
                FormSectionDescriptor(
                    id: "s1",
                    fields: [
                        FormFieldDescriptor(
                            id: "email",
                            componentType: .email,
                            title: "Email"
                        ),
                    ]
                ),
            ]
        )
        let formView = FormView(schema: schema)
        #expect(type(of: formView) == FormView.self)
    }

    @MainActor
    @Test func formViewWithSubmit() {
        let schema = FormDescriptor(
            id: "test",
            title: "Submit Test",
            sections: [],
            submitTitle: "Send"
        )
        var submitted = false
        let formView = FormView(schema: schema) { _ in
            submitted = true
        }
        #expect(type(of: formView) == FormView.self)
        #expect(!submitted)
    }
}
