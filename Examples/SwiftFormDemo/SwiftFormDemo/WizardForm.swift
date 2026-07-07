import SwiftUI
import SwiftForm

struct WizardForm: View {

    @State private var showResult = false
    @State private var submittedValues: [FormFieldIdentifier: AnyCodableValue] = [:]

    private let schema = SwiftFormDSL.form(
        "onboarding",
        title: "Onboarding",
        submitTitle: "Complete Setup"
    ) {
        section("profile", title: "Your Profile") {
            textField("firstName", title: "First Name", required: true)
            textField("lastName", title: "Last Name", required: true)
            emailField("email", title: "Email Address", required: true)
        }
        section("address", title: "Address") {
            textField("street", title: "Street Address", placeholder: "123 Main St")
            textField("city", title: "City")
            textField("zip", title: "Zip / Postal Code")
            dropdown("country", title: "Country", options: [
                option("us", label: "United States"),
                option("uk", label: "United Kingdom"),
                option("ca", label: "Canada"),
                option("de", label: "Germany"),
                option("fr", label: "France"),
                option("au", label: "Australia"),
                option("jp", label: "Japan"),
            ], placeholder: "Select country")
        }
        section("prefs", title: "Preferences") {
            toggle("notifications", title: "Enable Notifications")
            segment("theme", title: "Theme", options: [
                option("light", label: "Light"),
                option("dark", label: "Dark"),
                option("system", label: "System"),
            ])
            slider("fontSize", title: "Font Size")
        }
    }

    var body: some View {
        FormView(schema: schema, layout: WizardLayout()) { values in
            submittedValues = values
            showResult = true
        }
        .sheet(isPresented: $showResult) {
            SubmissionResultView(title: "Onboarding", values: submittedValues) {
                showResult = false
            }
        }
    }
}
