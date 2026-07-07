import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme

@MainActor
public struct TextEditorComponent: View {

    public let descriptor: FormFieldDescriptor
    public let store: any FormStateContainer

    public init(descriptor: FormFieldDescriptor, store: any FormStateContainer) {
        self.descriptor = descriptor
        self.store = store
    }

    private var text: Binding<String> {
        Binding(
            get: { store.value(for: descriptor.id)?.stringValue ?? "" },
            set: { store.setValue(.string($0), for: descriptor.id) }
        )
    }

    @Environment(\.themeProvider) private var themeProvider

    private var tokens: any DesignTokens {
        themeProvider?.tokens ?? DefaultDesignTokens()
    }

    public var body: some View {
        FormFieldView(descriptor: descriptor, store: store) {
            TextEditor(text: text)
                .frame(minHeight: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: tokens.radius.sm)
                        .stroke(tokens.colors.border, lineWidth: 1)
                )
        }
    }
}
