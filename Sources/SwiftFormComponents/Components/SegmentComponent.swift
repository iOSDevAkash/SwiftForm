import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme

@MainActor
public struct SegmentComponent: View {

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

    public var body: some View {
        FormFieldView(descriptor: descriptor, store: store) {
            Picker("", selection: selection) {
                ForEach(options) { option in
                    Text(option.label)
                        .tag(option.id)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
        }
    }
}
