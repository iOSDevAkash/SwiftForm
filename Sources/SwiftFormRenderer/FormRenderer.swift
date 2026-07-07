import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState

/// Protocol for form rendering engines.
@MainActor
public protocol FormRenderer {
    func render(schema: any FormSchema, state: any FormStateContainer) -> AnyView
}
