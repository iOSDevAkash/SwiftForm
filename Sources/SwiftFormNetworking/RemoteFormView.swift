import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme
import SwiftFormRenderer
import SwiftFormLayouts

/// Loading state for remote form fetching.
public enum RemoteFormLoadState: Sendable {
    case loading
    case loaded(FormDescriptor)
    case error(String)
}

/// SwiftUI view that fetches a form schema from a remote provider and renders it.
///
/// Usage:
/// ```swift
/// RemoteFormView(
///     url: "https://api.example.com/forms/registration",
///     provider: URLSchemaProvider()
/// ) { values in
///     print("Submitted:", values)
/// }
/// ```
@MainActor
public struct RemoteFormView: View {

    private let url: String
    private let provider: any SchemaProvider
    private let cachePolicy: CachePolicy
    private let layout: (any FormLayoutEngine)?
    private let onSubmit: (([FormFieldIdentifier: AnyCodableValue]) -> Void)?

    @State private var loadState: RemoteFormLoadState = .loading

    public init(
        url: String,
        provider: any SchemaProvider,
        cachePolicy: CachePolicy = .memory,
        layout: (any FormLayoutEngine)? = nil,
        onSubmit: (([FormFieldIdentifier: AnyCodableValue]) -> Void)? = nil
    ) {
        self.url = url
        self.provider = provider
        self.cachePolicy = cachePolicy
        self.layout = layout
        self.onSubmit = onSubmit
    }

    public var body: some View {
        Group {
            switch loadState {
            case .loading:
                loadingView
            case .loaded(let descriptor):
                FormView(schema: descriptor, layout: layout, onSubmit: onSubmit)
            case .error(let message):
                errorView(message: message)
            }
        }
        .task {
            await loadSchema()
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Loading form...")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.orange)
            Text("Failed to load form")
                .font(.headline)
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("Retry") {
                loadState = .loading
                Task {
                    await loadSchema()
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func loadSchema() async {
        do {
            let schema = try await provider.fetchSchema(id: url, cachePolicy: cachePolicy)
            guard let descriptor = schema as? FormDescriptor else {
                loadState = .error("Unsupported schema type")
                return
            }
            loadState = .loaded(descriptor)
        } catch {
            loadState = .error(error.localizedDescription)
        }
    }
}
