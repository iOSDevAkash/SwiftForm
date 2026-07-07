import SwiftFormCore

/// Manages plugin lifecycle and dispatches form events to registered plugins.
public actor PluginManager {

    private var plugins: [any FormPlugin] = []

    public init(plugins: [any FormPlugin] = []) {
        self.plugins = plugins
    }

    public func register(_ plugin: any FormPlugin) {
        plugins.append(plugin)
    }

    public func notifyFormLoaded() async {
        for plugin in plugins {
            await plugin.onFormLoaded()
        }
    }

    public func notifyFieldChanged(id: FormFieldIdentifier, value: any FormValue) async {
        for plugin in plugins {
            await plugin.onFieldChanged(id: id, value: value)
        }
    }

    public func notifyFormSubmitted(values: [FormFieldIdentifier: any FormValue]) async {
        for plugin in plugins {
            await plugin.onFormSubmitted(values: values)
        }
    }

    public var registeredPlugins: [any FormPlugin] {
        plugins
    }
}
