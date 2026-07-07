import SwiftFormCore
import SwiftFormSchema
import SwiftFormJSON

/// Cache policy for fetched schemas.
public enum CachePolicy: String, Sendable, Hashable {
    case never
    case memory
    case disk
    case custom
}

/// Provides form schemas from a remote source.
public protocol SchemaProvider: Sendable {
    func fetchSchema(id: String, cachePolicy: CachePolicy) async throws -> any FormSchema
}
