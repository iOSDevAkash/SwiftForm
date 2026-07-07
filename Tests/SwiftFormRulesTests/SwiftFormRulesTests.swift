import Testing
@testable import SwiftFormRules
import SwiftFormCore

@Suite("SwiftFormRules")
struct SwiftFormRulesTests {

    @Test func ruleActionCases() {
        #expect(RuleAction.allCases.count == 6)
        #expect(RuleAction.show.rawValue == "show")
        #expect(RuleAction.validate.rawValue == "validate")
    }

    @Test func ruleEvaluationContextCreation() {
        let context = RuleEvaluationContext { _ in nil }
        let value = context.formValues("nonexistent")
        #expect(value == nil)
    }
}
