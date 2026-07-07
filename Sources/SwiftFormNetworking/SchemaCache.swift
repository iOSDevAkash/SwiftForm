import SwiftFormCore
import Foundation

/// Cached schema entry with metadata.
public struct CachedSchema: Sendable, Codable {

    public let data: Data
    public let fetchedAt: Date
    public let expiresAt: Date?
    public let schemaVersion: Version?

    public init(
        data: Data,
        fetchedAt: Date = Date(),
        expiresAt: Date? = nil,
        schemaVersion: Version? = nil
    ) {
        self.data = data
        self.fetchedAt = fetchedAt
        self.expiresAt = expiresAt
        self.schemaVersion = schemaVersion
    }

    public var isExpired: Bool {
        guard let expiresAt else { return false }
        return Date() >= expiresAt
    }
}

/// Protocol for schema caching backends.
public protocol SchemaCache: Sendable {
    func get(_ key: String) async -> CachedSchema?
    func set(_ key: String, schema: CachedSchema) async
    func remove(_ key: String) async
    func clear() async
}

// MARK: - Memory Cache

/// In-memory schema cache backed by an actor.
public actor MemorySchemaCache: SchemaCache {

    private var storage: [String: CachedSchema] = [:]

    public init() {}

    public func get(_ key: String) -> CachedSchema? {
        guard let cached = storage[key] else { return nil }
        if cached.isExpired {
            storage.removeValue(forKey: key)
            return nil
        }
        return cached
    }

    public func set(_ key: String, schema: CachedSchema) {
        storage[key] = schema
    }

    public func remove(_ key: String) {
        storage.removeValue(forKey: key)
    }

    public func clear() {
        storage.removeAll()
    }

    public var count: Int {
        storage.count
    }
}

// MARK: - Disk Cache

/// Persistent schema cache using the filesystem.
///
/// Stores schemas in `Application Support/SwiftForm/schemas/`.
public actor DiskSchemaCache: SchemaCache {

    private let directory: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init(directory: URL? = nil) {
        if let directory {
            self.directory = directory
        } else {
            let appSupport = FileManager.default.urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
            ).first!
            self.directory = appSupport
                .appendingPathComponent("SwiftForm", isDirectory: true)
                .appendingPathComponent("schemas", isDirectory: true)
        }
    }

    private func ensureDirectory() throws {
        try FileManager.default.createDirectory(
            at: directory,
            withIntermediateDirectories: true
        )
    }

    private func fileURL(for key: String) -> URL {
        let safeKey = key.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? key
        return directory.appendingPathComponent("\(safeKey).json")
    }

    public func get(_ key: String) -> CachedSchema? {
        let url = fileURL(for: key)
        guard let data = try? Data(contentsOf: url),
              let cached = try? decoder.decode(CachedSchema.self, from: data) else {
            return nil
        }
        if cached.isExpired {
            try? FileManager.default.removeItem(at: url)
            return nil
        }
        return cached
    }

    public func set(_ key: String, schema: CachedSchema) {
        do {
            try ensureDirectory()
            let data = try encoder.encode(schema)
            try data.write(to: fileURL(for: key), options: .atomic)
        } catch {
            // Silently fail — cache is best-effort
        }
    }

    public func remove(_ key: String) {
        try? FileManager.default.removeItem(at: fileURL(for: key))
    }

    public func clear() {
        try? FileManager.default.removeItem(at: directory)
    }
}
