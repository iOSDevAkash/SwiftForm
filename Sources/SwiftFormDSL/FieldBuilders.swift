import Foundation
import SwiftFormCore
import SwiftFormSchema

// MARK: - Text Input Fields

public func textField(
    _ id: String,
    title: String,
    placeholder: String? = nil,
    required: Bool = false,
    defaultValue: String? = nil
) -> FormFieldDescriptor {
    FormFieldDescriptor(
        id: FormFieldIdentifier(id),
        componentType: .text,
        title: title,
        placeholder: placeholder,
        isRequired: required,
        defaultValue: defaultValue.map { .string($0) }
    )
}

public func secureField(
    _ id: String,
    title: String,
    placeholder: String? = nil,
    required: Bool = false
) -> FormFieldDescriptor {
    FormFieldDescriptor(
        id: FormFieldIdentifier(id),
        componentType: .secureField,
        title: title,
        placeholder: placeholder,
        isRequired: required
    )
}

public func emailField(
    _ id: String,
    title: String,
    placeholder: String? = nil,
    required: Bool = false,
    defaultValue: String? = nil
) -> FormFieldDescriptor {
    FormFieldDescriptor(
        id: FormFieldIdentifier(id),
        componentType: .email,
        title: title,
        placeholder: placeholder,
        isRequired: required,
        defaultValue: defaultValue.map { .string($0) }
    )
}

public func phoneField(
    _ id: String,
    title: String,
    placeholder: String? = nil,
    required: Bool = false
) -> FormFieldDescriptor {
    FormFieldDescriptor(
        id: FormFieldIdentifier(id),
        componentType: .phone,
        title: title,
        placeholder: placeholder,
        isRequired: required
    )
}

public func otpField(
    _ id: String,
    title: String,
    digitCount: Int = 6,
    required: Bool = false
) -> FormFieldDescriptor {
    FormFieldDescriptor(
        id: FormFieldIdentifier(id),
        componentType: .otp,
        title: title,
        isRequired: required,
        metadata: digitCount != 6 ? ["digitCount": .int(digitCount)] : nil
    )
}

public func currencyField(
    _ id: String,
    title: String,
    placeholder: String? = nil,
    currencySymbol: String = "$",
    required: Bool = false
) -> FormFieldDescriptor {
    FormFieldDescriptor(
        id: FormFieldIdentifier(id),
        componentType: .currency,
        title: title,
        placeholder: placeholder,
        isRequired: required,
        metadata: currencySymbol != "$" ? ["currencySymbol": .string(currencySymbol)] : nil
    )
}

public func textEditor(
    _ id: String,
    title: String,
    placeholder: String? = nil,
    required: Bool = false
) -> FormFieldDescriptor {
    FormFieldDescriptor(
        id: FormFieldIdentifier(id),
        componentType: .textEditor,
        title: title,
        placeholder: placeholder,
        isRequired: required
    )
}

// MARK: - Date/Time Fields

public func dateField(
    _ id: String,
    title: String,
    required: Bool = false,
    defaultValue: Date? = nil
) -> FormFieldDescriptor {
    FormFieldDescriptor(
        id: FormFieldIdentifier(id),
        componentType: .date,
        title: title,
        isRequired: required,
        defaultValue: defaultValue.map { .date($0) }
    )
}

public func timeField(
    _ id: String,
    title: String,
    required: Bool = false
) -> FormFieldDescriptor {
    FormFieldDescriptor(
        id: FormFieldIdentifier(id),
        componentType: .time,
        title: title,
        isRequired: required
    )
}

// MARK: - Selection Fields

public func toggle(
    _ id: String,
    title: String,
    defaultValue: Bool = false
) -> FormFieldDescriptor {
    FormFieldDescriptor(
        id: FormFieldIdentifier(id),
        componentType: .toggle,
        title: title,
        defaultValue: .bool(defaultValue)
    )
}

public func checkbox(
    _ id: String,
    title: String,
    defaultValue: Bool = false
) -> FormFieldDescriptor {
    FormFieldDescriptor(
        id: FormFieldIdentifier(id),
        componentType: .checkbox,
        title: title,
        defaultValue: .bool(defaultValue)
    )
}

public func radio(
    _ id: String,
    title: String,
    options: [FieldOption],
    required: Bool = false
) -> FormFieldDescriptor {
    FormFieldDescriptor(
        id: FormFieldIdentifier(id),
        componentType: .radio,
        title: title,
        isRequired: required,
        options: options
    )
}

public func segment(
    _ id: String,
    title: String,
    options: [FieldOption],
    required: Bool = false
) -> FormFieldDescriptor {
    FormFieldDescriptor(
        id: FormFieldIdentifier(id),
        componentType: .segment,
        title: title,
        isRequired: required,
        options: options
    )
}

public func dropdown(
    _ id: String,
    title: String,
    options: [FieldOption],
    placeholder: String? = nil,
    required: Bool = false
) -> FormFieldDescriptor {
    FormFieldDescriptor(
        id: FormFieldIdentifier(id),
        componentType: .dropdown,
        title: title,
        placeholder: placeholder,
        isRequired: required,
        options: options
    )
}

// MARK: - Numeric Fields

public func slider(
    _ id: String,
    title: String,
    defaultValue: Double = 0
) -> FormFieldDescriptor {
    FormFieldDescriptor(
        id: FormFieldIdentifier(id),
        componentType: .slider,
        title: title,
        defaultValue: .double(defaultValue)
    )
}

public func rating(
    _ id: String,
    title: String,
    required: Bool = false
) -> FormFieldDescriptor {
    FormFieldDescriptor(
        id: FormFieldIdentifier(id),
        componentType: .rating,
        title: title,
        isRequired: required
    )
}

// MARK: - Convenience

/// Create a `FieldOption` for use in radio, segment, and dropdown fields.
public func option(
    _ id: String,
    label: String,
    value: AnyCodableValue? = nil,
    disabled: Bool = false
) -> FieldOption {
    FieldOption(
        id: id,
        label: label,
        value: value ?? .string(id),
        isDisabled: disabled
    )
}

// MARK: - Search & Autocomplete

public func searchField(
    _ id: String,
    title: String,
    placeholder: String? = nil,
    required: Bool = false
) -> FormFieldDescriptor {
    FormFieldDescriptor(
        id: FormFieldIdentifier(id),
        componentType: .search,
        title: title,
        placeholder: placeholder,
        isRequired: required
    )
}

public func autocompleteField(
    _ id: String,
    title: String,
    options: [FieldOption],
    placeholder: String? = nil,
    required: Bool = false
) -> FormFieldDescriptor {
    FormFieldDescriptor(
        id: FormFieldIdentifier(id),
        componentType: .autocomplete,
        title: title,
        placeholder: placeholder,
        isRequired: required,
        options: options
    )
}

public func progressField(
    _ id: String,
    title: String,
    defaultValue: Double = 0,
    showLabel: Bool = true
) -> FormFieldDescriptor {
    FormFieldDescriptor(
        id: FormFieldIdentifier(id),
        componentType: .progress,
        title: title,
        defaultValue: .double(defaultValue),
        metadata: !showLabel ? ["showLabel": .bool(false)] : nil
    )
}

// MARK: - Capture Fields

public func imagePicker(
    _ id: String,
    title: String,
    required: Bool = false
) -> FormFieldDescriptor {
    FormFieldDescriptor(
        id: FormFieldIdentifier(id),
        componentType: .imagePicker,
        title: title,
        isRequired: required
    )
}

public func signatureField(
    _ id: String,
    title: String,
    required: Bool = false
) -> FormFieldDescriptor {
    FormFieldDescriptor(
        id: FormFieldIdentifier(id),
        componentType: .signature,
        title: title,
        isRequired: required
    )
}

public func documentPicker(
    _ id: String,
    title: String,
    allowedTypes: String? = nil,
    required: Bool = false
) -> FormFieldDescriptor {
    FormFieldDescriptor(
        id: FormFieldIdentifier(id),
        componentType: .documentPicker,
        title: title,
        isRequired: required,
        metadata: allowedTypes.map { ["allowedTypes": .string($0)] }
    )
}
