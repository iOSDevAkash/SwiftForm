import SwiftFormCore

/// AST nodes for parsed expressions.
public indirect enum ExpressionNode: Sendable {
    case identifier(String)
    case stringLiteral(String)
    case intLiteral(Int)
    case doubleLiteral(Double)
    case boolLiteral(Bool)
    case comparison(left: ExpressionNode, op: ComparisonOp, right: ExpressionNode)
    case logical(left: ExpressionNode, op: LogicalOp, right: ExpressionNode)
    case not(ExpressionNode)
    case group(ExpressionNode)
}

public enum ComparisonOp: String, Sendable {
    case equal = "=="
    case notEqual = "!="
    case greaterThan = ">"
    case greaterEqual = ">="
    case lessThan = "<"
    case lessEqual = "<="
}

public enum LogicalOp: String, Sendable {
    case and = "&&"
    case or = "||"
}

/// Recursive-descent parser for expression strings.
///
/// Grammar:
/// ```
/// expr     := orExpr
/// orExpr   := andExpr ("||" andExpr)*
/// andExpr  := notExpr ("&&" notExpr)*
/// notExpr  := "!" notExpr | compare
/// compare  := primary (("==" | "!=" | ">" | ">=" | "<" | "<=") primary)?
/// primary  := "(" expr ")" | literal | identifier
/// ```
public struct ExpressionParser: Sendable {

    public init() {}

    public func parse(_ input: String) throws -> ExpressionNode {
        let lexer = ExpressionLexer()
        let tokens = try lexer.tokenize(input)
        var pos = 0
        let result = try parseOr(tokens: tokens, pos: &pos)

        guard tokens[pos].kind == .eof else {
            throw FormError.expressionError(
                reason: "Unexpected token at position \(tokens[pos].position)"
            )
        }

        return result
    }

    private func parseOr(tokens: [Token], pos: inout Int) throws -> ExpressionNode {
        var left = try parseAnd(tokens: tokens, pos: &pos)
        while case .or = tokens[pos].kind {
            pos += 1
            let right = try parseAnd(tokens: tokens, pos: &pos)
            left = .logical(left: left, op: .or, right: right)
        }
        return left
    }

    private func parseAnd(tokens: [Token], pos: inout Int) throws -> ExpressionNode {
        var left = try parseNot(tokens: tokens, pos: &pos)
        while case .and = tokens[pos].kind {
            pos += 1
            let right = try parseNot(tokens: tokens, pos: &pos)
            left = .logical(left: left, op: .and, right: right)
        }
        return left
    }

    private func parseNot(tokens: [Token], pos: inout Int) throws -> ExpressionNode {
        if case .not = tokens[pos].kind {
            pos += 1
            let expr = try parseNot(tokens: tokens, pos: &pos)
            return .not(expr)
        }
        return try parseComparison(tokens: tokens, pos: &pos)
    }

    private func parseComparison(tokens: [Token], pos: inout Int) throws -> ExpressionNode {
        let left = try parsePrimary(tokens: tokens, pos: &pos)

        let op: ComparisonOp?
        switch tokens[pos].kind {
        case .equal: op = .equal
        case .notEqual: op = .notEqual
        case .greaterThan: op = .greaterThan
        case .greaterEqual: op = .greaterEqual
        case .lessThan: op = .lessThan
        case .lessEqual: op = .lessEqual
        default: op = nil
        }

        guard let compOp = op else { return left }
        pos += 1
        let right = try parsePrimary(tokens: tokens, pos: &pos)
        return .comparison(left: left, op: compOp, right: right)
    }

    private func parsePrimary(tokens: [Token], pos: inout Int) throws -> ExpressionNode {
        switch tokens[pos].kind {
        case .leftParen:
            pos += 1
            let expr = try parseOr(tokens: tokens, pos: &pos)
            guard case .rightParen = tokens[pos].kind else {
                throw FormError.expressionError(
                    reason: "Expected ')' at position \(tokens[pos].position)"
                )
            }
            pos += 1
            return .group(expr)
        case .identifier(let name):
            pos += 1
            return .identifier(name)
        case .stringLiteral(let value):
            pos += 1
            return .stringLiteral(value)
        case .intLiteral(let value):
            pos += 1
            return .intLiteral(value)
        case .doubleLiteral(let value):
            pos += 1
            return .doubleLiteral(value)
        case .boolLiteral(let value):
            pos += 1
            return .boolLiteral(value)
        default:
            throw FormError.expressionError(
                reason: "Unexpected token at position \(tokens[pos].position)"
            )
        }
    }
}
