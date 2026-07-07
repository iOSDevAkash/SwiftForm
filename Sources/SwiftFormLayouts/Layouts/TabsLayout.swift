import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme
import SwiftFormRenderer

/// Renders sections as tabs using TabView.
@MainActor
public struct TabsLayout: FormLayoutEngine {

    public let layoutType: LayoutType = .tabs

    public init() {}

    public func body(
        descriptor: FormDescriptor,
        state: any FormStateContainer,
        registry: any ComponentRegistry,
        tokens: any DesignTokens
    ) -> AnyView {
        AnyView(TabsLayoutBody(
            descriptor: descriptor,
            state: state,
            registry: registry,
            tokens: tokens
        ))
    }
}

@MainActor
private struct TabsLayoutBody: View {

    let descriptor: FormDescriptor
    let state: any FormStateContainer
    let registry: any ComponentRegistry
    let tokens: any DesignTokens

    @State private var selectedTab: String?

    var body: some View {
        VStack(spacing: 0) {
            tabBar
            tabContent
        }
        .onAppear {
            if selectedTab == nil {
                selectedTab = descriptor.sections.first?.id
            }
        }
    }

    private var tabBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(descriptor.sections, id: \.id) { section in
                    Button {
                        withAnimation { selectedTab = section.id }
                    } label: {
                        Text(section.title ?? section.id)
                            .font(tokens.typography.headline)
                            .foregroundStyle(
                                selectedTab == section.id
                                    ? tokens.colors.primary
                                    : tokens.colors.secondary
                            )
                            .padding(.horizontal, tokens.spacing.md)
                            .padding(.vertical, tokens.spacing.sm)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .overlay(alignment: .bottom) {
            Divider()
        }
    }

    private var tabContent: some View {
        ScrollView {
            if let tab = selectedTab,
               let section = descriptor.sections.first(where: { $0.id == tab }) {
                SectionView(
                    section: section,
                    state: state,
                    registry: registry
                )
                .padding(tokens.spacing.md)
            }
        }
    }
}
