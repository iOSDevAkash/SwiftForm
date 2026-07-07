import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme

@MainActor
public struct ToggleComponent: View {

    public let descriptor: FormFieldDescriptor
    public let store: any FormStateContainer

    public init(descriptor: FormFieldDescriptor, store: any FormStateContainer) {
        self.descriptor = descriptor
        self.store = store
    }

    private var isOn: Binding<Bool> {
        Binding(
            get: { store.value(for: descriptor.id)?.boolValue ?? false },
            set: { store.setValue(.bool($0), for: descriptor.id) }
        )
    }

    public var body: some View {
        FormFieldView(descriptor: descriptor, store: store) {
            Toggle("", isOn: isOn)
                .labelsHidden()
        }
    }
}
