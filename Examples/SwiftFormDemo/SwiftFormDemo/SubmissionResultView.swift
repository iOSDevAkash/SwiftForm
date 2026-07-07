import SwiftUI
import SwiftForm

struct SubmissionResultView: View {

    let title: String
    let values: [FormFieldIdentifier: AnyCodableValue]
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(.green)
                            Text("Submitted Successfully")
                                .font(.headline)
                            Text("\(values.count) fields captured")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .listRowBackground(Color.clear)
                }

                Section("Submitted Values") {
                    ForEach(sortedEntries, id: \.key) { key, value in
                        HStack(alignment: .top) {
                            Text(key.rawValue.camelCaseToTitle)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .frame(width: 120, alignment: .leading)
                            Spacer()
                            Text(value.displayString)
                                .font(.subheadline)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { onDismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    private var sortedEntries: [(key: FormFieldIdentifier, value: AnyCodableValue)] {
        values.sorted { $0.key.rawValue < $1.key.rawValue }
    }
}

extension AnyCodableValue {
    var displayString: String {
        switch self {
        case .string(let v): v.isEmpty ? "—" : v
        case .int(let v): "\(v)"
        case .double(let v): String(format: "%.2f", v)
        case .bool(let v): v ? "Yes" : "No"
        case .date(let v): v.formatted(date: .abbreviated, time: .shortened)
        case .array(let v): v.map(\.displayString).joined(separator: ", ")
        case .dictionary(let v): v.map { "\($0.key): \($0.value.displayString)" }.joined(separator: ", ")
        case .null: "—"
        }
    }
}

extension String {
    var camelCaseToTitle: String {
        unicodeScalars.reduce("") { result, scalar in
            if CharacterSet.uppercaseLetters.contains(scalar) {
                return result + " " + String(scalar)
            }
            return result + String(scalar)
        }
        .split(separator: " ")
        .map { $0.prefix(1).uppercased() + $0.dropFirst() }
        .joined(separator: " ")
    }
}
