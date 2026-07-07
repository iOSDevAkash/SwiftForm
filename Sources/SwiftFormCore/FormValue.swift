/// Protocol that all form field values must conform to.
///
/// Conforming types can be stored, serialized, and compared within the form state engine.
///
import Foundation
public protocol FormValue: Sendable, Hashable, Codable {}

extension String: FormValue {}
extension Int: FormValue {}
extension Double: FormValue {}
extension Bool: FormValue {}
extension Date: FormValue {}
