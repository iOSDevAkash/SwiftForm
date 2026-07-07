import Testing
import Foundation
import SwiftUI
@testable import SwiftFormNetworking
@testable import SwiftFormRenderer
@testable import SwiftFormState
import SwiftFormSchema
import SwiftFormCore
import SwiftFormJSON

// MARK: - Mock SchemaProvider

struct MockSchemaProvider: SchemaProvider, Sendable {

    let schema: FormDescriptor
    let shouldFail: Bool

    init(
        schema: FormDescriptor? = nil,
        shouldFail: Bool = false
    ) {
        self.schema = schema ?? FormDescriptor(
            id: "mock",
            title: "Mock Form",
            sections: [
                FormSectionDescriptor(
                    id: "s1",
                    title: "Section 1",
                    fields: [
                        FormFieldDescriptor(
                            id: "name",
                            componentType: .text,
                            title: "Name"
                        ),
                    ]
                ),
            ]
        )
        self.shouldFail = shouldFail
    }

    func fetchSchema(
        id: String,
        cachePolicy: CachePolicy
    ) async throws -> any FormSchema {
        if shouldFail {
            throw FormError.networkError(reason: "Mock network failure")
        }
        return schema
    }
}

@Suite("SwiftFormNetworking")
struct SwiftFormNetworkingTests {

    @Test func cachePolicyCases() {
        #expect(CachePolicy.never.rawValue == "never")
        #expect(CachePolicy.memory.rawValue == "memory")
        #expect(CachePolicy.disk.rawValue == "disk")
        #expect(CachePolicy.custom.rawValue == "custom")
    }

    @Test func schemaProviderProtocolExists() {
        func acceptProvider(_ provider: any SchemaProvider) {
            _ = provider
        }
    }

    // MARK: - CachedSchema

    @Test func cachedSchemaNotExpired() {
        let cached = CachedSchema(
            data: Data(),
            expiresAt: Date().addingTimeInterval(3600)
        )
        #expect(!cached.isExpired)
    }

    @Test func cachedSchemaExpired() {
        let cached = CachedSchema(
            data: Data(),
            expiresAt: Date().addingTimeInterval(-1)
        )
        #expect(cached.isExpired)
    }

    @Test func cachedSchemaNoExpiry() {
        let cached = CachedSchema(data: Data())
        #expect(!cached.isExpired)
    }

    // MARK: - MemorySchemaCache

    @Test func memoryCacheSetAndGet() async {
        let cache = MemorySchemaCache()
        let schema = CachedSchema(
            data: Data("test".utf8),
            expiresAt: Date().addingTimeInterval(3600)
        )
        await cache.set("key1", schema: schema)
        let result = await cache.get("key1")
        #expect(result != nil)
        #expect(result?.data == Data("test".utf8))
    }

    @Test func memoryCacheReturnsNilForMissing() async {
        let cache = MemorySchemaCache()
        let result = await cache.get("nonexistent")
        #expect(result == nil)
    }

    @Test func memoryCacheRemove() async {
        let cache = MemorySchemaCache()
        let schema = CachedSchema(data: Data("test".utf8))
        await cache.set("key1", schema: schema)
        await cache.remove("key1")
        let result = await cache.get("key1")
        #expect(result == nil)
    }

    @Test func memoryCacheClear() async {
        let cache = MemorySchemaCache()
        await cache.set("key1", schema: CachedSchema(data: Data()))
        await cache.set("key2", schema: CachedSchema(data: Data()))
        await cache.clear()
        let count = await cache.count
        #expect(count == 0)
    }

    @Test func memoryCacheEvictsExpired() async {
        let cache = MemorySchemaCache()
        let expired = CachedSchema(
            data: Data("old".utf8),
            expiresAt: Date().addingTimeInterval(-1)
        )
        await cache.set("key1", schema: expired)
        let result = await cache.get("key1")
        #expect(result == nil)
    }

    // MARK: - DiskSchemaCache

    @Test func diskCacheSetAndGet() async {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        let cache = DiskSchemaCache(directory: dir)
        let schema = CachedSchema(
            data: Data("disktest".utf8),
            expiresAt: Date().addingTimeInterval(3600)
        )
        await cache.set("diskkey", schema: schema)
        let result = await cache.get("diskkey")
        #expect(result != nil)
        #expect(result?.data == Data("disktest".utf8))
        // Cleanup
        try? FileManager.default.removeItem(at: dir)
    }

    @Test func diskCacheReturnsNilForMissing() async {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        let cache = DiskSchemaCache(directory: dir)
        let result = await cache.get("nothing")
        #expect(result == nil)
    }

    @Test func diskCacheRemove() async {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        let cache = DiskSchemaCache(directory: dir)
        await cache.set("removeMe", schema: CachedSchema(data: Data("x".utf8)))
        await cache.remove("removeMe")
        let result = await cache.get("removeMe")
        #expect(result == nil)
        try? FileManager.default.removeItem(at: dir)
    }

    @Test func diskCacheClear() async {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        let cache = DiskSchemaCache(directory: dir)
        await cache.set("a", schema: CachedSchema(data: Data()))
        await cache.set("b", schema: CachedSchema(data: Data()))
        await cache.clear()
        let a = await cache.get("a")
        let b = await cache.get("b")
        #expect(a == nil)
        #expect(b == nil)
        try? FileManager.default.removeItem(at: dir)
    }

    // MARK: - CachingSchemaProvider

    @Test func cachingProviderCachesOnFetch() async throws {
        let cache = MemorySchemaCache()
        let mock = MockSchemaProvider()
        let provider = CachingSchemaProvider(
            wrapping: mock,
            cache: cache
        )
        _ = try await provider.fetchSchema(id: "form1", cachePolicy: .memory)
        let cached = await cache.get("form1")
        #expect(cached != nil)
    }

    @Test func cachingProviderServesFromCache() async throws {
        let cache = MemorySchemaCache()
        let encoder = JSONSchemaEncoder(prettyPrinted: false)
        let schema = FormDescriptor(id: "cached", title: "Cached Form")
        let data = try encoder.encode(schema)
        await cache.set("form2", schema: CachedSchema(
            data: data,
            expiresAt: Date().addingTimeInterval(3600)
        ))

        let failingProvider = MockSchemaProvider(shouldFail: true)
        let provider = CachingSchemaProvider(
            wrapping: failingProvider,
            cache: cache
        )
        let result = try await provider.fetchSchema(id: "form2", cachePolicy: .memory)
        #expect((result as? FormDescriptor)?.title == "Cached Form")
    }

    @Test func cachingProviderBypassesCacheOnNever() async throws {
        let cache = MemorySchemaCache()
        let mock = MockSchemaProvider()
        let provider = CachingSchemaProvider(wrapping: mock, cache: cache)
        _ = try await provider.fetchSchema(id: "form3", cachePolicy: .never)
        // Should still cache the result for future use
        let cached = await cache.get("form3")
        #expect(cached != nil)
    }

    @Test func cachingProviderOfflineFallback() async throws {
        let cache = MemorySchemaCache()
        let encoder = JSONSchemaEncoder(prettyPrinted: false)
        let schema = FormDescriptor(id: "offline", title: "Offline Form")
        let data = try encoder.encode(schema)
        await cache.set("form4", schema: CachedSchema(data: data))

        let failingProvider = MockSchemaProvider(shouldFail: true)
        let provider = CachingSchemaProvider(
            wrapping: failingProvider,
            cache: cache,
            configuration: CacheConfiguration(offlineFallback: true)
        )
        let result = try await provider.fetchSchema(id: "form4", cachePolicy: .memory)
        #expect((result as? FormDescriptor)?.title == "Offline Form")
    }

    @Test func cachingProviderNoFallbackThrows() async {
        let cache = MemorySchemaCache()
        let failingProvider = MockSchemaProvider(shouldFail: true)
        let provider = CachingSchemaProvider(
            wrapping: failingProvider,
            cache: cache,
            configuration: CacheConfiguration(offlineFallback: false)
        )
        do {
            _ = try await provider.fetchSchema(id: "form5", cachePolicy: .memory)
            #expect(Bool(false), "Should have thrown")
        } catch {
            #expect(error is FormError)
        }
    }

    // MARK: - CacheConfiguration

    @Test func cacheConfigurationDefaults() {
        let config = CacheConfiguration.default
        #expect(config.defaultTTL == 3600)
        #expect(config.offlineFallback == true)
    }

    @Test func cacheConfigurationNoCache() {
        let config = CacheConfiguration.noCache
        #expect(config.defaultTTL == 0)
        #expect(config.offlineFallback == false)
    }

    // MARK: - Schema Versioning

    @Test func versionCheckNeedsMigration() {
        let check = SchemaVersionCheck(
            local: Version(1, 0, 0),
            remote: Version(2, 0, 0)
        )
        #expect(check.needsMigration)
        #expect(!check.isDowngrade)
        #expect(!check.isCurrent)
    }

    @Test func versionCheckIsCurrent() {
        let check = SchemaVersionCheck(
            local: Version(1, 2, 3),
            remote: Version(1, 2, 3)
        )
        #expect(!check.needsMigration)
        #expect(!check.isDowngrade)
        #expect(check.isCurrent)
    }

    @Test func versionCheckIsDowngrade() {
        let check = SchemaVersionCheck(
            local: Version(3, 0, 0),
            remote: Version(2, 0, 0)
        )
        #expect(!check.needsMigration)
        #expect(check.isDowngrade)
        #expect(!check.isCurrent)
    }

    @Test func defaultSchemaMigratorPassthrough() async throws {
        let migrator = DefaultSchemaMigrator()
        let schema = FormDescriptor(id: "test", title: "Test")
        let result = try await migrator.migrate(
            schema: schema,
            from: Version(1, 0, 0),
            to: Version(2, 0, 0)
        )
        #expect(result.id == "test")
        #expect(result.title == "Test")
    }

    // MARK: - URLSchemaProvider

    @Test func urlSchemaProviderCreation() {
        let provider = URLSchemaProvider(timeoutInterval: 15)
        _ = provider
    }

    // MARK: - RemoteFormView

    @MainActor
    @Test func remoteFormViewInstantiation() {
        let provider = MockSchemaProvider()
        let view = RemoteFormView(
            url: "https://example.com/form",
            provider: provider
        )
        #expect(type(of: view) == RemoteFormView.self)
    }

    @MainActor
    @Test func remoteFormViewWithLayout() {
        let provider = MockSchemaProvider()
        let view = RemoteFormView(
            url: "https://example.com/form",
            provider: provider,
            cachePolicy: .disk,
            layout: StackFormLayout()
        )
        #expect(type(of: view) == RemoteFormView.self)
    }

    @MainActor
    @Test func remoteFormViewWithSubmit() {
        let provider = MockSchemaProvider()
        var submitted = false
        let view = RemoteFormView(
            url: "https://example.com/form",
            provider: provider
        ) { _ in
            submitted = true
        }
        #expect(type(of: view) == RemoteFormView.self)
        #expect(!submitted)
    }

    // MARK: - RemoteFormLoadState

    @Test func loadStateValues() {
        let loading: RemoteFormLoadState = .loading
        let error: RemoteFormLoadState = .error("fail")
        let schema = FormDescriptor(id: "t", title: "T")
        let loaded: RemoteFormLoadState = .loaded(schema)

        switch loading {
        case .loading: break
        default: #expect(Bool(false), "Expected .loading")
        }
        switch error {
        case .error(let msg): #expect(msg == "fail")
        default: #expect(Bool(false), "Expected .error")
        }
        switch loaded {
        case .loaded(let d): #expect(d.id == "t")
        default: #expect(Bool(false), "Expected .loaded")
        }
    }

    // MARK: - Mock Provider

    @Test func mockProviderSuccess() async throws {
        let mock = MockSchemaProvider()
        let result = try await mock.fetchSchema(id: "test", cachePolicy: .never)
        #expect((result as? FormDescriptor)?.title == "Mock Form")
    }

    @Test func mockProviderFailure() async {
        let mock = MockSchemaProvider(shouldFail: true)
        do {
            _ = try await mock.fetchSchema(id: "test", cachePolicy: .never)
            #expect(Bool(false), "Should have thrown")
        } catch {
            #expect(error is FormError)
        }
    }
}
