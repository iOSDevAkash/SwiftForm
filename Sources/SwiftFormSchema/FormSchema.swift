import SwiftFormCore

/// Describes the complete schema for a form.
public protocol FormSchema: Sendable {
    associatedtype Section: SectionSchema
    var id: String { get }
    var title: String { get }
    var version: Version { get }
    var sections: [Section] { get }
}
