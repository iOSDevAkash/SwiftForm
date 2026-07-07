import Testing
import Foundation
@testable import SwiftFormPlugins
import SwiftFormCore

struct TestPlugin: FormPlugin, Sendable {
    let name: String
    let loadedCount: LockedCounter
    let changedCount: LockedCounter
    let submittedCount: LockedCounter

    init(name: String = "test") {
        self.name = name
        self.loadedCount = LockedCounter()
        self.changedCount = LockedCounter()
        self.submittedCount = LockedCounter()
    }

    func onFormLoaded() async {
        loadedCount.increment()
    }

    func onFieldChanged(id: FormFieldIdentifier, value: any FormValue) async {
        changedCount.increment()
    }

    func onFormSubmitted(values: [FormFieldIdentifier: any FormValue]) async {
        submittedCount.increment()
    }
}

final class LockedCounter: @unchecked Sendable {
    private var _value = 0
    private let lock = NSLock()

    func increment() {
        lock.lock()
        _value += 1
        lock.unlock()
    }

    var value: Int {
        lock.lock()
        defer { lock.unlock() }
        return _value
    }
}

@Suite("SwiftFormPlugins")
struct SwiftFormPluginsTests {

    @Test func pluginContextCreation() {
        let context = PluginContext(
            formID: "registration",
            configuration: FormConfiguration()
        )
        #expect(context.formID == "registration")
    }

    @Test func formPluginProtocolExists() {
        func acceptPlugin(_ plugin: any FormPlugin) {
            _ = plugin.name
        }
    }

    @Test func pluginManagerRegister() async {
        let manager = PluginManager()
        let plugin = TestPlugin()
        await manager.register(plugin)
        let plugins = await manager.registeredPlugins
        #expect(plugins.count == 1)
        #expect(plugins[0].name == "test")
    }

    @Test func pluginManagerNotifyFormLoaded() async {
        let plugin = TestPlugin()
        let manager = PluginManager(plugins: [plugin])
        await manager.notifyFormLoaded()
        #expect(plugin.loadedCount.value == 1)
    }

    @Test func pluginManagerNotifyFieldChanged() async {
        let plugin = TestPlugin()
        let manager = PluginManager(plugins: [plugin])
        await manager.notifyFieldChanged(
            id: FormFieldIdentifier("name"),
            value: "John"
        )
        #expect(plugin.changedCount.value == 1)
    }

    @Test func pluginManagerNotifyFormSubmitted() async {
        let plugin = TestPlugin()
        let manager = PluginManager(plugins: [plugin])
        await manager.notifyFormSubmitted(values: [
            FormFieldIdentifier("name"): "John" as any FormValue,
        ])
        #expect(plugin.submittedCount.value == 1)
    }

    @Test func multiplePlugins() async {
        let plugin1 = TestPlugin(name: "p1")
        let plugin2 = TestPlugin(name: "p2")
        let manager = PluginManager(plugins: [plugin1, plugin2])
        await manager.notifyFormLoaded()
        #expect(plugin1.loadedCount.value == 1)
        #expect(plugin2.loadedCount.value == 1)
    }

    @Test func defaultProtocolExtensionsDoNotCrash() async {
        struct MinimalPlugin: FormPlugin {
            let name = "minimal"
        }
        let plugin = MinimalPlugin()
        await plugin.onFormLoaded()
        await plugin.onFieldChanged(id: FormFieldIdentifier("x"), value: "")
        await plugin.onFormSubmitted(values: [:])
    }
}
