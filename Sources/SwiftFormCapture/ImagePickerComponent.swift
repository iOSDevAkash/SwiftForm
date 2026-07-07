import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme
import SwiftFormComponents

#if canImport(PhotosUI)
import PhotosUI
#endif

@MainActor
public struct ImagePickerComponent: View {

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

    #if canImport(PhotosUI)
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    #endif

    private var hasImage: Bool {
        store.value(for: descriptor.id)?.stringValue?.isEmpty == false
    }

    public var body: some View {
        FormFieldView(descriptor: descriptor, store: store) {
            #if canImport(PhotosUI)
            VStack(spacing: tokens.spacing.sm) {
                if let selectedImageData,
                   let image = makeImage(from: selectedImageData) {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .clipShape(RoundedRectangle(cornerRadius: tokens.radius.md))
                }

                let bodyFont = tokens.typography.body
                let primaryColor = tokens.colors.primary
                let smSpacing = tokens.spacing.sm
                let surfaceColor = tokens.colors.surface
                let mdRadius = tokens.radius.md
                let labelText = hasImage ? "Change Photo" : "Select Photo"

                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Label(
                        labelText,
                        systemImage: "photo.on.rectangle"
                    )
                    .font(bodyFont)
                    .foregroundStyle(primaryColor)
                    .frame(maxWidth: .infinity)
                    .padding(smSpacing)
                    .background(surfaceColor)
                    .clipShape(RoundedRectangle(cornerRadius: mdRadius))
                }
                .onChange(of: selectedItem) { _, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                            let base64 = data.base64EncodedString()
                            store.setValue(.string(base64), for: descriptor.id)
                        }
                    }
                }
            }
            #else
            Text("Image picker requires PhotosUI")
                .foregroundStyle(tokens.colors.secondary)
            #endif
        }
    }

    #if canImport(UIKit)
    private func platformImage(from data: Data) -> UIImage? {
        UIImage(data: data)
    }

    private func makeImage(from data: Data) -> Image? {
        guard let uiImage = UIImage(data: data) else { return nil }
        return Image(uiImage: uiImage)
    }
    #elseif canImport(AppKit)
    private func platformImage(from data: Data) -> NSImage? {
        NSImage(data: data)
    }

    private func makeImage(from data: Data) -> Image? {
        guard let nsImage = NSImage(data: data) else { return nil }
        return Image(nsImage: nsImage)
    }
    #endif
}
