import SwiftFormCore
import SwiftFormRenderer

/// Registry mapping LayoutType to FormLayoutEngine instances.
@MainActor
public final class BuiltInLayoutRegistry {

    private var engines: [LayoutType: any FormLayoutEngine] = [:]

    public init() {}

    /// Creates a registry pre-loaded with all built-in layout engines.
    public static func withBuiltIns() -> BuiltInLayoutRegistry {
        let registry = BuiltInLayoutRegistry()
        registry.register(CardLayout())
        registry.register(WizardLayout())
        registry.register(AccordionLayout())
        registry.register(GridLayout())
        registry.register(TabsLayout())
        registry.register(GroupedSectionsLayout())
        registry.register(StepperLayout())
        registry.register(ResponsiveGridLayout())
        return registry
    }

    public func register(_ engine: any FormLayoutEngine) {
        engines[engine.layoutType] = engine
    }

    public func engine(for type: LayoutType) -> (any FormLayoutEngine)? {
        engines[type]
    }

    public var registeredTypes: [LayoutType] {
        Array(engines.keys)
    }

    public static let supportedTypes: [LayoutType] = [
        .card, .wizard, .accordion, .grid,
        .tabs, .sections, .stepper, .responsiveGrid,
    ]
}
