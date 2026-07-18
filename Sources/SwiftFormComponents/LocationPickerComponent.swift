import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme
import MapKit

@MainActor
public struct LocationPickerComponent: View {

    public let descriptor: FormFieldDescriptor
    public let store: any FormStateContainer

    public init(descriptor: FormFieldDescriptor, store: any FormStateContainer) {
        self.descriptor = descriptor
        self.store = store
    }

    @Environment(\.themeProvider) private var themeProvider
    @State private var locationText: String = ""
    @State private var position: MapCameraPosition = .automatic

    private var tokens: any DesignTokens {
        themeProvider?.tokens ?? DefaultDesignTokens()
    }

    private var isReadOnly: Bool {
        let state = store.interactionState(for: descriptor.id)
        return state == .readOnly || state == .disabled
    }

    public var body: some View {
        FormFieldView(descriptor: descriptor, store: store) {
            VStack(alignment: .leading, spacing: tokens.spacing.xs) {
                HStack {
                    Image(systemName: descriptor.componentType == .map ? "map" : "location")
                        .foregroundStyle(tokens.colors.primary)

                    TextField(
                        descriptor.placeholder ?? "Enter location or coordinates",
                        text: $locationText
                    )
                    .font(tokens.typography.body)
                    .disabled(isReadOnly)
                    .onChange(of: locationText) { _, newValue in
                        store.setValue(.string(newValue), for: descriptor.id)
                    }
                }
                .padding(tokens.spacing.sm)
                .background(tokens.colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: tokens.radius.md))

                if descriptor.componentType == .map {
                    Map(position: $position)
                        .frame(height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: tokens.radius.md))
                }
            }
            .onAppear {
                if let initial = store.value(for: descriptor.id)?.stringValue {
                    locationText = initial
                } else if let defaultVal = descriptor.defaultValue?.stringValue {
                    locationText = defaultVal
                }
            }
        }
    }
}
