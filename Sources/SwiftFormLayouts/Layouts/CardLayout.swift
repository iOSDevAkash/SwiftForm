import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme
import SwiftFormRenderer

/// Renders each section as a card with rounded corners and shadow.
@MainActor
public struct CardLayout: FormLayoutEngine {

    public let layoutType: LayoutType = .card

    public init() {}

    public func body(
        descriptor: FormDescriptor,
        state: any FormStateContainer,
        registry: any ComponentRegistry,
        tokens: any DesignTokens
    ) -> AnyView {
        AnyView(CardLayoutBody(
            descriptor: descriptor,
            state: state,
            registry: registry,
            tokens: tokens
        ))
    }
}

@MainActor
private struct CardLayoutBody: View {

    let descriptor: FormDescriptor
    let state: any FormStateContainer
    let registry: any ComponentRegistry
    let tokens: any DesignTokens

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: tokens.spacing.lg) {
                ForEach(descriptor.sections, id: \.id) { section in
                    VStack(alignment: .leading, spacing: 0) {
                        SectionView(
                            section: section,
                            state: state,
                            registry: registry
                        )
                        .padding(tokens.spacing.md)
                    }
                    .background(tokens.colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: tokens.radius.md))
                    .shadow(radius: tokens.elevation.sm)
                }
            }
            .padding(tokens.spacing.md)
        }
    }
}
