import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormRenderer

/// Component factory for all hardware / media capture component types in `SwiftFormCapture`.
@MainActor
public struct CaptureComponentFactory: ComponentFactory {

    public init() {}

    public func makeView(for field: any FieldSchema, state: any FormStateContainer) -> AnyView? {
        guard let descriptor = field as? FormFieldDescriptor else { return nil }

        switch descriptor.componentType {
        case .imagePicker:
            return AnyView(ImagePickerComponent(descriptor: descriptor, store: state))
        case .camera:
            return AnyView(CameraComponent(descriptor: descriptor, store: state))
        case .barcode, .qr:
            return AnyView(BarcodeScannerComponent(descriptor: descriptor, store: state))
        case .signature:
            return AnyView(SignatureComponent(descriptor: descriptor, store: state))
        case .documentPicker:
            return AnyView(DocumentPickerComponent(descriptor: descriptor, store: state))
        default:
            return nil
        }
    }

    /// Component types handled by CaptureComponentFactory.
    public static let supportedTypes: [ComponentType] = [
        .imagePicker, .camera, .barcode, .qr, .signature, .documentPicker
    ]
}

extension DefaultComponentRegistry {

    /// Registers all capture component types from `SwiftFormCapture`.
    @discardableResult
    public func withCaptureComponents() -> DefaultComponentRegistry {
        let factory = CaptureComponentFactory()
        for type in CaptureComponentFactory.supportedTypes {
            register(type, factory: factory)
        }
        return self
    }
}
