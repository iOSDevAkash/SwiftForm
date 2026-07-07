import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme
import Foundation

@MainActor
public struct TimeFieldComponent: View {

    public let descriptor: FormFieldDescriptor
    public let store: any FormStateContainer

    public init(descriptor: FormFieldDescriptor, store: any FormStateContainer) {
        self.descriptor = descriptor
        self.store = store
    }

    private var date: Binding<Date> {
        Binding(
            get: { store.value(for: descriptor.id)?.dateValue ?? Date() },
            set: { store.setValue(.date($0), for: descriptor.id) }
        )
    }

    public var body: some View {
        FormFieldView(descriptor: descriptor, store: store) {
            DatePicker(
                "",
                selection: date,
                displayedComponents: .hourAndMinute
            )
            .labelsHidden()
        }
    }
}
