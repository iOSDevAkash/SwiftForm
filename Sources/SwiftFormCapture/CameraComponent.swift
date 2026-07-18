import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme
import SwiftFormComponents

@MainActor
public struct CameraComponent: View {

    public let descriptor: FormFieldDescriptor
    public let store: any FormStateContainer

    public init(descriptor: FormFieldDescriptor, store: any FormStateContainer) {
        self.descriptor = descriptor
        self.store = store
    }

    @Environment(\.themeProvider) private var themeProvider
    @State private var showingImagePicker = false
    @State private var capturedImageData: Data?

    private var tokens: any DesignTokens {
        themeProvider?.tokens ?? DefaultDesignTokens()
    }

    private var hasImage: Bool {
        if let val = store.value(for: descriptor.id)?.stringValue, !val.isEmpty {
            return true
        }
        return capturedImageData != nil
    }

    public var body: some View {
        FormFieldView(descriptor: descriptor, store: store) {
            VStack(alignment: .leading, spacing: tokens.spacing.sm) {
                if let imageData = capturedImageData ?? base64Data(from: store.value(for: descriptor.id)?.stringValue),
                   let platformImg = makeImage(from: imageData) {
                    VStack(alignment: .leading, spacing: tokens.spacing.xs) {
                        platformImg
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .clipShape(RoundedRectangle(cornerRadius: tokens.radius.md))

                        Button(role: .destructive) {
                            capturedImageData = nil
                            store.setValue(nil, for: descriptor.id)
                        } label: {
                            Label("Remove Photo", systemImage: "trash")
                                .font(tokens.typography.caption)
                        }
                    }
                }

                Button {
                    showingImagePicker = true
                } label: {
                    Label(hasImage ? "Retake Photo" : "Take Photo", systemImage: "camera")
                        .font(tokens.typography.body)
                        .foregroundStyle(tokens.colors.primary)
                        .frame(maxWidth: .infinity)
                        .padding(tokens.spacing.sm)
                        .background(tokens.colors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: tokens.radius.md))
                }
                .sheet(isPresented: $showingImagePicker) {
                    #if canImport(UIKit)
                    CameraPickerView { image in
                        if let data = image.jpegData(compressionQuality: 0.8) {
                            capturedImageData = data
                            store.setValue(.string(data.base64EncodedString()), for: descriptor.id)
                        }
                        showingImagePicker = false
                    }
                    #else
                    VStack {
                        Text("Camera capture requires iOS / UIKit")
                            .font(tokens.typography.body)
                        Button("Close") { showingImagePicker = false }
                    }
                    .padding()
                    #endif
                }
            }
        }
    }

    private func base64Data(from base64String: String?) -> Data? {
        guard let base64String, !base64String.isEmpty else { return nil }
        return Data(base64Encoded: base64String)
    }

    private func makeImage(from data: Data) -> Image? {
        #if canImport(UIKit)
        guard let uiImage = UIImage(data: data) else { return nil }
        return Image(uiImage: uiImage)
        #elseif canImport(AppKit)
        guard let nsImage = NSImage(data: data) else { return nil }
        return Image(nsImage: nsImage)
        #else
        return nil
        #endif
    }
}

#if canImport(UIKit)
import UIKit

struct CameraPickerView: UIViewControllerRepresentable {
    var onCapture: (UIImage) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onCapture: onCapture)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let onCapture: (UIImage) -> Void

        init(onCapture: @escaping (UIImage) -> Void) {
            self.onCapture = onCapture
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                onCapture(image)
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
#endif
