import SwiftFormCore

/// Token types produced by the expression lexer.
public enum TokenKind: Sendable, Hashable {
    case identifier(String)
    case stringLiteral(String)
    case intLiteral(Int)
    case doubleLiteral(Double)
    case boolLiteral(Bool)
    case equal          // ==
    case notEqual       // !=
    case greaterThan    // >
    case greaterEqual   // >=
    case lessThan       // <
    case lessEqual      // <=
    case and            // &&
    case or             // ||
    case not            // !
    case leftParen      // (
    case rightParen     // )
    case eof
}

/// A token with its position in the source string.
public struct Token: Sendable {
    public let kind: TokenKind
    public let position: Int
}

/// Tokenizes expression strings into a stream of tokens.
public struct ExpressionLexer: Sendable {

    public init() {}

    public func tokenize(_ input: String) throws -> [Token] {
        var tokens: [Token] = []
        let chars = Array(input)
        var pos = 0

        while pos < chars.count {
            let ch = chars[pos]

            if ch.isWhitespace {
                pos += 1
                continue
            }

            if ch == "=" && pos + 1 < chars.count && chars[pos + 1] == "=" {
                tokens.append(Token(kind: .equal, position: pos))
                pos += 2
            } else if ch == "!" && pos + 1 < chars.count && chars[pos + 1] == "=" {
                tokens.append(Token(kind: .notEqual, position: pos))
                pos += 2
            } else if ch == ">" && pos + 1 < chars.count && chars[pos + 1] == "=" {
                tokens.append(Token(kind: .greaterEqual, position: pos))
                pos += 2
            } else if ch == "<" && pos + 1 < chars.count && chars[pos + 1] == "=" {
                tokens.append(Token(kind: .lessEqual, position: pos))
                pos += 2
            } else if ch == "&" && pos + 1 < chars.count && chars[pos + 1] == "&" {
                tokens.append(Token(kind: .and, position: pos))
                pos += 2
            } else if ch == "|" && pos + 1 < chars.count && chars[pos + 1] == "|" {
                tokens.append(Token(kind: .or, position: pos))
                pos += 2
            } else if ch == ">" {
                tokens.append(Token(kind: .greaterThan, position: pos))
                pos += 1
            } else if ch == "<" {
                tokens.append(Token(kind: .lessThan, position: pos))
                pos += 1
            } else if ch == "!" {
                tokens.append(Token(kind: .not, position: pos))
                pos += 1
            } else if ch == "(" {
                tokens.append(Token(kind: .leftParen, position: pos))
                pos += 1
            } else if ch == ")" {
                tokens.append(Token(kind: .rightParen, position: pos))
                pos += 1
            } else if ch == "\"" {
                let start = pos
                pos += 1
                var str = ""
                while pos < chars.count && chars[pos] != "\"" {
                    if chars[pos] == "\\" && pos + 1 < chars.count {
                        pos += 1
                        str.append(chars[pos])
                    } else {
                        str.append(chars[pos])
                    }
                    pos += 1
                }
                guard pos < chars.count else {
                    throw FormError.expressionError(reason: "Unterminated string at position \(start)")
                }
                pos += 1
                tokens.append(Token(kind: .stringLiteral(str), position: start))
            } else if ch.isNumber || (ch == "-" && pos + 1 < chars.count && chars[pos + 1].isNumber) {
                let start = pos
                var numStr = String(ch)
                pos += 1
                var hasDot = false
                while pos < chars.count && (chars[pos].isNumber || (chars[pos] == "." && !hasDot)) {
                    if chars[pos] == "." { hasDot = true }
                    numStr.append(chars[pos])
                    pos += 1
                }
                if hasDot, let val = Double(numStr) {
                    tokens.append(Token(kind: .doubleLiteral(val), position: start))
                } else if let val = Int(numStr) {
                    tokens.append(Token(kind: .intLiteral(val), position: start))
                } else {
                    throw FormError.expressionError(reason: "Invalid number '\(numStr)' at position \(start)")
                }
            } else if ch.isLetter || ch == "_" {
                let start = pos
                var ident = ""
                while pos < chars.count && (chars[pos].isLetter || chars[pos].isNumber || chars[pos] == "_" || chars[pos] == ".") {
                    ident.append(chars[pos])
                    pos += 1
                }
                if ident == "true" {
                    tokens.append(Token(kind: .boolLiteral(true), position: start))
                } else if ident == "false" {
                    tokens.append(Token(kind: .boolLiteral(false), position: start))
                } else {
                    tokens.append(Token(kind: .identifier(ident), position: start))
                }
            } else {
                throw FormError.expressionError(reason: "Unexpected character '\(ch)' at position \(pos)")
            }
        }

        tokens.append(Token(kind: .eof, position: pos))
        return tokens
    }
}
