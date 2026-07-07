import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme
import SwiftFormRenderer

/// Sequential wizard with a numbered progress bar.
@MainActor
public struct StepperLayout: FormLayoutEngine {

    public let layoutType: LayoutType = .stepper

    public init() {}

    public func body(
        descriptor: FormDescriptor,
        state: any FormStateContainer,
        registry: any ComponentRegistry,
        tokens: any DesignTokens
    ) -> AnyView {
        AnyView(StepperLayoutBody(
            descriptor: descriptor,
            state: state,
            registry: registry,
            tokens: tokens
        ))
    }
}

@MainActor
private struct StepperLayoutBody: View {

    let descriptor: FormDescriptor
    let state: any FormStateContainer
    let registry: any ComponentRegistry
    let tokens: any DesignTokens

    @State private var currentStep = 0

    private var sections: [FormSectionDescriptor] {
        descriptor.sections
    }

    var body: some View {
        VStack(spacing: 0) {
            progressBar
            sectionTitle

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

            navigationButtons
        }
    }

    private var progressBar: some View {
        HStack(spacing: tokens.spacing.xxs) {
            ForEach(0..<sections.count, id: \.self) { index in
                HStack(spacing: tokens.spacing.xxs) {
                    ZStack {
                        Circle()
                            .fill(index <= currentStep ? tokens.colors.primary : tokens.colors.border)
                            .frame(width: 28, height: 28)
                        Text("\(index + 1)")
                            .font(tokens.typography.caption)
                            .foregroundStyle(index <= currentStep ? tokens.colors.onPrimary : tokens.colors.secondary)
                    }
                    if index < sections.count - 1 {
                        Rectangle()
                            .fill(index < currentStep ? tokens.colors.primary : tokens.colors.border)
                            .frame(height: 2)
                    }
                }
            }
        }
        .padding(.horizontal, tokens.spacing.lg)
        .padding(.vertical, tokens.spacing.sm)
    }

    private var sectionTitle: some View {
        VStack(spacing: tokens.spacing.xxs) {
            if currentStep < sections.count, let title = sections[currentStep].title {
                Text(title)
                    .font(tokens.typography.title)
                    .foregroundStyle(tokens.colors.onBackground)
            }
        }
        .padding(.bottom, tokens.spacing.sm)
    }

    private var navigationButtons: some View {
        HStack {
            if currentStep > 0 {
                Button {
                    withAnimation { currentStep -= 1 }
                } label: {
                    Text("Back")
                        .font(tokens.typography.body)
                        .foregroundStyle(tokens.colors.primary)
                        .padding(.horizontal, tokens.spacing.lg)
                        .padding(.vertical, tokens.spacing.sm)
                        .overlay(
                            RoundedRectangle(cornerRadius: tokens.radius.md)
                                .stroke(tokens.colors.primary, lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }

            Spacer()

            if currentStep < sections.count - 1 {
                Button {
                    withAnimation { currentStep += 1 }
                } label: {
                    Text("Next")
                        .font(tokens.typography.body)
                        .foregroundStyle(tokens.colors.onPrimary)
                        .padding(.horizontal, tokens.spacing.lg)
                        .padding(.vertical, tokens.spacing.sm)
                        .background(tokens.colors.primary)
                        .clipShape(RoundedRectangle(cornerRadius: tokens.radius.md))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(tokens.spacing.md)
    }
}
