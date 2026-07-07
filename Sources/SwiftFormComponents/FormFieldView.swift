import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme

/// Shared chrome wrapper for form fields: title, required indicator, subtitle,
/// validation messages, and interaction state handling.
@MainActor
public struct FormFieldView<Content: View>: View {

    let descriptor: FormFieldDescriptor
    let store: any FormStateContainer
    @ViewBuilder let content: () -> Content

    public init(
        descriptor: FormFieldDescriptor,
        store: any FormStateContainer,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.descriptor = descriptor
        self.store = store
        self.content = content
    }

    @Environment(\.themeProvider) private var themeProvider

    private var tokens: any DesignTokens {
        themeProvider?.tokens ?? DefaultDesignTokens()
    }

    private var interactionState: InteractionState {
        store.interactionState(for: descriptor.id)
    }

    private var isHidden: Bool {
        interactionState == .hidden
    }

    private var isDisabled: Bool {
        interactionState == .disabled || interactionState == .readOnly
    }

    public var body: some View {
        if !isHidden {
            VStack(alignment: .leading, spacing: tokens.spacing.xs) {
                titleRow
                if let subtitle = descriptor.subtitle {
                    Text(subtitle)
                        .font(tokens.typography.caption)
                        .foregroundStyle(tokens.colors.secondary)
                }
                content()
                    .disabled(isDisabled)
                validationMessages
            }
        }
    }

    @ViewBuilder
    private var titleRow: some View {
        HStack(spacing: tokens.spacing.xxs) {
            Text(descriptor.title)
                .font(tokens.typography.headline)
                .foregroundStyle(tokens.colors.onBackground)
            if descriptor.isRequired {
                Text("*")
                    .foregroundStyle(tokens.colors.error)
                    .font(tokens.typography.headline)
            }
        }
    }

    @ViewBuilder
    private var validationMessages: some View {
        let messages = store.validationMessages(for: descriptor.id)
        if !messages.isEmpty {
            VStack(alignment: .leading, spacing: 2) {
                ForEach(messages, id: \.self) { message in
                    Text(message)
                        .font(tokens.typography.caption)
                        .foregroundStyle(store.isValid(for: descriptor.id) ? tokens.colors.warning : tokens.colors.error)
                }
            }
        }
    }
}
