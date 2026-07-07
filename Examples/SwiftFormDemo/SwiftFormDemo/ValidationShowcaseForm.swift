import SwiftUI
import SwiftForm

struct ValidationShowcaseForm: View {

    @State private var store = FormStateStore()
    @State private var showResult = false
    @State private var submittedValues: [FormFieldIdentifier: AnyCodableValue] = [:]

    private let schema = SwiftFormDSL.form(
        "validation_demo",
        title: "Create Account",
        subtitle: "All fields are validated on submit",
        submitTitle: "Create Account"
    ) {
        section("account", title: "Account Details") {
            textField("username", title: "Username", placeholder: "3-20 characters", required: true)
            emailField("email", title: "Email", placeholder: "you@example.com", required: true)
            secureField("password", title: "Password", placeholder: "Min 8 chars, uppercase + digit", required: true)
        }
        section("profile", title: "Profile") {
            textField("fullName", title: "Full Name", placeholder: "Your full name", required: true)
            phoneField("phone", title: "Phone", placeholder: "+1 (555) 000-0000")
            textEditor("bio", title: "Bio", placeholder: "Tell us about yourself (max 200 chars)")
        }
        section("terms", title: "Terms") {
            checkbox("agreeTerms", title: "I agree to the Terms of Service")
        }
    }

    private let validationRules: [(id: String, rules: [any ValidationRule])] = [
        ("username", [RequiredRule(message: "Username is required"), LengthRule(min: 3, max: 20)]),
        ("email", [RequiredRule(message: "Email is required"), EmailRule()]),
        ("password", [RequiredRule(message: "Password is required"), PasswordRule()]),
        ("fullName", [RequiredRule(message: "Full name is required")]),
        ("phone", [PhoneRule()]),
        ("bio", [LengthRule(max: 200)]),
    ]

    var body: some View {
        FormView(schema: schema, store: store) { values in
            Task { await validateAndSubmit(values) }
        }
        .sheet(isPresented: $showResult) {
            SubmissionResultView(title: "Account Created", values: submittedValues) {
                showResult = false
            }
        }
    }

    @MainActor
    private func validateAndSubmit(_ values: [FormFieldIdentifier: AnyCodableValue]) async {
        var allValid = true

        for (fieldID, rules) in validationRules {
            let id = FormFieldIdentifier(fieldID)
            let value = values[id]
            let stringValue: any FormValue = {
                switch value {
                case .string(let s): return s
                case .bool(let b): return b
                case .int(let i): return i
                case .double(let d): return d
                default: return ""
                }
            }()

            let context = ValidationContext(
                fieldID: id,
                formValues: { lookupID in
                    guard let v = values[lookupID] else { return nil }
                    if case .string(let s) = v { return s }
                    return nil
                }
            )

            var messages: [String] = []
            for rule in rules {
                let result = await rule.validate(stringValue, context: context)
                if !result.isValid {
                    messages.append(contentsOf: result.messages.map(\.text))
                }
            }

            let isValid = messages.isEmpty
            if !isValid { allValid = false }
            store.setValidation(isValid: isValid, messages: messages, for: id)
        }

        if let termsValue = values[FormFieldIdentifier("agreeTerms")],
           case .bool(let agreed) = termsValue, !agreed {
            store.setValidation(isValid: false, messages: ["You must agree to the Terms of Service"], for: FormFieldIdentifier("agreeTerms"))
            allValid = false
        } else {
            store.setValidation(isValid: true, messages: [], for: FormFieldIdentifier("agreeTerms"))
        }

        if allValid {
            submittedValues = values
            showResult = true
            for (fieldID, _) in validationRules {
                store.setValidation(isValid: true, messages: [], for: FormFieldIdentifier(fieldID))
            }
        }
    }
}
