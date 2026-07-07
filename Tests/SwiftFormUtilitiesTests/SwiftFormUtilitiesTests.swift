import Testing
@testable import SwiftFormUtilities

@Suite("SwiftFormUtilities")
struct SwiftFormUtilitiesTests {

    @Test func stringIsBlank() {
        #expect("".isBlank == true)
        #expect("   ".isBlank == true)
        #expect("\n\t".isBlank == true)
        #expect("hello".isBlank == false)
    }
}
