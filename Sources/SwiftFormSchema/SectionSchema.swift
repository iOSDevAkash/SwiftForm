import SwiftFormCore

/// Describes the schema for a section containing fields.
public protocol SectionSchema: Sendable {
    associatedtype Field: FieldSchema
    var id: String { get }
    var title: String? { get }
    var subtitle: String? { get }
    var fields: [Field] { get }
}
