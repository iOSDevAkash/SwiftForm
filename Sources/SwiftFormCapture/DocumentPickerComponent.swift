import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme
import SwiftFormComponents

#if canImport(UIKit)
import UIKit
import UniformTypeIdentifiers

@MainActor
public struct DocumentPickerComponent: View {

    public let descriptor: FormFieldDescriptor
    public let store: any FormStateContainer

    public init(descriptor: FormFieldDescriptor, store: any FormStateContainer) {
        self.descriptor = descriptor
        self.store = store
    }

    @Environment(\.themeProvider) private var themeProvider
    @State private var isPresented = false
    @State private var selectedFileName: String?

    private var tokens: any DesignTokens {
        themeProvider?.tokens ?? DefaultDesignTokens()
    }

    private var allowedTypes: [UTType] {
        if let types = descriptor.metadata?["allowedTypes"]?.stringValue {
            return types.split(separator: ",").compactMap { UTType(filenameExtension: String($0.trimmingCharacters(in: .whitespaces))) }
        }
        return [.pdf, .plainText, .image, .data]
    }

    public var body: some View {
        FormFieldView(descriptor: descriptor, store: store) {
            Button {
                isPresented = true
            } label: {
                HStack {
                    Image(systemName: "doc.badge.plus")
                        .foregroundStyle(tokens.colors.primary)
                    Text(selectedFileName ?? "Select Document")
                        .font(tokens.typography.body)
                        .foregroundStyle(
                            selectedFileName != nil
                                ? tokens.colors.onBackground
                                : tokens.colors.disabled
                        )
                    Spacer()
                    if selectedFileName != nil {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(tokens.colors.success)
                    }
                }
                .padding(tokens.spacing.sm)
                .background(tokens.colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: tokens.radius.md))
            }
            .buttonStyle(.plain)
            .sheet(isPresented: $isPresented) {
                DocumentPickerView(
                    allowedTypes: allowedTypes,
                    onPick: { url in
                        selectedFileName = url.lastPathComponent
                        store.setValue(.string(url.absoluteString), for: descriptor.id)
                    }
                )
            }
        }
    }
}

struct DocumentPickerView: UIViewControllerRepresentable {

    let allowedTypes: [UTType]
    let onPick: (URL) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: allowedTypes)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick)
    }

    final class Coordinator: NSObject, UIDocumentPickerDelegate {
        let onPick: (URL) -> Void

        init(onPick: @escaping (URL) -> Void) {
            self.onPick = onPick
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let url = urls.first {
                onPick(url)
            }
        }
    }
}

#else

@MainActor
public struct DocumentPickerComponent: View {

    public let descriptor: FormFieldDescriptor
    public let store: any FormStateContainer

    public init(descriptor: FormFieldDescriptor, store: any FormStateContainer) {
        self.descriptor = descriptor
        self.store = store
    }

    public var body: some View {
        FormFieldView(descriptor: descriptor, store: store) {
            Text("Document picker requires UIKit")
                .foregroundStyle(.secondary)
        }
    }
}

#endif
