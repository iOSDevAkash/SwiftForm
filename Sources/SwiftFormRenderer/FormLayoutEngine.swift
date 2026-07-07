import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme

/// Protocol for layout engines that control how form sections are arranged.
///
/// Layout engines receive the full form descriptor, state, and registry,
/// and produce a SwiftUI view tree. The default `StackFormLayout` renders
/// sections in a vertical scroll view.
@MainActor
public protocol FormLayoutEngine {
    var layoutType: LayoutType { get }
    func body(
        descriptor: FormDescriptor,
        state: any FormStateContainer,
        registry: any ComponentRegistry,
        tokens: any DesignTokens
    ) -> AnyView
}

/// Default layout engine — vertical scroll with stacked sections.
@MainActor
public struct StackFormLayout: FormLayoutEngine {

    public let layoutType: LayoutType = .stack

    public init() {}

    public func body(
        descriptor: FormDescriptor,
        state: any FormStateContainer,
        registry: any ComponentRegistry,
        tokens: any DesignTokens
    ) -> AnyView {
        AnyView(
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
        )
    }
}
