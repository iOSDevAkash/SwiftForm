import SwiftUI
import SwiftFormCore
import SwiftFormSchema

/// Registry for mapping component types to their factories.
///
/// Applications register custom components here; the renderer
/// consults the registry to resolve each field in the schema.
@MainActor
public protocol ComponentRegistry {
    func register(_ type: ComponentType, factory: any ComponentFactory)
    func factory(for type: ComponentType) -> (any ComponentFactory)?
}
