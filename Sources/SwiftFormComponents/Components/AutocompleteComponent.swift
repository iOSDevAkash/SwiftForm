import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme

@MainActor
public struct AutocompleteComponent: View {

    public let descriptor: FormFieldDescriptor
    public let store: any FormStateContainer

    public init(descriptor: FormFieldDescriptor, store: any FormStateContainer) {
        self.descriptor = descriptor
        self.store = store
    }

    @Environment(\.themeProvider) private var themeProvider
    @State private var isShowingSuggestions = false

    private var tokens: any DesignTokens {
        themeProvider?.tokens ?? DefaultDesignTokens()
    }

    private var options: [FieldOption] {
        descriptor.options ?? []
    }

    private var text: Binding<String> {
        Binding(
            get: { store.value(for: descriptor.id)?.stringValue ?? "" },
            set: { newValue in
                store.setValue(.string(newValue), for: descriptor.id)
                isShowingSuggestions = !newValue.isEmpty
            }
        )
    }

    private var filteredOptions: [FieldOption] {
        let query = text.wrappedValue.lowercased()
        guard !query.isEmpty else { return [] }
        return options.filter { $0.label.lowercased().contains(query) }
    }

    public var body: some View {
        FormFieldView(descriptor: descriptor, store: store) {
            VStack(alignment: .leading, spacing: 0) {
                TextField(
                    descriptor.placeholder ?? "Type to search...",
                    text: text
                )
                .textFieldStyle(.roundedBorder)

                if isShowingSuggestions && !filteredOptions.isEmpty {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(filteredOptions.prefix(5)) { option in
                            Button {
                                store.setValue(.string(option.id), for: descriptor.id)
                                isShowingSuggestions = false
                            } label: {
                                Text(option.label)
                                    .font(tokens.typography.body)
                                    .foregroundStyle(tokens.colors.onBackground)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, tokens.spacing.sm)
                                    .padding(.vertical, tokens.spacing.xs)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .background(tokens.colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: tokens.radius.sm))
                    .overlay(
                        RoundedRectangle(cornerRadius: tokens.radius.sm)
                            .stroke(tokens.colors.border, lineWidth: 1)
                    )
                }
            }
        }
    }
}
