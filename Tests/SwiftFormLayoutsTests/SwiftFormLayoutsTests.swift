import Testing
import SwiftUI
import Foundation
@testable import SwiftFormLayouts
@testable import SwiftFormRenderer
@testable import SwiftFormState
import SwiftFormSchema
import SwiftFormCore
import SwiftFormTheme

@Suite("SwiftFormLayouts")
struct SwiftFormLayoutsTests {

    @Test func layoutTypeCreation() {
        let type = LayoutType("custom_layout")
        #expect(type.rawValue == "custom_layout")
    }

    @Test func builtInLayoutTypes() {
        #expect(LayoutType.form.rawValue == "form")
        #expect(LayoutType.wizard.rawValue == "wizard")
        #expect(LayoutType.grid.rawValue == "grid")
        #expect(LayoutType.tabs.rawValue == "tabs")
        #expect(LayoutType.card.rawValue == "card")
        #expect(LayoutType.accordion.rawValue == "accordion")
        #expect(LayoutType.stepper.rawValue == "stepper")
        #expect(LayoutType.sections.rawValue == "sections")
        #expect(LayoutType.responsiveGrid.rawValue == "responsiveGrid")
        #expect(LayoutType.stack.rawValue == "stack")
    }

    @Test func formLayoutProtocolExists() {
        func acceptLayout(_ layout: any FormLayout) {
            _ = layout.layoutType
        }
    }

    @Test func layoutTypeStringLiteral() {
        let type: LayoutType = "myLayout"
        #expect(type.rawValue == "myLayout")
    }

    @Test func layoutTypeCodable() throws {
        let type = LayoutType.wizard
        let data = try JSONEncoder().encode(type)
        let decoded = try JSONDecoder().decode(LayoutType.self, from: data)
        #expect(decoded == type)
        let json = String(data: data, encoding: .utf8)
        #expect(json == "\"wizard\"")
    }

    @MainActor
    @Test func formLayoutEngineProtocolExists() {
        func acceptEngine(_ engine: any FormLayoutEngine) {
            _ = engine.layoutType
        }
    }

    // MARK: - Layout Engines

    @MainActor
    @Test func stackLayoutProducesView() {
        let layout = StackFormLayout()
        #expect(layout.layoutType == .stack)
        let view = layout.body(
            descriptor: makeSchema(),
            state: makeStore(),
            registry: DefaultComponentRegistry.withBuiltIns(),
            tokens: DefaultDesignTokens()
        )
        #expect(type(of: view) == AnyView.self)
    }

    @MainActor
    @Test func cardLayoutProducesView() {
        let layout = CardLayout()
        #expect(layout.layoutType == .card)
        let view = layout.body(
            descriptor: makeSchema(),
            state: makeStore(),
            registry: DefaultComponentRegistry.withBuiltIns(),
            tokens: DefaultDesignTokens()
        )
        #expect(type(of: view) == AnyView.self)
    }

    @MainActor
    @Test func wizardLayoutProducesView() {
        let layout = WizardLayout()
        #expect(layout.layoutType == .wizard)
        let view = layout.body(
            descriptor: makeSchema(),
            state: makeStore(),
            registry: DefaultComponentRegistry.withBuiltIns(),
            tokens: DefaultDesignTokens()
        )
        #expect(type(of: view) == AnyView.self)
    }

    @MainActor
    @Test func accordionLayoutProducesView() {
        let layout = AccordionLayout()
        #expect(layout.layoutType == .accordion)
        let view = layout.body(
            descriptor: makeSchema(),
            state: makeStore(),
            registry: DefaultComponentRegistry.withBuiltIns(),
            tokens: DefaultDesignTokens()
        )
        #expect(type(of: view) == AnyView.self)
    }

    @MainActor
    @Test func gridLayoutProducesView() {
        let layout = GridLayout(columns: 3)
        #expect(layout.layoutType == .grid)
        let view = layout.body(
            descriptor: makeSchema(),
            state: makeStore(),
            registry: DefaultComponentRegistry.withBuiltIns(),
            tokens: DefaultDesignTokens()
        )
        #expect(type(of: view) == AnyView.self)
    }

    @MainActor
    @Test func gridLayoutMinOneColumn() {
        let layout = GridLayout(columns: 0)
        let view = layout.body(
            descriptor: makeSchema(),
            state: makeStore(),
            registry: DefaultComponentRegistry.withBuiltIns(),
            tokens: DefaultDesignTokens()
        )
        #expect(type(of: view) == AnyView.self)
    }

    @MainActor
    @Test func tabsLayoutProducesView() {
        let layout = TabsLayout()
        #expect(layout.layoutType == .tabs)
        let view = layout.body(
            descriptor: makeSchema(),
            state: makeStore(),
            registry: DefaultComponentRegistry.withBuiltIns(),
            tokens: DefaultDesignTokens()
        )
        #expect(type(of: view) == AnyView.self)
    }

    @MainActor
    @Test func groupedSectionsLayoutProducesView() {
        let layout = GroupedSectionsLayout()
        #expect(layout.layoutType == .sections)
        let view = layout.body(
            descriptor: makeSchema(),
            state: makeStore(),
            registry: DefaultComponentRegistry.withBuiltIns(),
            tokens: DefaultDesignTokens()
        )
        #expect(type(of: view) == AnyView.self)
    }

    @MainActor
    @Test func stepperLayoutProducesView() {
        let layout = StepperLayout()
        #expect(layout.layoutType == .stepper)
        let view = layout.body(
            descriptor: makeSchema(),
            state: makeStore(),
            registry: DefaultComponentRegistry.withBuiltIns(),
            tokens: DefaultDesignTokens()
        )
        #expect(type(of: view) == AnyView.self)
    }

    @MainActor
    @Test func responsiveGridLayoutProducesView() {
        let layout = ResponsiveGridLayout(minColumnWidth: 200)
        #expect(layout.layoutType == .responsiveGrid)
        let view = layout.body(
            descriptor: makeSchema(),
            state: makeStore(),
            registry: DefaultComponentRegistry.withBuiltIns(),
            tokens: DefaultDesignTokens()
        )
        #expect(type(of: view) == AnyView.self)
    }

    // MARK: - BuiltInLayoutRegistry

    @MainActor
    @Test func registryWithBuiltIns() {
        let registry = BuiltInLayoutRegistry.withBuiltIns()
        #expect(registry.registeredTypes.count == 8)
        #expect(registry.engine(for: .card) != nil)
        #expect(registry.engine(for: .wizard) != nil)
        #expect(registry.engine(for: .accordion) != nil)
        #expect(registry.engine(for: .grid) != nil)
        #expect(registry.engine(for: .tabs) != nil)
        #expect(registry.engine(for: .sections) != nil)
        #expect(registry.engine(for: .stepper) != nil)
        #expect(registry.engine(for: .responsiveGrid) != nil)
    }

    @MainActor
    @Test func registryReturnsNilForUnknown() {
        let registry = BuiltInLayoutRegistry()
        #expect(registry.engine(for: .wizard) == nil)
    }

    @MainActor
    @Test func registrySupportedTypes() {
        #expect(BuiltInLayoutRegistry.supportedTypes.count == 8)
    }

    // MARK: - FormView Integration

    @MainActor
    @Test func formViewWithLayout() {
        let schema = makeSchema()
        let formView = FormView(schema: schema, layout: CardLayout())
        #expect(type(of: formView) == FormView.self)
    }

    @MainActor
    @Test func formViewWithWizardLayout() {
        let schema = makeSchema()
        let formView = FormView(schema: schema, layout: WizardLayout())
        #expect(type(of: formView) == FormView.self)
    }

    @MainActor
    @Test func defaultRendererWithLayout() {
        let renderer = DefaultFormRenderer(layout: AccordionLayout())
        let schema = makeSchema()
        let store = makeStore()
        let view = renderer.render(schema: schema, state: store)
        #expect(type(of: view) == AnyView.self)
    }

    // MARK: - Helpers

    @MainActor
    private func makeSchema() -> FormDescriptor {
        FormDescriptor(
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
                        FormFieldDescriptor(
                            id: "email",
                            componentType: .email,
                            title: "Email"
                        ),
                    ],
                    isCollapsible: true
                ),
                FormSectionDescriptor(
                    id: "s2",
                    title: "Section 2",
                    fields: [
                        FormFieldDescriptor(
                            id: "toggle",
                            componentType: .toggle,
                            title: "Active"
                        ),
                    ]
                ),
            ]
        )
    }

    @MainActor
    private func makeStore() -> FormStateStore {
        let store = FormStateStore()
        store.register(id: "name")
        store.register(id: "email")
        store.register(id: "toggle")
        return store
    }
}
