import SwiftFormCore
import SwiftFormSchema
import Foundation

/// Encodes a form schema to data.
public protocol SchemaEncoder: Sendable {
    func encode(_ schema: any FormSchema) throws -> Data
}

/// Decodes data into a form schema.
public protocol SchemaDecoder: Sendable {
    func decode(from data: Data) throws -> any FormSchema
}

/// Encodes a `FormDescriptor` to JSON data.
public struct JSONSchemaEncoder: SchemaEncoder, Sendable {

    private let encoder: JSONEncoder

    public init(prettyPrinted: Bool = true) {
        let enc = JSONEncoder()
        if prettyPrinted {
            enc.outputFormatting = [.prettyPrinted, .sortedKeys]
        }
        enc.dateEncodingStrategy = .iso8601
        self.encoder = enc
    }

    public func encode(_ schema: any FormSchema) throws -> Data {
        guard let descriptor = schema as? FormDescriptor else {
            throw FormError.encodingFailed(
                reason: "Only FormDescriptor can be encoded. Got \(type(of: schema))."
            )
        }
        return try encoder.encode(descriptor)
    }
}

/// Decodes JSON data into a `FormDescriptor`.
public struct JSONSchemaDecoder: SchemaDecoder, Sendable {

    private let decoder: JSONDecoder

    public init() {
        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .iso8601
        self.decoder = dec
    }

    public func decode(from data: Data) throws -> any FormSchema {
        do {
            return try decoder.decode(FormDescriptor.self, from: data)
        } catch let error as DecodingError {
            throw FormError.decodingFailed(reason: error.localizedDescription)
        }
    }
}
