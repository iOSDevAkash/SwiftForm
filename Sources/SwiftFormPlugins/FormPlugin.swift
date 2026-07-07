import SwiftFormCore

/// Lifecycle hooks that plugins can implement to extend form behavior.
public protocol FormPlugin: Sendable {
    var name: String { get }
    func onFormLoaded() async
    func onFieldChanged(id: FormFieldIdentifier, value: any FormValue) async
    func onFormSubmitted(values: [FormFieldIdentifier: any FormValue]) async
}

extension FormPlugin {
    public func onFormLoaded() async {}
    public func onFieldChanged(id: FormFieldIdentifier, value: any FormValue) async {}
    public func onFormSubmitted(values: [FormFieldIdentifier: any FormValue]) async {}
}

/// Context provided to plugins during their lifecycle.
public struct PluginContext: Sendable {
    public let formID: String
    public let configuration: FormConfiguration

    public init(formID: String, configuration: FormConfiguration) {
        self.formID = formID
        self.configuration = configuration
    }
}
