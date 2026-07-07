import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme

@MainActor
public struct RatingComponent: View {

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

    private var maxRating: Int {
        descriptor.metadata?["maxRating"]?.intValue ?? 5
    }

    private var currentRating: Int {
        store.value(for: descriptor.id)?.intValue ?? 0
    }

    public var body: some View {
        FormFieldView(descriptor: descriptor, store: store) {
            HStack(spacing: tokens.spacing.xs) {
                ForEach(1...maxRating, id: \.self) { star in
                    Button {
                        let newValue = star == currentRating ? 0 : star
                        store.setValue(.int(newValue), for: descriptor.id)
                    } label: {
                        Image(systemName: star <= currentRating ? "star.fill" : "star")
                            .foregroundStyle(
                                star <= currentRating
                                    ? tokens.colors.warning
                                    : tokens.colors.border
                            )
                            .imageScale(.large)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
