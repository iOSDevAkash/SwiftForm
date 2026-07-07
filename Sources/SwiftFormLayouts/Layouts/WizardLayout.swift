import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme
import SwiftFormRenderer

/// Displays one section at a time with next/back navigation.
@MainActor
public struct WizardLayout: FormLayoutEngine {

    public let layoutType: LayoutType = .wizard

    public init() {}

    public func body(
        descriptor: FormDescriptor,
        state: any FormStateContainer,
        registry: any ComponentRegistry,
        tokens: any DesignTokens
    ) -> AnyView {
        AnyView(WizardLayoutBody(
            descriptor: descriptor,
            state: state,
            registry: registry,
            tokens: tokens
        ))
    }
}

@MainActor
private struct WizardLayoutBody: View {

    let descriptor: FormDescriptor
    let state: any FormStateContainer
    let registry: any ComponentRegistry
    let tokens: any DesignTokens

    @State private var currentStep = 0

    private var sections: [FormSectionDescriptor] {
        descriptor.sections
    }

    private var isFirst: Bool { currentStep == 0 }
    private var isLast: Bool { currentStep >= sections.count - 1 }

    var body: some View {
        VStack(spacing: 0) {
            stepIndicator

            ScrollView {
                if currentStep < sections.count {
                    SectionView(
                        section: sections[currentStep],
                        state: state,
                        registry: registry
                    )
                    .padding(tokens.spacing.md)
                }
            }

            navigationBar
        }
    }

    private var stepIndicator: some View {
        HStack(spacing: tokens.spacing.xs) {
            ForEach(0..<sections.count, id: \.self) { index in
                Circle()
                    .fill(index == currentStep ? tokens.colors.primary : tokens.colors.border)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(tokens.spacing.sm)
    }

    private var navigationBar: some View {
        HStack {
            if !isFirst {
                Button {
                    withAnimation { currentStep -= 1 }
                } label: {
                    HStack(spacing: tokens.spacing.xs) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundStyle(tokens.colors.primary)
                }
            }

            Spacer()

            Text("\(currentStep + 1) of \(sections.count)")
                .font(tokens.typography.caption)
                .foregroundStyle(tokens.colors.secondary)

            Spacer()

            if !isLast {
                Button {
                    withAnimation { currentStep += 1 }
                } label: {
                    HStack(spacing: tokens.spacing.xs) {
                        Text("Next")
                        Image(systemName: "chevron.right")
                    }
                    .foregroundStyle(tokens.colors.primary)
                }
            }
        }
        .padding(tokens.spacing.md)
    }
}
