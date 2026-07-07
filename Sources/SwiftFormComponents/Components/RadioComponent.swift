import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme

@MainActor
public struct RadioComponent: View {

    public let descriptor: FormFieldDescriptor
    public let store: any FormStateContainer

    public init(descriptor: FormFieldDescriptor, store: any FormStateContainer) {
        self.descriptor = descriptor
        self.store = store
    }

    private var selection: Binding<String> {
        Binding(
            get: { store.value(for: descriptor.id)?.stringValue ?? "" },
            set: { store.setValue(.string($0), for: descriptor.id) }
        )
    }

    private var options: [FieldOption] {
        descriptor.options ?? []
    }

    @Environment(\.themeProvider) private var themeProvider

    private var tokens: any DesignTokens {
        themeProvider?.tokens ?? DefaultDesignTokens()
    }

    public var body: some View {
        FormFieldView(descriptor: descriptor, store: store) {
            VStack(alignment: .leading, spacing: tokens.spacing.xs) {
                ForEach(options) { option in
                    Button {
                        if !option.isDisabled {
                            selection.wrappedValue = option.id
                        }
                    } label: {
                        HStack(spacing: tokens.spacing.sm) {
                            Image(systemName: selection.wrappedValue == option.id ? "circle.inset.filled" : "circle")
                                .foregroundStyle(
                                    selection.wrappedValue == option.id
                                        ? tokens.colors.primary
                                        : tokens.colors.border
                                )
                            Text(option.label)
                                .foregroundStyle(
                                    option.isDisabled
                                        ? tokens.colors.disabled
                                        : tokens.colors.onBackground
                                )
                        }
                    }
                    .buttonStyle(.plain)
                    .disabled(option.isDisabled)
                }
            }
        }
    }
}
