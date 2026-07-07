import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme
import SwiftFormComponents

/// Factory that produces SwiftUI views for all built-in component types.
@MainActor
public struct BuiltInComponentFactory: ComponentFactory {

    public init() {}

    public func makeView(for field: any FieldSchema, state: any FormStateContainer) -> AnyView? {
        guard let descriptor = field as? FormFieldDescriptor else { return nil }

        switch descriptor.componentType {
        case .text:
            return AnyView(TextFieldComponent(descriptor: descriptor, store: state))
        case .secureField:
            return AnyView(SecureFieldComponent(descriptor: descriptor, store: state))
        case .email:
            return AnyView(EmailFieldComponent(descriptor: descriptor, store: state))
        case .phone:
            return AnyView(PhoneFieldComponent(descriptor: descriptor, store: state))
        case .textEditor:
            return AnyView(TextEditorComponent(descriptor: descriptor, store: state))
        case .date:
            return AnyView(DateFieldComponent(descriptor: descriptor, store: state))
        case .time:
            return AnyView(TimeFieldComponent(descriptor: descriptor, store: state))
        case .toggle:
            return AnyView(ToggleComponent(descriptor: descriptor, store: state))
        case .checkbox:
            return AnyView(CheckboxComponent(descriptor: descriptor, store: state))
        case .slider:
            return AnyView(SliderComponent(descriptor: descriptor, store: state))
        case .dropdown:
            return AnyView(DropdownComponent(descriptor: descriptor, store: state))
        case .radio:
            return AnyView(RadioComponent(descriptor: descriptor, store: state))
        case .segment:
            return AnyView(SegmentComponent(descriptor: descriptor, store: state))
        case .rating:
            return AnyView(RatingComponent(descriptor: descriptor, store: state))
        case .otp:
            return AnyView(OTPComponent(descriptor: descriptor, store: state))
        case .currency:
            return AnyView(CurrencyComponent(descriptor: descriptor, store: state))
        case .search:
            return AnyView(SearchComponent(descriptor: descriptor, store: state))
        case .autocomplete:
            return AnyView(AutocompleteComponent(descriptor: descriptor, store: state))
        case .progress:
            return AnyView(ProgressComponent(descriptor: descriptor, store: state))
        default:
            return nil
        }
    }

    /// All component types this factory handles.
    public static let supportedTypes: [ComponentType] = [
        .text, .secureField, .email, .phone, .textEditor,
        .date, .time, .toggle, .checkbox, .slider,
        .dropdown, .radio, .segment, .rating,
        .otp, .currency, .search, .autocomplete, .progress,
    ]
}
