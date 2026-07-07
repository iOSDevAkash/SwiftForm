import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme
import SwiftFormRenderer

/// Grid layout that adapts column count based on available width.
@MainActor
public struct ResponsiveGridLayout: FormLayoutEngine {

    public let layoutType: LayoutType = .responsiveGrid
    public let minColumnWidth: CGFloat

    public init(minColumnWidth: CGFloat = 300) {
        self.minColumnWidth = max(150, minColumnWidth)
    }

    public func body(
        descriptor: FormDescriptor,
        state: any FormStateContainer,
        registry: any ComponentRegistry,
        tokens: any DesignTokens
    ) -> AnyView {
        AnyView(ResponsiveGridBody(
            descriptor: descriptor,
            state: state,
            registry: registry,
            tokens: tokens,
            minColumnWidth: minColumnWidth
        ))
    }
}

@MainActor
private struct ResponsiveGridBody: View {

    let descriptor: FormDescriptor
    let state: any FormStateContainer
    let registry: any ComponentRegistry
    let tokens: any DesignTokens
    let minColumnWidth: CGFloat

    private var gridColumns: [GridItem] {
        [GridItem(.adaptive(minimum: minColumnWidth), spacing: tokens.spacing.md)]
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
