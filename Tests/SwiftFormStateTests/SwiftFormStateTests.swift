import Testing
@testable import SwiftFormState
import SwiftFormCore

@Suite("SwiftFormState")
struct SwiftFormStateTests {

    @Test func interactionStateCases() {
        #expect(InteractionState.allCases.count == 17)
        #expect(InteractionState.normal.rawValue == "normal")
        #expect(InteractionState.hidden.rawValue == "hidden")
    }

    @MainActor
    @Test func fieldStateInitialization() {
        let state = FieldState<String>(id: "username", initialValue: "test")
        #expect(state.id.rawValue == "username")
        #expect(state.value == "test")
        #expect(state.interactionState == .normal)
        #expect(state.isValid == true)
        #expect(state.validationMessages.isEmpty)
    }

    @MainActor
    @Test func fieldStateDefaultNilValue() {
        let state = FieldState<Int>(id: "age")
        #expect(state.value == nil)
    }
}
