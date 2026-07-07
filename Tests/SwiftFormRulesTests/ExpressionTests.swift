import Testing
@testable import SwiftFormRules
import SwiftFormCore

@Suite("Expression Lexer")
struct ExpressionLexerTests {

    let lexer = ExpressionLexer()

    @Test func simpleComparison() throws {
        let tokens = try lexer.tokenize("age >= 18")
        #expect(tokens.count == 4) // identifier, >=, int, eof
    }

    @Test func stringLiteral() throws {
        let tokens = try lexer.tokenize("country == \"India\"")
        #expect(tokens.count == 4)
        if case .stringLiteral(let s) = tokens[2].kind {
            #expect(s == "India")
        } else {
            Issue.record("Expected string literal")
        }
    }

    @Test func booleanLiteral() throws {
        let tokens = try lexer.tokenize("active == true")
        #expect(tokens.count == 4)
        if case .boolLiteral(let b) = tokens[2].kind {
            #expect(b == true)
        }
    }

    @Test func logicalOperators() throws {
        let tokens = try lexer.tokenize("a && b || c")
        #expect(tokens.count == 6) // a, &&, b, ||, c, eof
    }

    @Test func parentheses() throws {
        let tokens = try lexer.tokenize("(a || b) && c")
        #expect(tokens.count == 8) // (, a, ||, b, ), &&, c, eof
    }

    @Test func doubleLiteral() throws {
        let tokens = try lexer.tokenize("price > 9.99")
        if case .doubleLiteral(let d) = tokens[2].kind {
            #expect(d == 9.99)
        }
    }

    @Test func unterminatedString() {
        #expect(throws: FormError.self) {
            _ = try lexer.tokenize("name == \"unterminated")
        }
    }
}

@Suite("Expression Parser")
struct ExpressionParserTests {

    let parser = ExpressionParser()

    @Test func simpleEquality() throws {
        let ast = try parser.parse("name == \"John\"")
        if case .comparison(let left, let op, let right) = ast {
            if case .identifier(let id) = left { #expect(id == "name") }
            #expect(op == .equal)
            if case .stringLiteral(let s) = right { #expect(s == "John") }
        } else {
            Issue.record("Expected comparison")
        }
    }

    @Test func logicalAnd() throws {
        let ast = try parser.parse("a == 1 && b == 2")
        if case .logical(_, let op, _) = ast {
            #expect(op == .and)
        } else {
            Issue.record("Expected logical and")
        }
    }

    @Test func notExpression() throws {
        let ast = try parser.parse("!active")
        if case .not(let inner) = ast {
            if case .identifier(let name) = inner {
                #expect(name == "active")
            }
        } else {
            Issue.record("Expected not")
        }
    }

    @Test func groupedExpression() throws {
        let ast = try parser.parse("(a || b) && c")
        if case .logical(let left, let op, _) = ast {
            #expect(op == .and)
            if case .group = left {} else {
                Issue.record("Expected group on left")
            }
        }
    }

    @Test func invalidExpressionThrows() {
        #expect(throws: FormError.self) {
            _ = try parser.parse("==")
        }
    }
}

@Suite("Expression Evaluator")
struct ExpressionEvaluatorTests {

    let evaluator = DefaultExpressionEvaluator()

    func values(_ dict: [String: any FormValue]) -> @Sendable (String) -> (any FormValue)? {
        let sendableDict: [String: String] = dict.compactMapValues { $0 as? String }
        let intDict: [String: Int] = dict.compactMapValues { $0 as? Int }
        let boolDict: [String: Bool] = dict.compactMapValues { $0 as? Bool }
        return { key in
            if let s = sendableDict[key] { return s }
            if let i = intDict[key] { return i }
            if let b = boolDict[key] { return b }
            return nil
        }
    }

    @Test func equalityString() throws {
        let result = try evaluator.evaluate(
            "country == \"India\"",
            values: values(["country": "India"])
        )
        #expect(result == true)
    }

    @Test func equalityStringFails() throws {
        let result = try evaluator.evaluate(
            "country == \"India\"",
            values: values(["country": "US"])
        )
        #expect(result == false)
    }

    @Test func numericComparison() throws {
        let result = try evaluator.evaluate(
            "age >= 18",
            values: values(["age": 21])
        )
        #expect(result == true)
    }

    @Test func numericLessThan() throws {
        let result = try evaluator.evaluate(
            "age >= 18",
            values: values(["age": 15])
        )
        #expect(result == false)
    }

    @Test func booleanValue() throws {
        let result = try evaluator.evaluate(
            "active == true",
            values: values(["active": true])
        )
        #expect(result == true)
    }

    @Test func logicalAnd() throws {
        let result = try evaluator.evaluate(
            "age >= 18 && country == \"US\"",
            values: values(["age": 21, "country": "US"])
        )
        #expect(result == true)
    }

    @Test func logicalOr() throws {
        let result = try evaluator.evaluate(
            "country == \"US\" || country == \"India\"",
            values: values(["country": "India"])
        )
        #expect(result == true)
    }

    @Test func negation() throws {
        let result = try evaluator.evaluate(
            "!active",
            values: values(["active": false])
        )
        #expect(result == true)
    }

    @Test func missingValueIsFalsy() throws {
        let result = try evaluator.evaluate(
            "missing == true",
            values: values([:])
        )
        #expect(result == false)
    }

    @Test func complexExpression() throws {
        let result = try evaluator.evaluate(
            "(age >= 18 && country == \"US\") || admin == true",
            values: values(["age": 15, "country": "IN", "admin": true])
        )
        #expect(result == true)
    }
}

@Suite("Rule Engine")
struct RuleEngineTests {

    @Test func expressionRule() {
        let rule = ExpressionRule(
            targetField: "business_fields",
            action: .show,
            expression: "account_type == \"business\""
        )
        let context = RuleEvaluationContext { id in
            if id.rawValue == "account_type" { return "business" as String }
            return nil
        }
        #expect(rule.evaluate(context: context) == true)
    }

    @Test func ruleEngineEvaluation() {
        var engine = RuleEngine()
        engine.addRule(ExpressionRule(
            targetField: "shipping",
            action: .show,
            expression: "needs_shipping == true"
        ))
        engine.addRule(ExpressionRule(
            targetField: "company_name",
            action: .require,
            expression: "account_type == \"business\""
        ))

        let results = engine.evaluate { id in
            switch id.rawValue {
            case "needs_shipping": return true as Bool
            case "account_type": return "personal" as String
            default: return nil
            }
        }

        #expect(results.count == 2)
        let shipping = results.first { $0.targetField.rawValue == "shipping" }
        let company = results.first { $0.targetField.rawValue == "company_name" }
        #expect(shipping?.isActive == true)
        #expect(company?.isActive == false)
    }
}
