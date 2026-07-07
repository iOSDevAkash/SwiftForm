import SwiftFormCore
import SwiftFormSchema
import Foundation

/// Serializes current form values to JSON output.
public struct FormOutputEncoder: Sendable {

    public init() {}

    public func encode(_ values: [FormFieldIdentifier: AnyCodableValue]) throws -> Data {
        let stringKeyed = Dictionary(
            uniqueKeysWithValues: values.map { ($0.key.rawValue, $0.value) }
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try encoder.encode(stringKeyed)
    }
}

/// Deserializes JSON data into form field values.
public struct FormOutputDecoder: Sendable {

    public init() {}

    public func decode(from data: Data) throws -> [FormFieldIdentifier: AnyCodableValue] {
        let decoder = JSONDecoder()
        let stringKeyed = try decoder.decode([String: AnyCodableValue].self, from: data)
        return Dictionary(
            uniqueKeysWithValues: stringKeyed.map { (FormFieldIdentifier($0.key), $0.value) }
        )
    }
}
