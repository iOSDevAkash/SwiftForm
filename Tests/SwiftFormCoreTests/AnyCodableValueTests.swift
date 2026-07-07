import Testing
import Foundation
@testable import SwiftFormCore

@Suite("AnyCodableValue")
struct AnyCodableValueTests {

    @Test func stringLiteral() {
        let val: AnyCodableValue = "hello"
        #expect(val.stringValue == "hello")
    }

    @Test func intLiteral() {
        let val: AnyCodableValue = 42
        #expect(val.intValue == 42)
    }

    @Test func doubleLiteral() {
        let val: AnyCodableValue = 3.14
        #expect(val.doubleValue == 3.14)
    }

    @Test func boolLiteral() {
        let val: AnyCodableValue = true
        #expect(val.boolValue == true)
    }

    @Test func nullLiteral() {
        let val: AnyCodableValue = nil
        #expect(val.isNull)
    }

    @Test func arrayLiteral() {
        let val: AnyCodableValue = ["a", "b", "c"]
        #expect(val.arrayValue?.count == 3)
    }

    @Test func dictionaryLiteral() {
        let val: AnyCodableValue = ["key": "value"]
        #expect(val.dictionaryValue?["key"]?.stringValue == "value")
    }

    @Test func jsonRoundTrip() throws {
        let original: AnyCodableValue = ["name": "test", "count": 5, "active": true]
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(AnyCodableValue.self, from: data)
        #expect(decoded == original)
    }

    @Test func wrongAccessorReturnsNil() {
        let val: AnyCodableValue = "string"
        #expect(val.intValue == nil)
        #expect(val.boolValue == nil)
        #expect(val.arrayValue == nil)
    }

    @Test func doubleFromInt() {
        let val: AnyCodableValue = 42
        #expect(val.doubleValue == 42.0)
    }
}
