import SwiftUI
import SwiftForm

struct AirbnbColorTokens: ColorTokens, Sendable {
    var primary: Color { Color(red: 1.0, green: 0.35, blue: 0.37) }
    var secondary: Color { Color(red: 0.28, green: 0.28, blue: 0.28) }
    var background: Color { .white }
    var surface: Color { Color(red: 0.97, green: 0.97, blue: 0.97) }
    var error: Color { Color(red: 0.76, green: 0.15, blue: 0.18) }
    var warning: Color { Color(red: 1.0, green: 0.7, blue: 0.0) }
    var success: Color { Color(red: 0.0, green: 0.65, blue: 0.42) }
    var info: Color { Color(red: 0.0, green: 0.51, blue: 0.84) }
    var onPrimary: Color { .white }
    var onBackground: Color { Color(red: 0.13, green: 0.13, blue: 0.13) }
    var border: Color { Color(red: 0.87, green: 0.87, blue: 0.87) }
    var disabled: Color { Color(red: 0.72, green: 0.72, blue: 0.72) }
}

struct AirbnbSpacingTokens: SpacingTokens, Sendable {
    var xxs: CGFloat { 4 }
    var xs: CGFloat { 8 }
    var sm: CGFloat { 12 }
    var md: CGFloat { 20 }
    var lg: CGFloat { 32 }
    var xl: CGFloat { 48 }
    var xxl: CGFloat { 64 }
}

struct AirbnbTypographyTokens: TypographyTokens, Sendable {
    var largeTitle: Font { .system(.largeTitle, design: .rounded, weight: .bold) }
    var title: Font { .system(.title3, design: .rounded, weight: .semibold) }
    var headline: Font { .system(.headline, design: .rounded, weight: .semibold) }
    var body: Font { .system(.body, design: .rounded) }
    var caption: Font { .system(.caption, design: .rounded) }
    var footnote: Font { .system(.footnote, design: .rounded) }
}

struct AirbnbRadiusTokens: RadiusTokens, Sendable {
    var none: CGFloat { 0 }
    var sm: CGFloat { 8 }
    var md: CGFloat { 12 }
    var lg: CGFloat { 16 }
    var full: CGFloat { 9999 }
}

struct ThemeShowcase: View {

    private let schema = SwiftFormDSL.form(
        "themed",
        title: "List Your Space",
        submitTitle: "Get Started"
    ) {
        section("basics", title: "Basic Info") {
            textField("title", title: "Listing Title", placeholder: "Cozy apartment in downtown", required: true)
            textEditor("description", title: "Description", placeholder: "Describe what makes your space special...")
            dropdown("propertyType", title: "Property Type", options: [
                option("apartment", label: "Apartment"),
                option("house", label: "House"),
                option("cabin", label: "Cabin"),
                option("villa", label: "Villa"),
                option("loft", label: "Loft"),
            ], placeholder: "Select type", required: true)
        }
        section("details", title: "Details & Amenities") {
            toggle("wifi", title: "Wi-Fi")
            toggle("kitchen", title: "Kitchen")
            toggle("parking", title: "Free Parking")
            toggle("pool", title: "Pool")
            segment("cancellation", title: "Cancellation Policy", options: [
                option("flexible", label: "Flexible"),
                option("moderate", label: "Moderate"),
                option("strict", label: "Strict"),
            ])
        }
        section("pricing", title: "Pricing") {
            textField("price", title: "Price per Night", placeholder: "$0", required: true)
            toggle("instantBook", title: "Instant Book")
            rating("quality", title: "Self-Rated Quality")
        }
    }

    private let airbnbTheme = DefaultThemeProvider(
        tokens: DefaultDesignTokens(
            colors: AirbnbColorTokens(),
            spacing: AirbnbSpacingTokens(),
            typography: AirbnbTypographyTokens(),
            radius: AirbnbRadiusTokens()
        )
    )

    var body: some View {
        FormView(schema: schema) { values in
            print("Listing submitted:")
            for (key, value) in values {
                print("  \(key.rawValue): \(value)")
            }
        }
        .environment(\.themeProvider, airbnbTheme)
    }
}
