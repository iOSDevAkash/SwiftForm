import SwiftUI
import SwiftForm

struct GridForm: View {

    private let schema = SwiftFormDSL.form(
        "contact",
        title: "Contact Info",
        submitTitle: "Save Contact"
    ) {
        section("info", title: "Details") {
            textField("name", title: "Full Name", placeholder: "Jane Smith", required: true)
            emailField("email", title: "Email", placeholder: "jane@company.com", required: true)
            phoneField("phone", title: "Phone", placeholder: "+1 (555) 123-4567")
            textField("company", title: "Company", placeholder: "Acme Inc.")
            dropdown("role", title: "Role", options: [
                option("eng", label: "Engineering"),
                option("design", label: "Design"),
                option("sales", label: "Sales"),
                option("support", label: "Support"),
            ], placeholder: "Department")
            textField("website", title: "Website", placeholder: "https://example.com")
        }
    }

    var body: some View {
        FormView(schema: schema, layout: ResponsiveGridLayout()) { values in
            print("Contact saved:")
            for (key, value) in values {
                print("  \(key.rawValue): \(value)")
            }
        }
    }
}
