import Testing
@testable import SwiftFormPlugins
import SwiftFormCore

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
}
