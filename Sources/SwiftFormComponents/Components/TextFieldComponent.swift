import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme

@MainActor
public struct TextFieldComponent: View {

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

    public var body: some View {
        FormFieldView(descriptor: descriptor, store: store) {
            TextField(
                descriptor.placeholder ?? "",
                text: text
            )
            .textFieldStyle(.roundedBorder)
        }
    }
}
