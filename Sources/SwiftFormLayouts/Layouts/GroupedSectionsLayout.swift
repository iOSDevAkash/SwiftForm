import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme
import SwiftFormRenderer

/// iOS Settings style — inset grouped sections with system background.
@MainActor
public struct GroupedSectionsLayout: FormLayoutEngine {

    public let layoutType: LayoutType = .sections

    public init() {}

    public func body(
        descriptor: FormDescriptor,
        state: any FormStateContainer,
        registry: any ComponentRegistry,
        tokens: any DesignTokens
    ) -> AnyView {
        AnyView(GroupedSectionsBody(
            descriptor: descriptor,
            state: state,
            registry: registry,
            tokens: tokens
        ))
    }
}

@MainActor
private struct GroupedSectionsBody: View {

    let descriptor: FormDescriptor
    let state: any FormStateContainer
    let registry: any ComponentRegistry
    let tokens: any DesignTokens

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: tokens.spacing.lg) {
                ForEach(descriptor.sections, id: \.id) { section in
                    VStack(alignment: .leading, spacing: tokens.spacing.xs) {
                        if let title = section.title {
                            Text(title.uppercased())
                                .font(tokens.typography.footnote)
                                .foregroundStyle(tokens.colors.secondary)
                                .padding(.horizontal, tokens.spacing.md)
                        }

                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(Array(section.fields.enumerated()), id: \.element.id) { index, field in
                                if let factory = registry.factory(for: field.componentType),
                                   let view = factory.makeView(for: field, state: state) {
                                    view
                                        .padding(.horizontal, tokens.spacing.md)
                                        .padding(.vertical, tokens.spacing.sm)
                                    if index < section.fields.count - 1 {
                                        Divider()
                                            .padding(.leading, tokens.spacing.md)
                                    }
                                }
                            }
                        }
                        .background(tokens.colors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: tokens.radius.md))

                        if let subtitle = section.subtitle {
                            Text(subtitle)
                                .font(tokens.typography.footnote)
                                .foregroundStyle(tokens.colors.secondary)
                                .padding(.horizontal, tokens.spacing.md)
                        }
                    }
                }
            }
            .padding(tokens.spacing.md)
        }
        .background(tokens.colors.background)
    }
}
