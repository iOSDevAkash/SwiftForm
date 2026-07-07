import SwiftUI
import SwiftForm

@main
struct SwiftFormDemoApp: App {

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                List {
                    Section("Basic") {
                        NavigationLink("Registration Form") {
                            RegistrationForm()
                                .navigationTitle("Registration")
                        }
                        NavigationLink("Feedback Form") {
                            FeedbackForm()
                                .navigationTitle("Feedback")
                        }
                    }
                    Section("Layouts") {
                        NavigationLink("Wizard (Multi-Step)") {
                            WizardForm()
                                .navigationTitle("Wizard")
                        }
                        NavigationLink("Settings (Grouped)") {
                            SettingsForm()
                                .navigationTitle("Settings")
                        }
                        NavigationLink("Grid Layout") {
                            GridForm()
                                .navigationTitle("Grid")
                        }
                        NavigationLink("Accordion") {
                            AccordionForm()
                                .navigationTitle("Accordion")
                        }
                    }
                    Section("Theming") {
                        NavigationLink("Airbnb Theme") {
                            ThemeShowcase()
                                .navigationTitle("Airbnb Theme")
                        }
                    }
                }
                .navigationTitle("SwiftForm Demo")
            }
        }
    }
}
