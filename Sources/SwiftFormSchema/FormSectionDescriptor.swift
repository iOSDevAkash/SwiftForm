import SwiftFormCore

/// Concrete descriptor for a form section.
public struct FormSectionDescriptor: SectionSchema, Codable, Hashable {

    public let id: String
    public let title: String?
    public let subtitle: String?
    public let fields: [FormFieldDescriptor]
    public var isCollapsible: Bool
    public var isCollapsed: Bool

    public init(
        id: String,
        title: String? = nil,
        subtitle: String? = nil,
        fields: [FormFieldDescriptor] = [],
        isCollapsible: Bool = false,
        isCollapsed: Bool = false
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.fields = fields
        self.isCollapsible = isCollapsible
        self.isCollapsed = isCollapsed
    }
}
