import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme

@MainActor
public struct ProgressComponent: View {

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

    private var progress: Double {
        store.value(for: descriptor.id)?.doubleValue ?? 0
    }

    private var showLabel: Bool {
        descriptor.metadata?["showLabel"]?.boolValue ?? true
    }

    public var body: some View {
        FormFieldView(descriptor: descriptor, store: store) {
            VStack(alignment: .leading, spacing: tokens.spacing.xs) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: tokens.radius.full)
                            .fill(tokens.colors.surface)
                            .frame(height: 8)

                        RoundedRectangle(cornerRadius: tokens.radius.full)
                            .fill(tokens.colors.primary)
                            .frame(
                                width: geometry.size.width * min(max(progress, 0), 1),
                                height: 8
                            )
                    }
                }
                .frame(height: 8)

                if showLabel {
                    Text("\(Int(progress * 100))%")
                        .font(tokens.typography.caption)
                        .foregroundStyle(tokens.colors.secondary)
                }
            }
        }
    }
}
