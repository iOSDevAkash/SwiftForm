import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme
import SwiftFormComponents

/// Concrete component registry backed by a dictionary.
@MainActor
public final class DefaultComponentRegistry: ComponentRegistry {

    private var factories: [ComponentType: any ComponentFactory] = [:]

    public init() {}

    /// Creates a registry pre-loaded with all built-in component factories.
    public static func withBuiltIns() -> DefaultComponentRegistry {
        let registry = DefaultComponentRegistry()
        let factory = BuiltInComponentFactory()
        for type in BuiltInComponentFactory.supportedTypes {
            registry.register(type, factory: factory)
        }
        return registry
    }

    public func register(_ type: ComponentType, factory: any ComponentFactory) {
        factories[type] = factory
    }

    public func factory(for type: ComponentType) -> (any ComponentFactory)? {
        factories[type]
    }

    public var registeredTypes: [ComponentType] {
        Array(factories.keys)
    }
}

/// Default renderer that uses a component registry to build the view tree.
@MainActor
public final class DefaultFormRenderer: FormRenderer {

    private let registry: any ComponentRegistry
    private let layout: any FormLayoutEngine

    public init(registry: any ComponentRegistry, layout: (any FormLayoutEngine)? = nil) {
        self.registry = registry
        self.layout = layout ?? StackFormLayout()
    }

    public convenience init(layout: (any FormLayoutEngine)? = nil) {
        self.init(registry: DefaultComponentRegistry.withBuiltIns(), layout: layout)
    }

    public func render(schema: any FormSchema, state: any FormStateContainer) -> AnyView {
        guard let descriptor = schema as? FormDescriptor else {
            return AnyView(Text("Unsupported schema type"))
        }

        return AnyView(ThemedLayoutView(
            descriptor: descriptor,
            state: state,
            registry: registry,
            layout: layout
        ))
    }
}

/// Internal view that renders the full form content.
@MainActor
struct FormContentView: View {

    let descriptor: FormDescriptor
    let state: any FormStateContainer
    let registry: any ComponentRegistry

    @Environment(\.themeProvider) private var themeProvider

    private var tokens: any DesignTokens {
        themeProvider?.tokens ?? DefaultDesignTokens()
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: tokens.spacing.lg) {
                ForEach(descriptor.sections, id: \.id) { section in
                    SectionView(
                        section: section,
                        state: state,
                        registry: registry
                    )
                }
            }
            .padding(tokens.spacing.md)
        }
    }
}

/// Renders a single form section with title, subtitle, and fields.
///
/// Layout engines reuse this view to render fields within their arrangement.
@MainActor
public struct SectionView: View {

    public let section: FormSectionDescriptor
    public let state: any FormStateContainer
    public let registry: any ComponentRegistry

    public init(
        section: FormSectionDescriptor,
        state: any FormStateContainer,
        registry: any ComponentRegistry
    ) {
        self.section = section
        self.state = state
        self.registry = registry
    }

    @Environment(\.themeProvider) private var themeProvider

    private var tokens: any DesignTokens {
        themeProvider?.tokens ?? DefaultDesignTokens()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: tokens.spacing.md) {
            if let title = section.title {
                Text(title)
                    .font(tokens.typography.title)
                    .foregroundStyle(tokens.colors.onBackground)
            }
            if let subtitle = section.subtitle {
                Text(subtitle)
                    .font(tokens.typography.caption)
                    .foregroundStyle(tokens.colors.secondary)
            }

            ForEach(section.fields, id: \.id) { field in
                if let factory = registry.factory(for: field.componentType),
                   let view = factory.makeView(for: field, state: state) {
                    view
                } else {
                    UnsupportedFieldView(field: field)
                }
            }
        }
    }
}

@MainActor
struct ThemedLayoutView: View {

    let descriptor: FormDescriptor
    let state: any FormStateContainer
    let registry: any ComponentRegistry
    let layout: any FormLayoutEngine

    @Environment(\.themeProvider) private var themeProvider

    private var tokens: any DesignTokens {
        themeProvider?.tokens ?? DefaultDesignTokens()
    }

    var body: some View {
        layout.body(
            descriptor: descriptor,
            state: state,
            registry: registry,
            tokens: tokens
        )
    }
}

/// Placeholder shown when no factory is registered for a component type.
struct UnsupportedFieldView: View {
    let field: FormFieldDescriptor

    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle")
                .foregroundStyle(.orange)
            Text("Unsupported: \(field.componentType.rawValue)")
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
