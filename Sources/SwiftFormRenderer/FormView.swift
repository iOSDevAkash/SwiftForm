import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme
import SwiftFormComponents

/// Public entry point for rendering a schema-driven form.
///
/// Usage:
/// ```swift
/// let schema = SwiftFormDSL.form("registration", title: "Register") {
///     section("profile", title: "Profile") {
///         textField("name", title: "Full Name", required: true)
///         emailField("email", title: "Email", required: true)
///     }
/// }
///
/// FormView(schema: schema)
/// ```
@MainActor
public struct FormView: View {

    private let schema: FormDescriptor
    private let renderer: any FormRenderer
    private let onSubmit: (([FormFieldIdentifier: AnyCodableValue]) -> Void)?

    @State private var store: FormStateStore

    @Environment(\.themeProvider) private var themeProvider

    public init(
        schema: FormDescriptor,
        layout: (any FormLayoutEngine)? = nil,
        renderer: (any FormRenderer)? = nil,
        onSubmit: (([FormFieldIdentifier: AnyCodableValue]) -> Void)? = nil
    ) {
        self.schema = schema
        self.renderer = renderer ?? DefaultFormRenderer(layout: layout)
        self.onSubmit = onSubmit
        self._store = State(initialValue: {
            let s = FormStateStore()
            s.register(from: schema)
            return s
        }())
    }

    public init(
        schema: FormDescriptor,
        store: FormStateStore,
        layout: (any FormLayoutEngine)? = nil,
        renderer: (any FormRenderer)? = nil,
        onSubmit: (([FormFieldIdentifier: AnyCodableValue]) -> Void)? = nil
    ) {
        self.schema = schema
        self.renderer = renderer ?? DefaultFormRenderer(layout: layout)
        self.onSubmit = onSubmit
        self._store = State(initialValue: store)
    }

    public var body: some View {
        VStack(spacing: 0) {
            renderer.render(schema: schema, state: store)

            if let onSubmit {
                submitButton(onSubmit: onSubmit)
            }
        }
        .environment(\.themeProvider, themeProvider ?? DefaultThemeProvider())
    }

    @ViewBuilder
    private func submitButton(onSubmit: @escaping ([FormFieldIdentifier: AnyCodableValue]) -> Void) -> some View {
        let tokens = (themeProvider ?? DefaultThemeProvider()).tokens

        Button {
            onSubmit(store.allValues())
        } label: {
            Text(schema.submitTitle ?? "Submit")
                .font(tokens.typography.headline)
                .foregroundStyle(tokens.colors.onPrimary)
                .frame(maxWidth: .infinity)
                .padding(tokens.spacing.md)
                .background(tokens.colors.primary)
                .clipShape(RoundedRectangle(cornerRadius: tokens.radius.md))
        }
        .buttonStyle(.plain)
        .padding(tokens.spacing.md)
    }
}
