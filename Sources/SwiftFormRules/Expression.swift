import SwiftFormCore

/// A node in an expression tree for the custom expression evaluator.
public protocol Expression: Sendable {
    func evaluate(with values: @Sendable (String) -> (any FormValue)?) -> Bool
}

/// Evaluates parsed expressions against form state.
public protocol ExpressionEvaluator: Sendable {
    func evaluate(_ expressionString: String, values: @Sendable (String) -> (any FormValue)?) throws -> Bool
}
