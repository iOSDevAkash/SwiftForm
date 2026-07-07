import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme

@MainActor
public struct SearchComponent: View {

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

    private var text: Binding<String> {
        Binding(
            get: { store.value(for: descriptor.id)?.stringValue ?? "" },
            set: { store.setValue(.string($0), for: descriptor.id) }
        )
    }

    public var body: some View {
        FormFieldView(descriptor: descriptor, store: store) {
            HStack(spacing: tokens.spacing.xs) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(tokens.colors.secondary)
                TextField(
                    descriptor.placeholder ?? "Search...",
                    text: text
                )
                if !text.wrappedValue.isEmpty {
                    Button {
                        store.setValue(.string(""), for: descriptor.id)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(tokens.colors.disabled)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(tokens.spacing.sm)
            .background(tokens.colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: tokens.radius.md))
        }
    }
}
