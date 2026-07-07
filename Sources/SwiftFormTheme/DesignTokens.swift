import SwiftUI
import SwiftFormCore

/// Complete set of design tokens for theming.
public protocol DesignTokens: Sendable {
    var colors: any ColorTokens { get }
    var spacing: any SpacingTokens { get }
    var typography: any TypographyTokens { get }
    var radius: any RadiusTokens { get }
    var elevation: any ElevationTokens { get }
}

public protocol ColorTokens: Sendable {
    var primary: Color { get }
    var secondary: Color { get }
    var background: Color { get }
    var surface: Color { get }
    var error: Color { get }
    var warning: Color { get }
    var success: Color { get }
    var info: Color { get }
    var onPrimary: Color { get }
    var onBackground: Color { get }
    var border: Color { get }
    var disabled: Color { get }
}

public protocol SpacingTokens: Sendable {
    var xxs: CGFloat { get }
    var xs: CGFloat { get }
    var sm: CGFloat { get }
    var md: CGFloat { get }
    var lg: CGFloat { get }
    var xl: CGFloat { get }
    var xxl: CGFloat { get }
}

public protocol TypographyTokens: Sendable {
    var largeTitle: Font { get }
    var title: Font { get }
    var headline: Font { get }
    var body: Font { get }
    var caption: Font { get }
    var footnote: Font { get }
}

public protocol RadiusTokens: Sendable {
    var none: CGFloat { get }
    var sm: CGFloat { get }
    var md: CGFloat { get }
    var lg: CGFloat { get }
    var full: CGFloat { get }
}

public protocol ElevationTokens: Sendable {
    var none: CGFloat { get }
    var sm: CGFloat { get }
    var md: CGFloat { get }
    var lg: CGFloat { get }
}
