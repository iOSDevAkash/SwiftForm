import SwiftUI
import SwiftForm

struct AccordionForm: View {

    @State private var showResult = false
    @State private var submittedValues: [FormFieldIdentifier: AnyCodableValue] = [:]

    private let schema = SwiftFormDSL.form(
        "profile",
        title: "Complete Profile",
        submitTitle: "Save Profile"
    ) {
        section("personal", title: "Personal Information") {
            textField("firstName", title: "First Name", required: true)
            textField("lastName", title: "Last Name", required: true)
            emailField("email", title: "Email", required: true)
            phoneField("phone", title: "Phone")
        }
        section("work", title: "Work Information") {
            textField("jobTitle", title: "Job Title")
            textField("company", title: "Company")
            dropdown("industry", title: "Industry", options: [
                option("tech", label: "Technology"),
                option("finance", label: "Finance"),
                option("health", label: "Healthcare"),
                option("education", label: "Education"),
                option("retail", label: "Retail"),
            ], placeholder: "Select industry")
        }
        section("preferences", title: "Preferences") {
            toggle("darkMode", title: "Dark Mode")
            toggle("compactView", title: "Compact View")
            rating("appRating", title: "Rate This App")
        }
    }

    var body: some View {
        FormView(schema: schema, layout: AccordionLayout()) { values in
            submittedValues = values
            showResult = true
        }
        .sheet(isPresented: $showResult) {
            SubmissionResultView(title: "Profile", values: submittedValues) {
                showResult = false
            }
        }
    }
}
