import Foundation

/// Common utility extensions shared across SwiftForm modules.

extension String {
    /// Whether the string contains only whitespace or is empty.
    public var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
