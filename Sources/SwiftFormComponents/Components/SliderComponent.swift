import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme

@MainActor
public struct SliderComponent: View {

    public let descriptor: FormFieldDescriptor
    public let store: any FormStateContainer

    public init(descriptor: FormFieldDescriptor, store: any FormStateContainer) {
        self.descriptor = descriptor
        self.store = store
    }

    private var value: Binding<Double> {
        Binding(
            get: { store.value(for: descriptor.id)?.doubleValue ?? 0 },
            set: { store.setValue(.double($0), for: descriptor.id) }
        )
    }

    private var range: ClosedRange<Double> {
        let min = descriptor.metadata?["min"]?.doubleValue ?? 0
        let max = descriptor.metadata?["max"]?.doubleValue ?? 1
        return min...max
    }

    public var body: some View {
        FormFieldView(descriptor: descriptor, store: store) {
            Slider(value: value, in: range)
        }
    }
}
