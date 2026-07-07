import SwiftFormCore

/// Concrete descriptor for a complete form.
public struct FormDescriptor: FormSchema, Codable, Hashable {

    public let id: String
    public let title: String
    public let version: Version
    public let sections: [FormSectionDescriptor]
    public var subtitle: String?
    public var submitTitle: String?
    public var metadata: [String: AnyCodableValue]?

    public init(
        id: String,
        title: String,
        version: Version = Version(1, 0, 0),
        sections: [FormSectionDescriptor] = [],
        subtitle: String? = nil,
        submitTitle: String? = nil,
        metadata: [String: AnyCodableValue]? = nil
    ) {
        self.id = id
        self.title = title
        self.version = version
        self.sections = sections
        self.subtitle = subtitle
        self.submitTitle = submitTitle
        self.metadata = metadata
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        version = try container.decodeIfPresent(Version.self, forKey: .version) ?? Version(1, 0, 0)
        sections = try container.decodeIfPresent([FormSectionDescriptor].self, forKey: .sections) ?? []
        subtitle = try container.decodeIfPresent(String.self, forKey: .subtitle)
        submitTitle = try container.decodeIfPresent(String.self, forKey: .submitTitle)
        metadata = try container.decodeIfPresent([String: AnyCodableValue].self, forKey: .metadata)
    }
}
