import SwiftFormCore
import SwiftFormSchema

/// Actions a rule can trigger when its condition evaluates to true.
public enum RuleAction: String, Sendable, Hashable, CaseIterable {
    case show
    case hide
    case enable
    case disable
    case require
    case validate
}

/// A conditional rule that triggers an action on a target field.
public protocol FormRule: Sendable {
    var targetField: FormFieldIdentifier { get }
    var action: RuleAction { get }
    func evaluate(context: RuleEvaluationContext) -> Bool
}

/// Context provided to rules during evaluation.
public struct RuleEvaluationContext: Sendable {
    public let formValues: @Sendable (FormFieldIdentifier) -> (any FormValue)?

    public init(formValues: @escaping @Sendable (FormFieldIdentifier) -> (any FormValue)?) {
        self.formValues = formValues
    }
}
