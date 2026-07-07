import SwiftFormCore

/// Protocol for form-level state management.
@MainActor
public protocol FormStateContainer: AnyObject {
    var fieldIdentifiers: [FormFieldIdentifier] { get }
    func interactionState(for id: FormFieldIdentifier) -> InteractionState
    func value(for id: FormFieldIdentifier) -> AnyCodableValue?
    func setValue(_ value: AnyCodableValue?, for id: FormFieldIdentifier)
    func validationMessages(for id: FormFieldIdentifier) -> [String]
    func isValid(for id: FormFieldIdentifier) -> Bool
    func setInteractionState(_ state: InteractionState, for id: FormFieldIdentifier)
}
