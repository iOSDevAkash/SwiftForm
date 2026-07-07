import SwiftFormCore

/// Form lifecycle events for analytics tracking.
public enum FormEvent: Sendable, Hashable {
    case formLoaded(formID: String)
    case fieldFocused(FormFieldIdentifier)
    case fieldBlurred(FormFieldIdentifier)
    case fieldChanged(FormFieldIdentifier)
    case validationTriggered(FormFieldIdentifier, isValid: Bool)
    case formSubmitted(formID: String)
    case formSubmissionFailed(formID: String, reason: String)
    case formAbandoned(formID: String)
    case sectionViewed(formID: String, sectionID: String)
    case fieldInteraction(FormFieldIdentifier, action: String)
}

/// Provider for analytics event tracking.
///
/// Implement this protocol to integrate with your analytics SDK.
/// SwiftForm fires events; your provider decides how to track them.
public protocol AnalyticsProvider: Sendable {
    func track(_ event: FormEvent) async
}
