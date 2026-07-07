import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme
import SwiftFormRenderer

/// Arranges fields in a fixed 2-column grid within each section.
@MainActor
public struct GridLayout: FormLayoutEngine {

    public let layoutType: LayoutType = .grid
    public let columns: Int

    public init(columns: Int = 2) {
        self.columns = max(1, columns)
    }

    public func body(
        descriptor: FormDescriptor,
        state: any FormStateContainer,
        registry: any ComponentRegistry,
        tokens: any DesignTokens
    ) -> AnyView {
        AnyView(GridLayoutBody(
            descriptor: descriptor,
            state: state,
            registry: registry,
            tokens: tokens,
            columns: columns
        ))
    }
}

@MainActor
private struct GridLayoutBody: View {

    let descriptor: FormDescriptor
    let state: any FormStateContainer
    let registry: any ComponentRegistry
    let tokens: any DesignTokens
    let columns: Int

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: tokens.spacing.md), count: columns)
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: tokens.spacing.lg) {
                ForEach(descriptor.sections, id: \.id) { section in
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

                        LazyVGrid(columns: gridColumns, alignment: .leading, spacing: tokens.spacing.md) {
                            ForEach(section.fields, id: \.id) { field in
                                if let factory = registry.factory(for: field.componentType),
                                   let view = factory.makeView(for: field, state: state) {
                                    view
                                }
                            }
                        }
                    }
                }
            }
            .padding(tokens.spacing.md)
        }
    }
}
