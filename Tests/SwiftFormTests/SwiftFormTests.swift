import Testing
@testable import SwiftForm

@Suite("SwiftForm Umbrella")
struct SwiftFormTests {

    @Test func umbrellaReExportsCore() {
        let id: FormFieldIdentifier = "test"
        #expect(id.rawValue == "test")
    }

    @Test func umbrellaReExportsComponentType() {
        #expect(ComponentType.text.rawValue == "text")
    }

    @Test func umbrellaReExportsState() {
        #expect(InteractionState.normal.rawValue == "normal")
    }

    @Test func umbrellaReExportsValidation() {
        let result = ValidationResult.valid
        #expect(result.isValid == true)
    }
}
