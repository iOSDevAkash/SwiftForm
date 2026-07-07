import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme
import SwiftFormComponents

@MainActor
public struct SignatureComponent: View {

    public let descriptor: FormFieldDescriptor
    public let store: any FormStateContainer

    public init(descriptor: FormFieldDescriptor, store: any FormStateContainer) {
        self.descriptor = descriptor
        self.store = store
    }

    @Environment(\.themeProvider) private var themeProvider
    @State private var lines: [[CGPoint]] = []
    @State private var currentLine: [CGPoint] = []

    private var tokens: any DesignTokens {
        themeProvider?.tokens ?? DefaultDesignTokens()
    }

    private var strokeColor: Color {
        if let hex = descriptor.metadata?["strokeColor"]?.stringValue {
            return Color(hex: hex)
        }
        return tokens.colors.onBackground
    }

    private var lineWidth: CGFloat {
        CGFloat(descriptor.metadata?["lineWidth"]?.doubleValue ?? 2.5)
    }

    public var body: some View {
        FormFieldView(descriptor: descriptor, store: store) {
            VStack(spacing: tokens.spacing.xs) {
                Canvas { context, _ in
                    for line in lines {
                        drawLine(line, in: &context)
                    }
                    drawLine(currentLine, in: &context)
                }
                .frame(height: 150)
                .background(tokens.colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: tokens.radius.md))
                .overlay(
                    RoundedRectangle(cornerRadius: tokens.radius.md)
                        .stroke(tokens.colors.border, lineWidth: 1)
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            currentLine.append(value.location)
                        }
                        .onEnded { _ in
                            lines.append(currentLine)
                            currentLine = []
                            syncToStore()
                        }
                )

                HStack {
                    if lines.isEmpty {
                        Text("Sign above")
                            .font(tokens.typography.caption)
                            .foregroundStyle(tokens.colors.disabled)
                    }
                    Spacer()
                    if !lines.isEmpty {
                        Button("Clear") {
                            lines = []
                            currentLine = []
                            store.setValue(.string(""), for: descriptor.id)
                        }
                        .font(tokens.typography.caption)
                        .foregroundStyle(tokens.colors.error)
                    }
                }
            }
        }
    }

    private func drawLine(_ points: [CGPoint], in context: inout GraphicsContext) {
        guard points.count > 1 else { return }
        var path = Path()
        path.move(to: points[0])
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        context.stroke(path, with: .color(strokeColor), lineWidth: lineWidth)
    }

    private func syncToStore() {
        let pointData = lines.map { line in
            line.map { "\($0.x),\($0.y)" }.joined(separator: ";")
        }.joined(separator: "|")
        store.setValue(.string(pointData), for: descriptor.id)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
