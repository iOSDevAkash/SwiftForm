import SwiftFormCore
import SwiftFormSchema
import Observation

/// Interaction states a field can be in.
public enum InteractionState: String, Sendable, Hashable, CaseIterable {
    case normal
    case focused
    case active
    case loading
    case disabled
    case readOnly
    case selected
    case hovered
    case pressed
    case success
    case info
    case warning
    case error
    case skeleton
    case collapsed
    case expanded
    case hidden
}
