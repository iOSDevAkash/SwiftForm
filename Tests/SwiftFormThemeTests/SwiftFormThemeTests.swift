import Testing
@testable import SwiftFormTheme
import SwiftUI

@Suite("DefaultTheme")
struct DefaultThemeTests {

    @Test func defaultTokensExist() {
        let tokens = DefaultDesignTokens()
        _ = tokens.colors
        _ = tokens.spacing
        _ = tokens.typography
        _ = tokens.radius
        _ = tokens.elevation
    }

    @Test func defaultSpacingValues() {
        let spacing = DefaultSpacingTokens()
        #expect(spacing.xxs == 2)
        #expect(spacing.xs == 4)
        #expect(spacing.sm == 8)
        #expect(spacing.md == 16)
        #expect(spacing.lg == 24)
        #expect(spacing.xl == 32)
        #expect(spacing.xxl == 48)
    }

    @Test func defaultRadiusValues() {
        let radius = DefaultRadiusTokens()
        #expect(radius.none == 0)
        #expect(radius.sm == 4)
        #expect(radius.md == 8)
        #expect(radius.lg == 16)
        #expect(radius.full == 9999)
    }

    @Test func defaultElevationValues() {
        let elevation = DefaultElevationTokens()
        #expect(elevation.none == 0)
        #expect(elevation.sm == 2)
        #expect(elevation.md == 4)
        #expect(elevation.lg == 8)
    }

    @Test func defaultThemeProvider() {
        let provider = DefaultThemeProvider()
        _ = provider.tokens
    }

    @Test func customTokensInProvider() {
        let customSpacing = DefaultSpacingTokens()
        let tokens = DefaultDesignTokens(spacing: customSpacing)
        let provider = DefaultThemeProvider(tokens: tokens)
        #expect(provider.tokens.spacing.md == 16)
    }
}
