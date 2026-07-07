import SwiftUI

/// Default design tokens with sensible system-aligned values.
public struct DefaultDesignTokens: DesignTokens, Sendable {

    public let colors: any ColorTokens
    public let spacing: any SpacingTokens
    public let typography: any TypographyTokens
    public let radius: any RadiusTokens
    public let elevation: any ElevationTokens

    public init(
        colors: any ColorTokens = DefaultColorTokens(),
        spacing: any SpacingTokens = DefaultSpacingTokens(),
        typography: any TypographyTokens = DefaultTypographyTokens(),
        radius: any RadiusTokens = DefaultRadiusTokens(),
        elevation: any ElevationTokens = DefaultElevationTokens()
    ) {
        self.colors = colors
        self.spacing = spacing
        self.typography = typography
        self.radius = radius
        self.elevation = elevation
    }
}

// MARK: - Default Color Tokens

public struct DefaultColorTokens: ColorTokens, Sendable {
    public var primary: Color { .accentColor }
    public var secondary: Color { .secondary }
    #if canImport(UIKit)
    public var background: Color { Color(.systemBackground) }
    public var surface: Color { Color(.secondarySystemBackground) }
    public var onBackground: Color { Color(.label) }
    public var border: Color { Color(.separator) }
    public var disabled: Color { Color(.tertiaryLabel) }
    #else
    public var background: Color { Color(nsColor: .windowBackgroundColor) }
    public var surface: Color { Color(nsColor: .controlBackgroundColor) }
    public var onBackground: Color { Color(nsColor: .labelColor) }
    public var border: Color { Color(nsColor: .separatorColor) }
    public var disabled: Color { Color(nsColor: .tertiaryLabelColor) }
    #endif
    public var error: Color { .red }
    public var warning: Color { .orange }
    public var success: Color { .green }
    public var info: Color { .blue }
    public var onPrimary: Color { .white }

    public init() {}
}

// MARK: - Default Spacing Tokens

public struct DefaultSpacingTokens: SpacingTokens, Sendable {
    public var xxs: CGFloat { 2 }
    public var xs: CGFloat { 4 }
    public var sm: CGFloat { 8 }
    public var md: CGFloat { 16 }
    public var lg: CGFloat { 24 }
    public var xl: CGFloat { 32 }
    public var xxl: CGFloat { 48 }

    public init() {}
}

// MARK: - Default Typography Tokens

public struct DefaultTypographyTokens: TypographyTokens, Sendable {
    public var largeTitle: Font { .largeTitle }
    public var title: Font { .title2 }
    public var headline: Font { .headline }
    public var body: Font { .body }
    public var caption: Font { .caption }
    public var footnote: Font { .footnote }

    public init() {}
}

// MARK: - Default Radius Tokens

public struct DefaultRadiusTokens: RadiusTokens, Sendable {
    public var none: CGFloat { 0 }
    public var sm: CGFloat { 4 }
    public var md: CGFloat { 8 }
    public var lg: CGFloat { 16 }
    public var full: CGFloat { 9999 }

    public init() {}
}

// MARK: - Default Elevation Tokens

public struct DefaultElevationTokens: ElevationTokens, Sendable {
    public var none: CGFloat { 0 }
    public var sm: CGFloat { 2 }
    public var md: CGFloat { 4 }
    public var lg: CGFloat { 8 }

    public init() {}
}

// MARK: - Default Theme Provider

public struct DefaultThemeProvider: ThemeProvider, Sendable {
    public let tokens: any DesignTokens

    public init(tokens: any DesignTokens = DefaultDesignTokens()) {
        self.tokens = tokens
    }
}
