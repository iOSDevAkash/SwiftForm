import SwiftFormCore
import SwiftFormSchema

/// Result of comparing local and remote schema versions.
public struct SchemaVersionCheck: Sendable, Hashable {

    public let local: Version
    public let remote: Version

    public init(local: Version, remote: Version) {
        self.local = local
        self.remote = remote
    }

    public var needsMigration: Bool {
        local < remote
    }

    public var isDowngrade: Bool {
        local > remote
    }

    public var isCurrent: Bool {
        local == remote
    }
}

/// Protocol for migrating form schemas between versions.
///
/// Implement this to handle schema changes when the server
/// updates the form definition (added/removed fields, renamed sections, etc.).
public protocol SchemaMigrator: Sendable {
    func migrate(
        schema: FormDescriptor,
        from: Version,
        to: Version
    ) async throws -> FormDescriptor
}

/// Default migrator that returns the schema unchanged.
///
/// Use as a placeholder when no migration logic is needed.
public struct DefaultSchemaMigrator: SchemaMigrator, Sendable {

    public init() {}

    public func migrate(
        schema: FormDescriptor,
        from: Version,
        to: Version
    ) async throws -> FormDescriptor {
        schema
    }
}
