import SwiftFormCore
import SwiftFormSchema
import Observation

/// Concrete form-level state store.
///
/// Manages all field states, tracks dirty fields, and provides
/// form-wide state queries.
@MainActor
@Observable
public final class FormStateStore: FormStateContainer {

    private var fields: [FormFieldIdentifier: AnyFieldState] = [:]
    private var dirtyFields: Set<FormFieldIdentifier> = []

    public var fieldIdentifiers: [FormFieldIdentifier] {
        Array(fields.keys)
    }

    public var isDirty: Bool {
        !dirtyFields.isEmpty
    }

    public var allValid: Bool {
        fields.values.allSatisfy { $0.isValid }
    }

    public init() {}

    // MARK: - Field Registration

    public func register(id: FormFieldIdentifier, initialValue: AnyCodableValue? = nil) {
        guard fields[id] == nil else { return }
        fields[id] = AnyFieldState(id: id, value: initialValue)
    }

    public func register(from schema: FormDescriptor) {
        for section in schema.sections {
            for field in section.fields {
                register(id: field.id, initialValue: field.defaultValue)
            }
        }
    }

    // MARK: - Value Access

    public func value(for id: FormFieldIdentifier) -> AnyCodableValue? {
        fields[id]?.value
    }

    public func setValue(_ value: AnyCodableValue?, for id: FormFieldIdentifier) {
        guard let state = fields[id] else { return }
        state.value = value
        dirtyFields.insert(id)
    }

    // MARK: - Interaction State

    public func interactionState(for id: FormFieldIdentifier) -> InteractionState {
        fields[id]?.interactionState ?? .normal
    }

    public func setInteractionState(_ state: InteractionState, for id: FormFieldIdentifier) {
        fields[id]?.interactionState = state
    }

    // MARK: - Validation State

    public func setValidation(isValid: Bool, messages: [String], for id: FormFieldIdentifier) {
        guard let state = fields[id] else { return }
        state.isValid = isValid
        state.validationMessages = messages
    }

    public func validationMessages(for id: FormFieldIdentifier) -> [String] {
        fields[id]?.validationMessages ?? []
    }

    public func isValid(for id: FormFieldIdentifier) -> Bool {
        fields[id]?.isValid ?? true
    }

    // MARK: - Dirty Tracking

    public func markClean() {
        dirtyFields.removeAll()
    }

    public func isDirty(_ id: FormFieldIdentifier) -> Bool {
        dirtyFields.contains(id)
    }

    // MARK: - Bulk Operations

    public func allValues() -> [FormFieldIdentifier: AnyCodableValue] {
        var result: [FormFieldIdentifier: AnyCodableValue] = [:]
        for (id, state) in fields {
            if let value = state.value {
                result[id] = value
            }
        }
        return result
    }

    public func reset() {
        for state in fields.values {
            state.value = nil
            state.interactionState = .normal
            state.isValid = true
            state.validationMessages = []
        }
        dirtyFields.removeAll()
    }

    public func reset(to values: [FormFieldIdentifier: AnyCodableValue]) {
        reset()
        for (id, value) in values {
            setValue(value, for: id)
        }
        dirtyFields.removeAll()
    }
}

// MARK: - Internal Type-Erased Field State

@MainActor
@Observable
final class AnyFieldState {
    let id: FormFieldIdentifier
    var value: AnyCodableValue?
    var interactionState: InteractionState
    var isValid: Bool
    var validationMessages: [String]

    init(id: FormFieldIdentifier, value: AnyCodableValue? = nil) {
        self.id = id
        self.value = value
        self.interactionState = .normal
        self.isValid = true
        self.validationMessages = []
    }
}
