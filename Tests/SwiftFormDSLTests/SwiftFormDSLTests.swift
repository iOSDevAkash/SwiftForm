import Testing
@testable import SwiftFormDSL
@testable import SwiftFormSchema
import SwiftFormCore

@Suite("SwiftFormDSL")
struct SwiftFormDSLFullTests {

    @Test func buildFormWithDSL() {
        let form = SwiftFormDSL.form("registration", title: "Register") {
            section("profile", title: "Profile") {
                textField("name", title: "Full Name", required: true)
                emailField("email", title: "Email", placeholder: "you@example.com", required: true)
                phoneField("phone", title: "Phone")
            }
            section("account", title: "Account") {
                secureField("password", title: "Password", required: true)
                toggle("terms", title: "Accept Terms")
            }
        }

        #expect(form.id == "registration")
        #expect(form.title == "Register")
        #expect(form.sections.count == 2)
        #expect(form.sections[0].fields.count == 3)
        #expect(form.sections[1].fields.count == 2)
    }

    @Test func buildFormWithOptions() {
        let form = SwiftFormDSL.form("survey", title: "Survey") {
            section("q1", title: "Question 1") {
                dropdown("color", title: "Favorite Color", options: [
                    option("red", label: "Red"),
                    option("blue", label: "Blue"),
                    option("green", label: "Green"),
                ], required: true)
            }
        }

        let field = form.sections[0].fields[0]
        #expect(field.componentType == .dropdown)
        #expect(field.options?.count == 3)
        #expect(field.options?[0].label == "Red")
        #expect(field.isRequired)
    }

    @Test func fieldBuilderTypes() {
        let form = SwiftFormDSL.form("all_types", title: "All") {
            section("s1") {
                textField("t1", title: "Text")
                emailField("t2", title: "Email")
                phoneField("t3", title: "Phone")
                secureField("t4", title: "Secret")
                otpField("t5", title: "OTP")
                currencyField("t6", title: "Amount")
                textEditor("t7", title: "Notes")
                dateField("t8", title: "Date")
                timeField("t9", title: "Time")
                toggle("t10", title: "Toggle")
                checkbox("t11", title: "Check")
                slider("t12", title: "Slide")
                rating("t13", title: "Rate")
            }
        }

        #expect(form.sections[0].fields.count == 13)
        #expect(form.sections[0].fields[0].componentType == .text)
        #expect(form.sections[0].fields[1].componentType == .email)
        #expect(form.sections[0].fields[9].componentType == .toggle)
    }

    @Test func conditionalDSL() {
        let showPhone = true
        let form = SwiftFormDSL.form("conditional", title: "Test") {
            section("s1") {
                textField("name", title: "Name")
                if showPhone {
                    phoneField("phone", title: "Phone")
                }
            }
        }

        #expect(form.sections[0].fields.count == 2)
    }

    @Test func optionHelper() {
        let opt = option("us", label: "United States")
        #expect(opt.id == "us")
        #expect(opt.label == "United States")
        #expect(opt.value.stringValue == "us")
        #expect(opt.isDisabled == false)
    }

    @Test func defaultValues() {
        let form = SwiftFormDSL.form("defaults", title: "Defaults") {
            section("s1") {
                textField("name", title: "Name", defaultValue: "John")
                toggle("active", title: "Active", defaultValue: true)
                slider("volume", title: "Volume", defaultValue: 0.5)
            }
        }

        #expect(form.sections[0].fields[0].defaultValue?.stringValue == "John")
        #expect(form.sections[0].fields[1].defaultValue?.boolValue == true)
        #expect(form.sections[0].fields[2].defaultValue?.doubleValue == 0.5)
    }

    // MARK: - Phase 10 DSL Helpers

    @Test func searchFieldDSL() {
        let field = searchField("q", title: "Search", placeholder: "Find...")
        #expect(field.componentType == .search)
        #expect(field.placeholder == "Find...")
    }

    @Test func autocompleteFieldDSL() {
        let field = autocompleteField(
            "city",
            title: "City",
            options: [
                option("nyc", label: "New York"),
                option("sf", label: "San Francisco"),
            ],
            placeholder: "Type city..."
        )
        #expect(field.componentType == .autocomplete)
        #expect(field.options?.count == 2)
    }

    @Test func otpFieldDSLWithDigitCount() {
        let field = otpField("code", title: "Code", digitCount: 4, required: true)
        #expect(field.componentType == .otp)
        #expect(field.metadata?["digitCount"]?.intValue == 4)
        #expect(field.isRequired)
    }

    @Test func otpFieldDSLDefaultDigitCount() {
        let field = otpField("code", title: "Code")
        #expect(field.metadata == nil)
    }

    @Test func currencyFieldDSLWithSymbol() {
        let field = currencyField("price", title: "Price", currencySymbol: "€", required: true)
        #expect(field.componentType == .currency)
        #expect(field.metadata?["currencySymbol"]?.stringValue == "€")
    }

    @Test func currencyFieldDSLDefaultSymbol() {
        let field = currencyField("price", title: "Price")
        #expect(field.metadata == nil)
    }

    @Test func progressFieldDSL() {
        let field = progressField("prog", title: "Progress", defaultValue: 0.5)
        #expect(field.componentType == .progress)
        #expect(field.defaultValue?.doubleValue == 0.5)
    }

    @Test func progressFieldHideLabel() {
        let field = progressField("prog", title: "Progress", showLabel: false)
        #expect(field.metadata?["showLabel"]?.boolValue == false)
    }

    // MARK: - Phase 11 DSL Helpers

    @Test func imagePickerDSL() {
        let field = imagePicker("photo", title: "Photo", required: true)
        #expect(field.componentType == .imagePicker)
        #expect(field.isRequired)
    }

    @Test func signatureFieldDSL() {
        let field = signatureField("sig", title: "Signature")
        #expect(field.componentType == .signature)
    }

    @Test func documentPickerDSL() {
        let field = documentPicker("doc", title: "Upload", allowedTypes: "pdf,txt")
        #expect(field.componentType == .documentPicker)
        #expect(field.metadata?["allowedTypes"]?.stringValue == "pdf,txt")
    }

    @Test func documentPickerDSLNoTypes() {
        let field = documentPicker("doc", title: "Upload")
        #expect(field.metadata == nil)
    }
}
