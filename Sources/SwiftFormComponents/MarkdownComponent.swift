import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme

@MainActor
public struct MarkdownComponent: View {

    public let descriptor: FormFieldDescriptor
    public let store: any FormStateContainer

    public init(descriptor: FormFieldDescriptor, store: any FormStateContainer) {
        self.descriptor = descriptor
        self.store = store
    }

    @Environment(\.themeProvider) private var themeProvider

    private var tokens: any DesignTokens {
        themeProvider?.tokens ?? DefaultDesignTokens()
    }

    private var rawText: String {
        store.value(for: descriptor.id)?.stringValue
            ?? descriptor.defaultValue?.stringValue
            ?? descriptor.placeholder
            ?? descriptor.title
    }

    public var body: some View {
        FormFieldView(descriptor: descriptor, store: store) {
            VStack(alignment: .leading, spacing: tokens.spacing.xs) {
                if let attributedString = try? AttributedString(markdown: rawText) {
                    Text(attributedString)
                        .font(tokens.typography.body)
                        .foregroundStyle(tokens.colors.onBackground)
                } else {
                    Text(rawText)
                        .font(tokens.typography.body)
                        .foregroundStyle(tokens.colors.onBackground)
                }
            }
            .padding(tokens.spacing.sm)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(tokens.colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: tokens.radius.md))
        }
    }
}
