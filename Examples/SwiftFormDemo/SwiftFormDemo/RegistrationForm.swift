import SwiftUI
import SwiftForm

struct RegistrationForm: View {

    @State private var showResult = false
    @State private var submittedValues: [FormFieldIdentifier: AnyCodableValue] = [:]

    private let schema = SwiftFormDSL.form(
        "registration",
        title: "Create Account",
        submitTitle: "Register"
    ) {
        section("personal", title: "Personal Information") {
            textField("name", title: "Full Name", placeholder: "John Doe", required: true)
            emailField("email", title: "Email", placeholder: "you@example.com", required: true)
            phoneField("phone", title: "Phone Number", placeholder: "+1 (555) 000-0000")
            secureField("password", title: "Password", placeholder: "Min 8 characters", required: true)
        }
        section("role", title: "Role & Preferences") {
            dropdown("role", title: "Your Role", options: [
                option("dev", label: "Developer"),
                option("designer", label: "Designer"),
                option("pm", label: "Product Manager"),
                option("other", label: "Other"),
            ], placeholder: "Select a role", required: true)
            toggle("newsletter", title: "Subscribe to newsletter")
            rating("experience", title: "Experience Level")
        }
    }

    var body: some View {
        FormView(schema: schema) { values in
            submittedValues = values
            showResult = true
        }
        .sheet(isPresented: $showResult) {
            SubmissionResultView(title: "Registration", values: submittedValues) {
                showResult = false
            }
        }
    }
}
