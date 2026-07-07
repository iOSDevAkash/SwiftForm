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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        fields = try container.decodeIfPresent([FormFieldDescriptor].self, forKey: .fields) ?? []
        isCollapsible = try container.decodeIfPresent(Bool.self, forKey: .isCollapsible) ?? false
        isCollapsed = try container.decodeIfPresent(Bool.self, forKey: .isCollapsed) ?? false
    }
}
