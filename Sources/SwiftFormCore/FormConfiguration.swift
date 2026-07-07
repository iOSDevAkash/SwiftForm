/// Top-level configuration for a SwiftForm instance.
public struct FormConfiguration: Sendable {

    public var validateOnChange: Bool
    public var validateOnBlur: Bool
    public var debounceInterval: Duration
    public var autosaveEnabled: Bool
    public var accessibilityEnabled: Bool
    public var analyticsEnabled: Bool

    public init(
        validateOnChange: Bool = true,
        validateOnBlur: Bool = true,
        debounceInterval: Duration = .milliseconds(300),
        autosaveEnabled: Bool = false,
        accessibilityEnabled: Bool = true,
        analyticsEnabled: Bool = false
    ) {
        self.validateOnChange = validateOnChange
        self.validateOnBlur = validateOnBlur
        self.debounceInterval = debounceInterval
        self.autosaveEnabled = autosaveEnabled
        self.accessibilityEnabled = accessibilityEnabled
        self.analyticsEnabled = analyticsEnabled
    }
}
