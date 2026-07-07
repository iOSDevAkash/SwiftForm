// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SwiftForm",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(
            name: "SwiftForm",
            targets: ["SwiftForm"]
        ),
        .library(
            name: "SwiftFormCore",
            targets: ["SwiftFormCore"]
        ),
        .library(
            name: "SwiftFormSchema",
            targets: ["SwiftFormSchema"]
        ),
        .library(
            name: "SwiftFormState",
            targets: ["SwiftFormState"]
        ),
        .library(
            name: "SwiftFormValidation",
            targets: ["SwiftFormValidation"]
        ),
        .library(
            name: "SwiftFormRules",
            targets: ["SwiftFormRules"]
        ),
        .library(
            name: "SwiftFormTheme",
            targets: ["SwiftFormTheme"]
        ),
        .library(
            name: "SwiftFormDSL",
            targets: ["SwiftFormDSL"]
        ),
        .library(
            name: "SwiftFormRenderer",
            targets: ["SwiftFormRenderer"]
        ),
        .library(
            name: "SwiftFormComponents",
            targets: ["SwiftFormComponents"]
        ),
        .library(
            name: "SwiftFormLayouts",
            targets: ["SwiftFormLayouts"]
        ),
        .library(
            name: "SwiftFormJSON",
            targets: ["SwiftFormJSON"]
        ),
        .library(
            name: "SwiftFormPlugins",
            targets: ["SwiftFormPlugins"]
        ),
        .library(
            name: "SwiftFormAccessibility",
            targets: ["SwiftFormAccessibility"]
        ),
        .library(
            name: "SwiftFormAnalytics",
            targets: ["SwiftFormAnalytics"]
        ),
        .library(
            name: "SwiftFormNetworking",
            targets: ["SwiftFormNetworking"]
        ),
        .library(
            name: "SwiftFormUtilities",
            targets: ["SwiftFormUtilities"]
        ),
        .library(
            name: "SwiftFormCapture",
            targets: ["SwiftFormCapture"]
        ),
    ],
    targets: [
        // MARK: - Core

        .target(
            name: "SwiftFormCore"
        ),

        .target(
            name: "SwiftFormUtilities",
            dependencies: ["SwiftFormCore"]
        ),

        // MARK: - Schema & State

        .target(
            name: "SwiftFormSchema",
            dependencies: ["SwiftFormCore"]
        ),

        .target(
            name: "SwiftFormState",
            dependencies: ["SwiftFormCore", "SwiftFormSchema"]
        ),

        // MARK: - Logic Engines

        .target(
            name: "SwiftFormValidation",
            dependencies: ["SwiftFormCore", "SwiftFormSchema"]
        ),

        .target(
            name: "SwiftFormRules",
            dependencies: ["SwiftFormCore", "SwiftFormSchema"]
        ),

        // MARK: - Presentation

        .target(
            name: "SwiftFormTheme",
            dependencies: ["SwiftFormCore"]
        ),

        .target(
            name: "SwiftFormDSL",
            dependencies: ["SwiftFormCore", "SwiftFormSchema"]
        ),

        .target(
            name: "SwiftFormComponents",
            dependencies: [
                "SwiftFormCore",
                "SwiftFormSchema",
                "SwiftFormState",
                "SwiftFormTheme",
            ]
        ),

        .target(
            name: "SwiftFormRenderer",
            dependencies: [
                "SwiftFormCore",
                "SwiftFormSchema",
                "SwiftFormState",
                "SwiftFormTheme",
                "SwiftFormComponents",
            ]
        ),

        .target(
            name: "SwiftFormLayouts",
            dependencies: [
                "SwiftFormCore",
                "SwiftFormSchema",
                "SwiftFormState",
                "SwiftFormTheme",
                "SwiftFormRenderer",
            ]
        ),

        // MARK: - Data & Networking

        .target(
            name: "SwiftFormJSON",
            dependencies: ["SwiftFormCore", "SwiftFormSchema"]
        ),

        .target(
            name: "SwiftFormNetworking",
            dependencies: [
                "SwiftFormCore",
                "SwiftFormSchema",
                "SwiftFormJSON",
                "SwiftFormState",
                "SwiftFormTheme",
                "SwiftFormRenderer",
                "SwiftFormLayouts",
            ]
        ),

        // MARK: - Extensions

        .target(
            name: "SwiftFormPlugins",
            dependencies: ["SwiftFormCore"]
        ),

        .target(
            name: "SwiftFormAccessibility",
            dependencies: ["SwiftFormCore", "SwiftFormSchema"]
        ),

        .target(
            name: "SwiftFormAnalytics",
            dependencies: ["SwiftFormCore"]
        ),

        // MARK: - Platform Bridging

        .target(
            name: "SwiftFormCapture",
            dependencies: [
                "SwiftFormCore",
                "SwiftFormSchema",
                "SwiftFormState",
                "SwiftFormComponents",
            ]
        ),

        // MARK: - Umbrella

        .target(
            name: "SwiftForm",
            dependencies: [
                "SwiftFormCore",
                "SwiftFormUtilities",
                "SwiftFormSchema",
                "SwiftFormState",
                "SwiftFormValidation",
                "SwiftFormRules",
                "SwiftFormTheme",
                "SwiftFormDSL",
                "SwiftFormRenderer",
                "SwiftFormComponents",
                "SwiftFormLayouts",
                "SwiftFormJSON",
                "SwiftFormPlugins",
                "SwiftFormAccessibility",
                "SwiftFormAnalytics",
                "SwiftFormNetworking",
                "SwiftFormCapture",
            ]
        ),

        // MARK: - Tests

        .testTarget(
            name: "SwiftFormCoreTests",
            dependencies: ["SwiftFormCore"]
        ),
        .testTarget(
            name: "SwiftFormUtilitiesTests",
            dependencies: ["SwiftFormUtilities"]
        ),
        .testTarget(
            name: "SwiftFormSchemaTests",
            dependencies: ["SwiftFormSchema"]
        ),
        .testTarget(
            name: "SwiftFormStateTests",
            dependencies: ["SwiftFormState"]
        ),
        .testTarget(
            name: "SwiftFormValidationTests",
            dependencies: ["SwiftFormValidation"]
        ),
        .testTarget(
            name: "SwiftFormRulesTests",
            dependencies: ["SwiftFormRules"]
        ),
        .testTarget(
            name: "SwiftFormThemeTests",
            dependencies: ["SwiftFormTheme"]
        ),
        .testTarget(
            name: "SwiftFormDSLTests",
            dependencies: ["SwiftFormDSL"]
        ),
        .testTarget(
            name: "SwiftFormRendererTests",
            dependencies: ["SwiftFormRenderer"]
        ),
        .testTarget(
            name: "SwiftFormComponentsTests",
            dependencies: ["SwiftFormComponents"]
        ),
        .testTarget(
            name: "SwiftFormLayoutsTests",
            dependencies: ["SwiftFormLayouts", "SwiftFormRenderer", "SwiftFormState"]
        ),
        .testTarget(
            name: "SwiftFormJSONTests",
            dependencies: ["SwiftFormJSON"]
        ),
        .testTarget(
            name: "SwiftFormPluginsTests",
            dependencies: ["SwiftFormPlugins"]
        ),
        .testTarget(
            name: "SwiftFormAccessibilityTests",
            dependencies: ["SwiftFormAccessibility"]
        ),
        .testTarget(
            name: "SwiftFormAnalyticsTests",
            dependencies: ["SwiftFormAnalytics"]
        ),
        .testTarget(
            name: "SwiftFormNetworkingTests",
            dependencies: [
                "SwiftFormNetworking",
                "SwiftFormJSON",
                "SwiftFormSchema",
                "SwiftFormRenderer",
                "SwiftFormState",
            ]
        ),
        .testTarget(
            name: "SwiftFormCaptureTests",
            dependencies: ["SwiftFormCapture"]
        ),
        .testTarget(
            name: "SwiftFormTests",
            dependencies: ["SwiftForm"]
        ),
    ]
)
