/// Extensible identifier for component types.
///
/// Uses a struct instead of an enum so plugins can register new component types
/// without modifying the framework source.
public struct ComponentType: Hashable, Sendable, Codable, CustomStringConvertible {

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

extension ComponentType: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.rawValue = value
    }
}

// MARK: - Built-in Component Types

extension ComponentType {
    public static let text: ComponentType = "text"
    public static let secureField: ComponentType = "secureField"
    public static let email: ComponentType = "email"
    public static let phone: ComponentType = "phone"
    public static let otp: ComponentType = "otp"
    public static let currency: ComponentType = "currency"
    public static let date: ComponentType = "date"
    public static let time: ComponentType = "time"
    public static let toggle: ComponentType = "toggle"
    public static let checkbox: ComponentType = "checkbox"
    public static let radio: ComponentType = "radio"
    public static let segment: ComponentType = "segment"
    public static let dropdown: ComponentType = "dropdown"
    public static let search: ComponentType = "search"
    public static let autocomplete: ComponentType = "autocomplete"
    public static let textEditor: ComponentType = "textEditor"
    public static let slider: ComponentType = "slider"
    public static let rating: ComponentType = "rating"
    public static let progress: ComponentType = "progress"
    public static let imagePicker: ComponentType = "imagePicker"
    public static let camera: ComponentType = "camera"
    public static let barcode: ComponentType = "barcode"
    public static let qr: ComponentType = "qr"
    public static let signature: ComponentType = "signature"
    public static let documentPicker: ComponentType = "documentPicker"
    public static let location: ComponentType = "location"
    public static let map: ComponentType = "map"
    public static let chart: ComponentType = "chart"
    public static let markdown: ComponentType = "markdown"
    public static let richText: ComponentType = "richText"
    public static let custom: ComponentType = "custom"
}
