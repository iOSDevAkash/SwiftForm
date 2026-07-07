import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme

@MainActor
public struct OTPComponent: View {

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

    private var digitCount: Int {
        descriptor.metadata?["digitCount"]?.intValue ?? 6
    }

    @State private var digits: [String] = []
    @FocusState private var focusedIndex: Int?

    public var body: some View {
        FormFieldView(descriptor: descriptor, store: store) {
            HStack(spacing: tokens.spacing.sm) {
                ForEach(0..<digitCount, id: \.self) { index in
                    TextField("", text: digitBinding(at: index))
                        .frame(width: 44, height: 48)
                        .multilineTextAlignment(.center)
                        .font(.system(.title2, design: .monospaced, weight: .semibold))
                        .background(tokens.colors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: tokens.radius.sm))
                        .overlay(
                            RoundedRectangle(cornerRadius: tokens.radius.sm)
                                .stroke(
                                    focusedIndex == index ? tokens.colors.primary : tokens.colors.border,
                                    lineWidth: focusedIndex == index ? 2 : 1
                                )
                        )
                        .focused($focusedIndex, equals: index)
                        #if os(iOS)
                        .keyboardType(.numberPad)
                        #endif
                }
            }
            .onAppear {
                if digits.isEmpty {
                    digits = Array(repeating: "", count: digitCount)
                }
            }
        }
    }

    private func digitBinding(at index: Int) -> Binding<String> {
        Binding(
            get: { index < digits.count ? digits[index] : "" },
            set: { newValue in
                guard index < digits.count else { return }
                let filtered = String(newValue.filter(\.isNumber).prefix(1))
                digits[index] = filtered
                syncToStore()
                if !filtered.isEmpty && index < digitCount - 1 {
                    focusedIndex = index + 1
                }
            }
        )
    }

    private func syncToStore() {
        let code = digits.joined()
        store.setValue(.string(code), for: descriptor.id)
    }
}
