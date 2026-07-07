import SwiftFormCore

/// Evaluates parsed expression AST nodes against form values.
public struct DefaultExpressionEvaluator: ExpressionEvaluator, Sendable {

    private let parser: ExpressionParser

    public init() {
        self.parser = ExpressionParser()
    }

    public func evaluate(
        _ expressionString: String,
        values: @Sendable (String) -> (any FormValue)?
    ) throws -> Bool {
        let ast = try parser.parse(expressionString)
        return evaluateNode(ast, values: values)
    }

    private func evaluateNode(
        _ node: ExpressionNode,
        values: (String) -> (any FormValue)?
    ) -> Bool {
        switch node {
        case .boolLiteral(let value):
            return value

        case .identifier(let name):
            if let val = values(name) {
                if let b = val as? Bool { return b }
                if let s = val as? String { return !s.isEmpty }
                if let i = val as? Int { return i != 0 }
                return true
            }
            return false

        case .not(let inner):
            return !evaluateNode(inner, values: values)

        case .group(let inner):
            return evaluateNode(inner, values: values)

        case .logical(let left, let op, let right):
            let l = evaluateNode(left, values: values)
            switch op {
            case .and: return l && evaluateNode(right, values: values)
            case .or: return l || evaluateNode(right, values: values)
            }

        case .comparison(let left, let op, let right):
            let lVal = resolveValue(left, values: values)
            let rVal = resolveValue(right, values: values)
            return compare(lVal, op, rVal)

        default:
            return false
        }
    }

    private func resolveValue(
        _ node: ExpressionNode,
        values: (String) -> (any FormValue)?
    ) -> ComparableValue {
        switch node {
        case .identifier(let name):
            guard let val = values(name) else { return .null }
            if let s = val as? String { return .string(s) }
            if let i = val as? Int { return .number(Double(i)) }
            if let d = val as? Double { return .number(d) }
            if let b = val as? Bool { return .bool(b) }
            return .null
        case .stringLiteral(let s): return .string(s)
        case .intLiteral(let i): return .number(Double(i))
        case .doubleLiteral(let d): return .number(d)
        case .boolLiteral(let b): return .bool(b)
        default: return .null
        }
    }

    private func compare(
        _ left: ComparableValue,
        _ op: ComparisonOp,
        _ right: ComparableValue
    ) -> Bool {
        switch op {
        case .equal: return left == right
        case .notEqual: return left != right
        case .greaterThan: return left > right
        case .greaterEqual: return left >= right
        case .lessThan: return left < right
        case .lessEqual: return left <= right
        }
    }
}

// MARK: - Internal Comparable Value

enum ComparableValue: Sendable, Equatable, Comparable {
    case string(String)
    case number(Double)
    case bool(Bool)
    case null

    static func < (lhs: ComparableValue, rhs: ComparableValue) -> Bool {
        switch (lhs, rhs) {
        case (.number(let a), .number(let b)): return a < b
        case (.string(let a), .string(let b)): return a < b
        case (.bool(let a), .bool(let b)): return !a && b
        default: return false
        }
    }
}
