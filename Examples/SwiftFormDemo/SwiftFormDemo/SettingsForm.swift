import SwiftUI
import SwiftForm

struct SettingsForm: View {

    private let schema = SwiftFormDSL.form(
        "settings",
        title: "Settings",
        submitTitle: "Save"
    ) {
        section("account", title: "Account") {
            textField("username", title: "Username", required: true)
            emailField("email", title: "Email", required: true)
        }
        section("notifications", title: "Notifications") {
            toggle("pushNotifications", title: "Push Notifications")
            toggle("emailNotifications", title: "Email Notifications")
            toggle("smsNotifications", title: "SMS Notifications")
        }
        section("privacy", title: "Privacy") {
            toggle("analytics", title: "Analytics")
            toggle("crashReports", title: "Crash Reports")
        }
    }

    var body: some View {
        FormView(schema: schema, layout: GroupedSectionsLayout()) { values in
            print("Settings saved:")
            for (key, value) in values {
                print("  \(key.rawValue): \(value)")
            }
        }
    }
}
