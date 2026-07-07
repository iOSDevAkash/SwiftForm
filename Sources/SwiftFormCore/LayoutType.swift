/// Extensible identifier for layout types.
///
/// Uses a struct instead of an enum so plugins can register new layout types
/// without modifying the framework source.
public struct LayoutType: Hashable, Sendable, Codable, CustomStringConvertible {

    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    public var description: String { rawValue }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.rawValue = try container.decode(String.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

extension LayoutType: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

// MARK: - Built-in Layout Types

extension LayoutType {
    public static let stack: LayoutType = "stack"
    public static let form: LayoutType = "form"
    public static let card: LayoutType = "card"
    public static let wizard: LayoutType = "wizard"
    public static let accordion: LayoutType = "accordion"
    public static let grid: LayoutType = "grid"
    public static let responsiveGrid: LayoutType = "responsiveGrid"
    public static let tabs: LayoutType = "tabs"
    public static let sections: LayoutType = "sections"
    public static let stepper: LayoutType = "stepper"
}
