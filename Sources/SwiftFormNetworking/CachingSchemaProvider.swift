import SwiftFormCore
import SwiftFormSchema
import SwiftFormJSON
import Foundation

/// Configuration for schema caching behavior.
public struct CacheConfiguration: Sendable {

    public let defaultTTL: TimeInterval
    public let offlineFallback: Bool

    public init(
        defaultTTL: TimeInterval = 3600,
        offlineFallback: Bool = true
    ) {
        self.defaultTTL = defaultTTL
        self.offlineFallback = offlineFallback
    }

    public static let `default` = CacheConfiguration()
    public static let noCache = CacheConfiguration(defaultTTL: 0, offlineFallback: false)
}

/// Schema provider that wraps another provider with a caching layer.
///
/// On cache hit (and not expired), returns cached schema immediately.
/// On cache miss or expiry, fetches from wrapped provider and stores result.
/// On network failure with `offlineFallback` enabled, serves stale cache.
public struct CachingSchemaProvider: SchemaProvider, Sendable {

    private let wrapped: any SchemaProvider
    private let cache: any SchemaCache
    private let configuration: CacheConfiguration
    private let decoder: JSONSchemaDecoder
    private let encoder: JSONSchemaEncoder

    public init(
        wrapping provider: any SchemaProvider,
        cache: any SchemaCache,
        configuration: CacheConfiguration = .default
    ) {
        self.wrapped = provider
        self.cache = cache
        self.configuration = configuration
        self.decoder = JSONSchemaDecoder()
        self.encoder = JSONSchemaEncoder(prettyPrinted: false)
    }

    public func fetchSchema(
        id: String,
        cachePolicy: CachePolicy
    ) async throws -> any FormSchema {
        switch cachePolicy {
        case .never:
            return try await fetchAndCache(id: id)

        case .memory, .disk, .custom:
            if let cached = await cache.get(id) {
                return try decoder.decode(from: cached.data)
            }
            do {
                return try await fetchAndCache(id: id)
            } catch {
                if configuration.offlineFallback,
                   let stale = await cache.get(id) {
                    return try decoder.decode(from: stale.data)
                }
                throw error
            }
        }
    }

    private func fetchAndCache(id: String) async throws -> any FormSchema {
        let schema = try await wrapped.fetchSchema(id: id, cachePolicy: .never)
        let data = try encoder.encode(schema)
        let version = (schema as? FormDescriptor)?.version
        let expiresAt = configuration.defaultTTL > 0
            ? Date().addingTimeInterval(configuration.defaultTTL)
            : nil
        let cached = CachedSchema(
            data: data,
            expiresAt: expiresAt,
            schemaVersion: version
        )
        await cache.set(id, schema: cached)
        return schema
    }
}
