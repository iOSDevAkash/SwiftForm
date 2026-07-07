import SwiftUI
import SwiftForm

struct FeedbackForm: View {

    private let schema = SwiftFormDSL.form(
        "feedback",
        title: "Send Feedback",
        submitTitle: "Submit Feedback"
    ) {
        section("details", title: "What's on your mind?") {
            textField("subject", title: "Subject", placeholder: "Brief summary", required: true)
            textEditor("message", title: "Message", placeholder: "Tell us more...", required: true)
        }
        section("meta", title: "Categorize") {
            segment("category", title: "Category", options: [
                option("bug", label: "Bug"),
                option("feature", label: "Feature"),
                option("question", label: "Question"),
            ], required: true)
            rating("satisfaction", title: "Overall Satisfaction")
        }
        section("contact", title: "Follow-up") {
            toggle("contactMe", title: "I'd like to be contacted")
            emailField("contactEmail", title: "Contact Email", placeholder: "your@email.com")
        }
    }

    var body: some View {
        FormView(schema: schema, layout: CardLayout()) { values in
            print("Feedback submitted:")
            for (key, value) in values {
                print("  \(key.rawValue): \(value)")
            }
        }
    }
}
