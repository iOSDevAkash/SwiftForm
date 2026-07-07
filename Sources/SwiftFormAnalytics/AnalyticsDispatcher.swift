import SwiftFormCore

/// Dispatches form events to registered analytics providers.
public actor AnalyticsDispatcher {

    private var providers: [any AnalyticsProvider]

    public init(providers: [any AnalyticsProvider] = []) {
        self.providers = providers
    }

    public func addProvider(_ provider: any AnalyticsProvider) {
        providers.append(provider)
    }

    public func track(_ event: FormEvent) async {
        for provider in providers {
            await provider.track(event)
        }
    }
}
