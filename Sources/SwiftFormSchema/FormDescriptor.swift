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
}
