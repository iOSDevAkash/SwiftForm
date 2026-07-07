import SwiftFormCore
import SwiftFormSchema

/// Namespace for DSL entry points.
public enum SwiftFormDSL {

    /// Create a form descriptor using the declarative DSL.
    public static func form(
        _ id: String,
        title: String,
        version: Version = Version(1, 0, 0),
        subtitle: String? = nil,
        submitTitle: String? = nil,
        @FormBuilder sections: () -> [FormSectionDescriptor]
    ) -> FormDescriptor {
        FormDescriptor(
            id: id,
            title: title,
            version: version,
            sections: sections(),
            subtitle: subtitle,
            submitTitle: submitTitle
        )
    }
}

/// Create a section descriptor using the declarative DSL.
public func section(
    _ id: String,
    title: String? = nil,
    subtitle: String? = nil,
    isCollapsible: Bool = false,
    isCollapsed: Bool = false,
    @SectionBuilder fields: () -> [FormFieldDescriptor]
) -> FormSectionDescriptor {
    FormSectionDescriptor(
        id: id,
        title: title,
        subtitle: subtitle,
        fields: fields(),
        isCollapsible: isCollapsible,
        isCollapsed: isCollapsed
    )
}
