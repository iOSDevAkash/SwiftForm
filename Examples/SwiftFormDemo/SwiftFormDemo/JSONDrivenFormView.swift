import SwiftUI
import SwiftForm

struct JSONDrivenFormView: View {

    @State private var loadState: JSONFormLoadState = .loading
    @State private var showJSON = false

    var body: some View {
        Group {
            switch loadState {
            case .loading:
                ProgressView("Decoding JSON schema...")
            case .loaded(let descriptor, let json):
                VStack(spacing: 0) {
                    if showJSON {
                        jsonPreview(json)
                    }
                    FormView(schema: descriptor) { values in
                        printSubmission(values)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(showJSON ? "Hide JSON" : "Show JSON") {
                            withAnimation { showJSON.toggle() }
                        }
                    }
                }
            case .error(let message):
                errorView(message)
            }
        }
        .task { decodeSchema() }
    }

    private func jsonPreview(_ json: String) -> some View {
        ScrollView(.horizontal) {
            Text(json)
                .font(.system(.caption2, design: .monospaced))
                .padding(12)
        }
        .frame(maxHeight: 200)
        .background(Color(.systemGroupedBackground))
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.orange)
            Text("JSON Decode Error")
                .font(.headline)
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }

    private func decodeSchema() {
        let decoder = JSONSchemaDecoder()
        do {
            let schema = try decoder.decode(from: Data(Self.formJSON.utf8))
            guard let descriptor = schema as? FormDescriptor else {
                loadState = .error("Unexpected schema type")
                return
            }
            let encoder = JSONSchemaEncoder(prettyPrinted: true)
            let prettyData = try encoder.encode(descriptor)
            let pretty = String(data: prettyData, encoding: .utf8) ?? Self.formJSON
            loadState = .loaded(descriptor, pretty)
        } catch {
            loadState = .error(error.localizedDescription)
        }
    }

    private func printSubmission(_ values: [FormFieldIdentifier: AnyCodableValue]) {
        let outputEncoder = FormOutputEncoder()
        if let data = try? outputEncoder.encode(values),
           let json = String(data: data, encoding: .utf8) {
            print("JSON form output:\n\(json)")
        }
    }

    // MARK: - JSON Schema

    static let formJSON = """
    {
      "id": "contact_form",
      "title": "Contact Us",
      "version": { "major": 1, "minor": 0, "patch": 0 },
      "submitTitle": "Send Message",
      "sections": [
        {
          "id": "personal",
          "title": "Your Information",
          "fields": [
            {
              "id": "name",
              "componentType": "text",
              "title": "Full Name",
              "placeholder": "Jane Doe",
              "isRequired": true
            },
            {
              "id": "email",
              "componentType": "email",
              "title": "Email Address",
              "placeholder": "you@company.com",
              "isRequired": true
            },
            {
              "id": "phone",
              "componentType": "phone",
              "title": "Phone",
              "placeholder": "+1 (555) 000-0000"
            },
            {
              "id": "company",
              "componentType": "text",
              "title": "Company",
              "placeholder": "Acme Inc."
            }
          ]
        },
        {
          "id": "inquiry",
          "title": "Your Inquiry",
          "fields": [
            {
              "id": "department",
              "componentType": "dropdown",
              "title": "Department",
              "isRequired": true,
              "options": [
                { "id": "sales", "label": "Sales", "value": "sales" },
                { "id": "support", "label": "Technical Support", "value": "support" },
                { "id": "billing", "label": "Billing", "value": "billing" },
                { "id": "general", "label": "General Inquiry", "value": "general" }
              ]
            },
            {
              "id": "priority",
              "componentType": "segment",
              "title": "Priority",
              "options": [
                { "id": "low", "label": "Low", "value": "low" },
                { "id": "medium", "label": "Medium", "value": "medium" },
                { "id": "high", "label": "High", "value": "high" }
              ],
              "defaultValue": "medium"
            },
            {
              "id": "message",
              "componentType": "textEditor",
              "title": "Message",
              "placeholder": "Describe your inquiry...",
              "isRequired": true
            }
          ]
        },
        {
          "id": "preferences",
          "title": "Preferences",
          "fields": [
            {
              "id": "callback",
              "componentType": "toggle",
              "title": "Request a callback",
              "defaultValue": false
            },
            {
              "id": "newsletter",
              "componentType": "checkbox",
              "title": "Subscribe to product updates"
            },
            {
              "id": "satisfaction",
              "componentType": "rating",
              "title": "How did you find us?"
            }
          ]
        }
      ]
    }
    """
}

private enum JSONFormLoadState {
    case loading
    case loaded(FormDescriptor, String)
    case error(String)
}
