import SwiftFormCore
import SwiftFormPlugins

/// Plugin that forwards form lifecycle events to an AnalyticsDispatcher.
public struct AnalyticsPlugin: FormPlugin, Sendable {

    public let name: String = "analytics"
    private let dispatcher: AnalyticsDispatcher
    private let formID: String

    public init(formID: String, dispatcher: AnalyticsDispatcher) {
        self.formID = formID
        self.dispatcher = dispatcher
    }

    public func onFormLoaded() async {
        await dispatcher.track(.formLoaded(formID: formID))
    }

    public func onFieldChanged(id: FormFieldIdentifier, value: any FormValue) async {
        await dispatcher.track(.fieldChanged(id))
    }

    public func onFormSubmitted(values: [FormFieldIdentifier: any FormValue]) async {
        await dispatcher.track(.formSubmitted(formID: formID))
    }
}
