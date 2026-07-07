import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme
import SwiftFormRenderer

/// Collapsible sections with disclosure chevron.
@MainActor
public struct AccordionLayout: FormLayoutEngine {

    public let layoutType: LayoutType = .accordion

    public init() {}

    public func body(
        descriptor: FormDescriptor,
        state: any FormStateContainer,
        registry: any ComponentRegistry,
        tokens: any DesignTokens
    ) -> AnyView {
        AnyView(AccordionLayoutBody(
            descriptor: descriptor,
            state: state,
            registry: registry,
            tokens: tokens
        ))
    }
}

@MainActor
private struct AccordionLayoutBody: View {

    let descriptor: FormDescriptor
    let state: any FormStateContainer
    let registry: any ComponentRegistry
    let tokens: any DesignTokens

    @State private var expandedSections: Set<String> = []

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 1) {
                ForEach(descriptor.sections, id: \.id) { section in
                    AccordionSectionView(
                        section: section,
                        isExpanded: expandedSections.contains(section.id),
                        state: state,
                        registry: registry,
                        tokens: tokens,
                        onToggle: { toggleSection(section.id) }
                    )
                }
            }
            .padding(tokens.spacing.md)
        }
        .onAppear {
            for section in descriptor.sections where !section.isCollapsed {
                expandedSections.insert(section.id)
            }
        }
    }

    private func toggleSection(_ id: String) {
        withAnimation(.easeInOut(duration: 0.25)) {
            if expandedSections.contains(id) {
                expandedSections.remove(id)
            } else {
                expandedSections.insert(id)
            }
        }
    }
}

@MainActor
private struct AccordionSectionView: View {

    let section: FormSectionDescriptor
    let isExpanded: Bool
    let state: any FormStateContainer
    let registry: any ComponentRegistry
    let tokens: any DesignTokens
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onToggle) {
                HStack {
                    VStack(alignment: .leading, spacing: tokens.spacing.xxs) {
                        Text(section.title ?? section.id)
                            .font(tokens.typography.headline)
                            .foregroundStyle(tokens.colors.onBackground)
                        if let subtitle = section.subtitle {
                            Text(subtitle)
                                .font(tokens.typography.caption)
                                .foregroundStyle(tokens.colors.secondary)
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .foregroundStyle(tokens.colors.secondary)
                }
                .padding(tokens.spacing.md)
                .background(tokens.colors.surface)
            }
            .buttonStyle(.plain)

            if isExpanded {
                SectionView(
                    section: section,
                    state: state,
                    registry: registry
                )
                .padding(.horizontal, tokens.spacing.md)
                .padding(.bottom, tokens.spacing.md)
                .background(tokens.colors.background)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: tokens.radius.sm))
    }
}
