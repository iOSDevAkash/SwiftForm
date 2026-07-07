import Testing
@testable import SwiftFormCapture
import SwiftFormCore

@Suite("SwiftFormCapture")
struct SwiftFormCaptureTests {

    @Test func captureComponentProtocolExists() {
        func acceptCapture(_ component: any CaptureComponent) {
            #expect(type(of: component.requiresUIKit) == Bool.self)
        }
    }
}
