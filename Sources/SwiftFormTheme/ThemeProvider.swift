import SwiftUI
import SwiftFormCore

/// Provides theme tokens to the SwiftUI view hierarchy via environment.
public protocol ThemeProvider: Sendable {
    var tokens: any DesignTokens { get }
}

/// Environment key for injecting the theme provider.
private struct ThemeProviderKey: EnvironmentKey {
    static let defaultValue: (any ThemeProvider)? = nil
}

extension EnvironmentValues {
    public var themeProvider: (any ThemeProvider)? {
        get { self[ThemeProviderKey.self] }
        set { self[ThemeProviderKey.self] = newValue }
    }
}
