import SwiftUI
import SwiftForm

struct AdvancedComponentsForm: View {

    @State private var showResult = false
    @State private var submittedValues: [FormFieldIdentifier: AnyCodableValue] = [:]

    private let schema = SwiftFormDSL.form(
        "advanced",
        title: "Advanced Components",
        submitTitle: "Submit"
    ) {
        section("input", title: "Specialized Input") {
            otpField("otp", title: "Verification Code", digitCount: 6, required: true)
            currencyField("amount", title: "Payment Amount", currencySymbol: "$", required: true)
            searchField("search", title: "Search Products", placeholder: "Type to search...")
            autocompleteField(
                "city",
                title: "City",
                options: [
                    option("nyc", label: "New York"),
                    option("sf", label: "San Francisco"),
                    option("la", label: "Los Angeles"),
                    option("chi", label: "Chicago"),
                    option("sea", label: "Seattle"),
                    option("aus", label: "Austin"),
                ],
                placeholder: "Start typing a city..."
            )
        }
        section("status", title: "Status & Progress") {
            progressField("completion", title: "Profile Completion", defaultValue: 0.65)
            slider("satisfaction", title: "Satisfaction Score")
            rating("quality", title: "Quality Rating")
        }
        section("capture", title: "Media Capture") {
            imagePicker("avatar", title: "Profile Photo")
            signatureField("signature", title: "Your Signature")
            documentPicker("resume", title: "Upload Resume", allowedTypes: "pdf")
        }
    }

    var body: some View {
        FormView(schema: schema) { values in
            submittedValues = values
            showResult = true
        }
        .sheet(isPresented: $showResult) {
            SubmissionResultView(title: "Advanced", values: submittedValues) {
                showResult = false
            }
        }
    }
}
