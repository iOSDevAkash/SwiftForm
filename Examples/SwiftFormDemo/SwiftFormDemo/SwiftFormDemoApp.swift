import SwiftUI
import SwiftForm

@main
struct SwiftFormDemoApp: App {

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                List {
                    Section {
                        DemoRow(
                            icon: "person.crop.circle.badge.plus",
                            color: .blue,
                            title: "Registration",
                            subtitle: "Name, email, password with validation"
                        ) {
                            RegistrationForm()
                                .navigationTitle("Registration")
                        }
                        DemoRow(
                            icon: "bubble.left.and.text.bubble.right",
                            color: .orange,
                            title: "Feedback",
                            subtitle: "Card layout with categories and rating"
                        ) {
                            FeedbackForm()
                                .navigationTitle("Feedback")
                        }
                    } header: {
                        Text("Getting Started")
                    }

                    Section {
                        DemoRow(
                            icon: "arrow.left.arrow.right",
                            color: .purple,
                            title: "Wizard (Multi-Step)",
                            subtitle: "Step-by-step onboarding flow"
                        ) {
                            WizardForm()
                                .navigationTitle("Wizard")
                        }
                        DemoRow(
                            icon: "gear",
                            color: .gray,
                            title: "Settings",
                            subtitle: "Grouped sections with toggles"
                        ) {
                            SettingsForm()
                                .navigationTitle("Settings")
                        }
                        DemoRow(
                            icon: "square.grid.2x2",
                            color: .teal,
                            title: "Grid Layout",
                            subtitle: "Responsive grid for contact info"
                        ) {
                            GridForm()
                                .navigationTitle("Grid")
                        }
                        DemoRow(
                            icon: "rectangle.expand.vertical",
                            color: .indigo,
                            title: "Accordion",
                            subtitle: "Collapsible section groups"
                        ) {
                            AccordionForm()
                                .navigationTitle("Accordion")
                        }
                    } header: {
                        Text("Layout Engines")
                    }

                    Section {
                        DemoRow(
                            icon: "checkmark.shield",
                            color: .red,
                            title: "Validation Showcase",
                            subtitle: "Required, email, password, length rules"
                        ) {
                            ValidationShowcaseForm()
                                .navigationTitle("Validation")
                        }
                        DemoRow(
                            icon: "slider.horizontal.3",
                            color: .mint,
                            title: "Advanced Components",
                            subtitle: "OTP, currency, search, signature"
                        ) {
                            AdvancedComponentsForm()
                                .navigationTitle("Advanced")
                        }
                    } header: {
                        Text("Advanced")
                    }

                    Section {
                        DemoRow(
                            icon: "curlybraces",
                            color: .green,
                            title: "JSON-Driven Form",
                            subtitle: "Server-driven UI from JSON schema"
                        ) {
                            JSONDrivenFormView()
                                .navigationTitle("JSON Form")
                        }
                    } header: {
                        Text("Server-Driven UI")
                    }

                    Section {
                        DemoRow(
                            icon: "paintpalette",
                            color: .pink,
                            title: "Airbnb Theme",
                            subtitle: "Custom design tokens and styling"
                        ) {
                            ThemeShowcase()
                                .navigationTitle("Airbnb Theme")
                        }
                    } header: {
                        Text("Theming")
                    }
                }
                .navigationTitle("SwiftForm")
            }
            .tint(.blue)
        }
    }
}

private struct DemoRow<Destination: View>: View {
    let icon: String
    let color: Color
    let title: String
    let subtitle: String
    @ViewBuilder let destination: () -> Destination

    var body: some View {
        NavigationLink {
            destination()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 34, height: 34)
                    .background(color.gradient, in: RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body.weight(.medium))
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
    }
}
