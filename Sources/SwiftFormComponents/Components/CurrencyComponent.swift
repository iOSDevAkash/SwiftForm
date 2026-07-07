import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme

@MainActor
public struct CurrencyComponent: View {

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

    private var currencySymbol: String {
        descriptor.metadata?["currencySymbol"]?.stringValue ?? "$"
    }

    private var text: Binding<String> {
        Binding(
            get: { store.value(for: descriptor.id)?.stringValue ?? "" },
            set: { newValue in
                let filtered = newValue.filter { $0.isNumber || $0 == "." }
                store.setValue(.string(filtered), for: descriptor.id)
            }
        )
    }

    public var body: some View {
        FormFieldView(descriptor: descriptor, store: store) {
            HStack(spacing: tokens.spacing.xs) {
                Text(currencySymbol)
                    .font(tokens.typography.headline)
                    .foregroundStyle(tokens.colors.secondary)
                TextField(
                    descriptor.placeholder ?? "0.00",
                    text: text
                )
                .textFieldStyle(.roundedBorder)
                #if os(iOS)
                .keyboardType(.decimalPad)
                #endif
            }
        }
    }
}
