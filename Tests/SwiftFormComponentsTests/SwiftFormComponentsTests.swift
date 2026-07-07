import Testing
import SwiftUI
@testable import SwiftFormComponents
@testable import SwiftFormRenderer
@testable import SwiftFormState
import SwiftFormSchema
import SwiftFormCore

@Suite("SwiftFormComponents")
struct SwiftFormComponentsTests {

    @Test func componentConfigurationCreation() {
        let config = ComponentConfiguration(
            id: "email",
            componentType: .email,
            isRequired: true
        )
        #expect(config.id.rawValue == "email")
        #expect(config.componentType == .email)
        #expect(config.isRequired == true)
        #expect(config.isDisabled == false)
    }

    @Test func formComponentProtocolExists() {
        func acceptComponent(_ component: any FormComponent) {
            _ = component.componentType
        }
    }

    @MainActor
    @Test func textFieldComponentCreation() {
        let descriptor = FormFieldDescriptor(
            id: "name",
            componentType: .text,
            title: "Name",
            placeholder: "Enter name"
        )
        let store = FormStateStore()
        store.register(id: descriptor.id)
        let component = TextFieldComponent(descriptor: descriptor, store: store)
        #expect(component.descriptor.title == "Name")
    }

    @MainActor
    @Test func toggleComponentCreation() {
        let descriptor = FormFieldDescriptor(
            id: "active",
            componentType: .toggle,
            title: "Active"
        )
        let store = FormStateStore()
        store.register(id: descriptor.id, initialValue: .bool(true))
        let component = ToggleComponent(descriptor: descriptor, store: store)
        #expect(component.descriptor.componentType == .toggle)
    }

    @MainActor
    @Test func ratingComponentCreation() {
        let descriptor = FormFieldDescriptor(
            id: "stars",
            componentType: .rating,
            title: "Rating"
        )
        let store = FormStateStore()
        store.register(id: descriptor.id)
        let component = RatingComponent(descriptor: descriptor, store: store)
        #expect(component.descriptor.title == "Rating")
    }

    @MainActor
    @Test func formFieldViewWrapsContent() {
        let descriptor = FormFieldDescriptor(
            id: "email",
            componentType: .email,
            title: "Email",
            isRequired: true
        )
        let store = FormStateStore()
        store.register(id: descriptor.id)
        let view = FormFieldView(descriptor: descriptor, store: store) {
            Text("inner")
        }
        #expect(view.descriptor.isRequired)
    }

    // MARK: - Phase 10 New Components

    @MainActor
    @Test func otpComponentCreation() {
        let descriptor = FormFieldDescriptor(
            id: "otp",
            componentType: .otp,
            title: "Verification Code",
            isRequired: true,
            metadata: ["digitCount": .int(4)]
        )
        let store = FormStateStore()
        store.register(id: descriptor.id)
        let component = OTPComponent(descriptor: descriptor, store: store)
        #expect(component.descriptor.componentType == .otp)
        #expect(component.descriptor.metadata?["digitCount"]?.intValue == 4)
    }

    @MainActor
    @Test func otpComponentDefaultDigitCount() {
        let descriptor = FormFieldDescriptor(
            id: "otp",
            componentType: .otp,
            title: "Code"
        )
        let store = FormStateStore()
        store.register(id: descriptor.id)
        let component = OTPComponent(descriptor: descriptor, store: store)
        #expect(component.descriptor.title == "Code")
    }

    @MainActor
    @Test func currencyComponentCreation() {
        let descriptor = FormFieldDescriptor(
            id: "price",
            componentType: .currency,
            title: "Price",
            placeholder: "0.00",
            metadata: ["currencySymbol": .string("€")]
        )
        let store = FormStateStore()
        store.register(id: descriptor.id)
        let component = CurrencyComponent(descriptor: descriptor, store: store)
        #expect(component.descriptor.componentType == .currency)
        #expect(component.descriptor.metadata?["currencySymbol"]?.stringValue == "€")
    }

    @MainActor
    @Test func currencyComponentDefaultSymbol() {
        let descriptor = FormFieldDescriptor(
            id: "amount",
            componentType: .currency,
            title: "Amount"
        )
        let store = FormStateStore()
        store.register(id: descriptor.id)
        let component = CurrencyComponent(descriptor: descriptor, store: store)
        #expect(component.descriptor.title == "Amount")
    }

    @MainActor
    @Test func searchComponentCreation() {
        let descriptor = FormFieldDescriptor(
            id: "query",
            componentType: .search,
            title: "Search",
            placeholder: "Type to search..."
        )
        let store = FormStateStore()
        store.register(id: descriptor.id)
        let component = SearchComponent(descriptor: descriptor, store: store)
        #expect(component.descriptor.componentType == .search)
        #expect(component.descriptor.placeholder == "Type to search...")
    }

    @MainActor
    @Test func autocompleteComponentCreation() {
        let descriptor = FormFieldDescriptor(
            id: "city",
            componentType: .autocomplete,
            title: "City",
            options: [
                FieldOption(id: "nyc", label: "New York", value: .string("nyc")),
                FieldOption(id: "sf", label: "San Francisco", value: .string("sf")),
                FieldOption(id: "la", label: "Los Angeles", value: .string("la")),
            ]
        )
        let store = FormStateStore()
        store.register(id: descriptor.id)
        let component = AutocompleteComponent(descriptor: descriptor, store: store)
        #expect(component.descriptor.componentType == .autocomplete)
    }

    @MainActor
    @Test func autocompleteOptionsExist() {
        let descriptor = FormFieldDescriptor(
            id: "country",
            componentType: .autocomplete,
            title: "Country",
            options: [
                FieldOption(id: "us", label: "United States", value: .string("us")),
            ]
        )
        #expect(descriptor.options?.count == 1)
        #expect(descriptor.options?.first?.label == "United States")
    }

    @MainActor
    @Test func progressComponentCreation() {
        let descriptor = FormFieldDescriptor(
            id: "completion",
            componentType: .progress,
            title: "Completion",
            defaultValue: .double(0.75)
        )
        let store = FormStateStore()
        store.register(id: descriptor.id, initialValue: .double(0.75))
        let component = ProgressComponent(descriptor: descriptor, store: store)
        #expect(component.descriptor.componentType == .progress)
    }

    @MainActor
    @Test func progressComponentMetadata() {
        let descriptor = FormFieldDescriptor(
            id: "upload",
            componentType: .progress,
            title: "Upload",
            metadata: ["showLabel": .bool(false)]
        )
        #expect(descriptor.metadata?["showLabel"]?.boolValue == false)
    }

    @MainActor
    @Test func builtInFactoryProducesOTP() {
        let factory = BuiltInComponentFactory()
        let descriptor = FormFieldDescriptor(
            id: "otp", componentType: .otp, title: "OTP"
        )
        let store = FormStateStore()
        store.register(id: descriptor.id)
        let view = factory.makeView(for: descriptor, state: store)
        #expect(view != nil)
    }

    @MainActor
    @Test func builtInFactoryProducesCurrency() {
        let factory = BuiltInComponentFactory()
        let descriptor = FormFieldDescriptor(
            id: "price", componentType: .currency, title: "Price"
        )
        let store = FormStateStore()
        store.register(id: descriptor.id)
        let view = factory.makeView(for: descriptor, state: store)
        #expect(view != nil)
    }

    @MainActor
    @Test func builtInFactoryProducesSearch() {
        let factory = BuiltInComponentFactory()
        let descriptor = FormFieldDescriptor(
            id: "q", componentType: .search, title: "Search"
        )
        let store = FormStateStore()
        store.register(id: descriptor.id)
        let view = factory.makeView(for: descriptor, state: store)
        #expect(view != nil)
    }

    @MainActor
    @Test func builtInFactoryProducesAutocomplete() {
        let factory = BuiltInComponentFactory()
        let descriptor = FormFieldDescriptor(
            id: "city", componentType: .autocomplete, title: "City"
        )
        let store = FormStateStore()
        store.register(id: descriptor.id)
        let view = factory.makeView(for: descriptor, state: store)
        #expect(view != nil)
    }

    @MainActor
    @Test func builtInFactoryProducesProgress() {
        let factory = BuiltInComponentFactory()
        let descriptor = FormFieldDescriptor(
            id: "prog", componentType: .progress, title: "Progress"
        )
        let store = FormStateStore()
        store.register(id: descriptor.id)
        let view = factory.makeView(for: descriptor, state: store)
        #expect(view != nil)
    }

    @MainActor
    @Test func builtInFactorySupportedTypesIncludesNewComponents() {
        let types = BuiltInComponentFactory.supportedTypes
        #expect(types.contains(.otp))
        #expect(types.contains(.currency))
        #expect(types.contains(.search))
        #expect(types.contains(.autocomplete))
        #expect(types.contains(.progress))
    }

    @MainActor
    @Test func builtInFactoryTotalSupportedCount() {
        #expect(BuiltInComponentFactory.supportedTypes.count == 19)
    }
}
