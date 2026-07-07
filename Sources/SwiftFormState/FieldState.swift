import SwiftFormCore
import Observation

/// Observable state container for a single form field.
@MainActor
@Observable
public final class FieldState<Value: FormValue> {

    public let id: FormFieldIdentifier

    public private(set) var value: Value?
    public private(set) var interactionState: InteractionState
    public private(set) var validationMessages: [String]
    public private(set) var isValid: Bool

    public init(
        id: FormFieldIdentifier,
        initialValue: Value? = nil,
        interactionState: InteractionState = .normal
    ) {
        self.id = id
        self.value = initialValue
        self.interactionState = interactionState
        self.validationMessages = []
        self.isValid = true
    }
}
