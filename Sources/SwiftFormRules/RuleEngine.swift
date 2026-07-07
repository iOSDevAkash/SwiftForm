import SwiftFormCore
import SwiftFormSchema

/// Concrete rule that evaluates an expression string to trigger an action.
public struct ExpressionRule: FormRule, Sendable {

    public let targetField: FormFieldIdentifier
    public let action: RuleAction
    public let expression: String

    private let evaluator: DefaultExpressionEvaluator

    public init(
        targetField: FormFieldIdentifier,
        action: RuleAction,
        expression: String
    ) {
        self.targetField = targetField
        self.action = action
        self.expression = expression
        self.evaluator = DefaultExpressionEvaluator()
    }

    public func evaluate(context: RuleEvaluationContext) -> Bool {
        do {
            return try evaluator.evaluate(expression) { name in
                context.formValues(FormFieldIdentifier(name))
            }
        } catch {
            return false
        }
    }
}

/// Engine that evaluates all rules against current form state.
public struct RuleEngine: Sendable {

    private var rules: [any FormRule]

    public init(rules: [any FormRule] = []) {
        self.rules = rules
    }

    public mutating func addRule(_ rule: any FormRule) {
        rules.append(rule)
    }

    /// Evaluate all rules and return the actions that should be applied.
    public func evaluate(
        values: @escaping @Sendable (FormFieldIdentifier) -> (any FormValue)?
    ) -> [RuleResult] {
        let context = RuleEvaluationContext(formValues: values)
        return rules.compactMap { rule in
            let matches = rule.evaluate(context: context)
            return RuleResult(
                targetField: rule.targetField,
                action: rule.action,
                isActive: matches
            )
        }
    }
}

/// Result of evaluating a single rule.
public struct RuleResult: Sendable, Hashable {
    public let targetField: FormFieldIdentifier
    public let action: RuleAction
    public let isActive: Bool
}
