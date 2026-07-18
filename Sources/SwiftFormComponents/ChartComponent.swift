import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme

#if canImport(Charts)
import Charts
#endif

@MainActor
public struct ChartComponent: View {

    public let descriptor: FormFieldDescriptor
    public let store: any FormStateContainer

    public init(descriptor: FormFieldDescriptor, store: any FormStateContainer) {
        self.descriptor = descriptor
        self.store = store
    }

    @Environment(\.themeProvider) private var themeProvider

    private var tokens: any DesignTokens {
        themeProvider?.tokens ?? DefaultDesignTokens()
    }

    private var chartItems: [(label: String, value: Double)] {
        if let options = descriptor.options, !options.isEmpty {
            return options.map { option in
                let val = option.value.doubleValue ?? option.value.intValue.map(Double.init) ?? 1.0
                return (option.label, val)
            }
        }
        return [
            ("Category A", 40),
            ("Category B", 75),
            ("Category C", 55),
            ("Category D", 90)
        ]
    }

    public var body: some View {
        FormFieldView(descriptor: descriptor, store: store) {
            VStack(alignment: .leading, spacing: tokens.spacing.xs) {
                #if canImport(Charts)
                if #available(iOS 16.0, macOS 13.0, *) {
                    Chart(chartItems, id: \.label) { item in
                        BarMark(
                            x: .value("Category", item.label),
                            y: .value("Value", item.value)
                        )
                        .foregroundStyle(tokens.colors.primary)
                    }
                    .frame(height: 160)
                    .padding(tokens.spacing.xs)
                } else {
                    fallbackChartView
                }
                #else
                fallbackChartView
                #endif
            }
        }
    }

    private var fallbackChartView: some View {
        HStack(alignment: .bottom, spacing: tokens.spacing.sm) {
            ForEach(chartItems, id: \.label) { item in
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(tokens.colors.primary)
                        .frame(height: CGFloat(item.value))
                    Text(item.label)
                        .font(tokens.typography.caption)
                        .foregroundStyle(tokens.colors.secondary)
                }
            }
        }
        .frame(height: 140)
    }
}
