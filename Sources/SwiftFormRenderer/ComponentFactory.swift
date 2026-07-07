import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme

/// Resolves a component type to a SwiftUI view.
///
/// `AnyView` is permitted here — this is the only boundary in the framework
/// where type erasure is allowed, because the registry maps arbitrary
/// registered component types to SwiftUI views at runtime.
@MainActor
public protocol ComponentFactory {
    func makeView(for field: any FieldSchema, state: any FormStateContainer) -> AnyView?
}
