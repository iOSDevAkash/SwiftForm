import Testing
import Foundation
@testable import SwiftFormAnalytics
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
}
