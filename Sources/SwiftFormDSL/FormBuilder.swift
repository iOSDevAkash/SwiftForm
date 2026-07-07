import SwiftFormCore
import SwiftFormSchema

/// Result builder for constructing form descriptors declaratively.
///
/// Usage:
/// ```swift
/// let form = SwiftFormDSL.form("registration", title: "Register") {
///     section("profile", title: "Profile") {
///         textField("name", title: "Full Name", required: true)
///         emailField("email", title: "Email", required: true)
///     }
///     section("preferences", title: "Preferences") {
///         toggle("newsletter", title: "Subscribe to newsletter")
///     }
/// }
/// ```
@resultBuilder
public struct FormBuilder {

    public static func buildBlock(_ sections: [FormSectionDescriptor]...) -> [FormSectionDescriptor] {
        sections.flatMap { $0 }
    }

    public static func buildOptional(_ section: [FormSectionDescriptor]?) -> [FormSectionDescriptor] {
        section ?? []
    }

    public static func buildEither(first sections: [FormSectionDescriptor]) -> [FormSectionDescriptor] {
        sections
    }

    public static func buildEither(second sections: [FormSectionDescriptor]) -> [FormSectionDescriptor] {
        sections
    }

    public static func buildArray(_ sections: [[FormSectionDescriptor]]) -> [FormSectionDescriptor] {
        sections.flatMap { $0 }
    }

    public static func buildExpression(_ section: FormSectionDescriptor) -> [FormSectionDescriptor] {
        [section]
    }
}

/// Result builder for constructing form sections declaratively.
@resultBuilder
public struct SectionBuilder {

    public static func buildBlock(_ fields: [FormFieldDescriptor]...) -> [FormFieldDescriptor] {
        fields.flatMap { $0 }
    }

    public static func buildOptional(_ fields: [FormFieldDescriptor]?) -> [FormFieldDescriptor] {
        fields ?? []
    }

    public static func buildEither(first fields: [FormFieldDescriptor]) -> [FormFieldDescriptor] {
        fields
    }

    public static func buildEither(second fields: [FormFieldDescriptor]) -> [FormFieldDescriptor] {
        fields
    }

    public static func buildArray(_ fields: [[FormFieldDescriptor]]) -> [FormFieldDescriptor] {
        fields.flatMap { $0 }
    }

    public static func buildExpression(_ field: FormFieldDescriptor) -> [FormFieldDescriptor] {
        [field]
    }
}
