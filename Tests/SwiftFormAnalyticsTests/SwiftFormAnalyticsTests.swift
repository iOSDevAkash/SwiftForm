import Testing
import Foundation
@testable import SwiftFormAnalytics
@testable import SwiftFormPlugins
import SwiftFormCore

struct MockAnalyticsProvider: AnalyticsProvider, Sendable {
    let trackedEvents: LockedArray<FormEvent>

    init() {
        self.trackedEvents = LockedArray()
    }

    func track(_ event: FormEvent) async {
        trackedEvents.append(event)
    }
}

final class LockedArray<T: Sendable>: @unchecked Sendable {
    private var items: [T] = []
    private let lock = NSLock()

    init() {}

    func append(_ item: T) {
        lock.lock()
        items.append(item)
        lock.unlock()
    }

    var count: Int {
        lock.lock()
        defer { lock.unlock() }
        return items.count
    }

    var all: [T] {
        lock.lock()
        defer { lock.unlock() }
        return items
    }
}

@Suite("AnalyticsDispatcher")
struct AnalyticsDispatcherTests {

    @Test func trackEventToProviders() async {
        let provider = MockAnalyticsProvider()
        let dispatcher = AnalyticsDispatcher(providers: [provider])

        await dispatcher.track(.formLoaded(formID: "test"))
        await dispatcher.track(.fieldFocused(FormFieldIdentifier("name")))

        #expect(provider.trackedEvents.count == 2)
    }

    @Test func addProviderDynamically() async {
        let dispatcher = AnalyticsDispatcher()
        let provider = MockAnalyticsProvider()
        await dispatcher.addProvider(provider)

        await dispatcher.track(.formSubmitted(formID: "test"))
        #expect(provider.trackedEvents.count == 1)
    }

    @Test func multipleProviders() async {
        let p1 = MockAnalyticsProvider()
        let p2 = MockAnalyticsProvider()
        let dispatcher = AnalyticsDispatcher(providers: [p1, p2])

        await dispatcher.track(.formLoaded(formID: "test"))
        #expect(p1.trackedEvents.count == 1)
        #expect(p2.trackedEvents.count == 1)
    }
}

@Suite("FormEvent")
struct FormEventTests {

    @Test func allEventCasesHashable() {
        let events: Set<FormEvent> = [
            .formLoaded(formID: "a"),
            .fieldFocused(FormFieldIdentifier("f")),
            .fieldBlurred(FormFieldIdentifier("f")),
            .fieldChanged(FormFieldIdentifier("f")),
            .validationTriggered(FormFieldIdentifier("f"), isValid: true),
            .formSubmitted(formID: "a"),
            .formSubmissionFailed(formID: "a", reason: "err"),
            .formAbandoned(formID: "a"),
            .sectionViewed(formID: "a", sectionID: "s"),
            .fieldInteraction(FormFieldIdentifier("f"), action: "tap"),
        ]
        #expect(events.count == 10)
    }
}

@Suite("AnalyticsPlugin")
struct AnalyticsPluginTests {

    @Test func pluginForwardsLifecycleEvents() async {
        let provider = MockAnalyticsProvider()
        let dispatcher = AnalyticsDispatcher(providers: [provider])
        let plugin = AnalyticsPlugin(formID: "reg", dispatcher: dispatcher)

        #expect(plugin.name == "analytics")

        await plugin.onFormLoaded()
        await plugin.onFieldChanged(
            id: FormFieldIdentifier("email"),
            value: "test@test.com"
        )
        await plugin.onFormSubmitted(values: [:])

        #expect(provider.trackedEvents.count == 3)
    }
}
