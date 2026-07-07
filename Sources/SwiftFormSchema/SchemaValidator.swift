import SwiftFormCore

/// Validates schema structure for correctness.
public struct SchemaValidator: Sendable {

    public init() {}

    /// Validate a form descriptor and return any issues found.
    public func validate(_ form: FormDescriptor) -> [SchemaValidationIssue] {
        var issues: [SchemaValidationIssue] = []
        var seenFieldIDs: Set<FormFieldIdentifier> = []
        var seenSectionIDs: Set<String> = []

        if form.id.isEmpty {
            issues.append(.formIDEmpty)
        }

        if form.title.isEmpty {
            issues.append(.formTitleEmpty)
        }

        if form.sections.isEmpty {
            issues.append(.noSections)
        }

        for section in form.sections {
            if seenSectionIDs.contains(section.id) {
                issues.append(.duplicateSectionID(section.id))
            }
            seenSectionIDs.insert(section.id)

            if section.fields.isEmpty {
                issues.append(.emptySectionFields(sectionID: section.id))
            }

            for field in section.fields {
                if seenFieldIDs.contains(field.id) {
                    issues.append(.duplicateFieldID(field.id))
                }
                seenFieldIDs.insert(field.id)

                if field.title.isEmpty {
                    issues.append(.fieldTitleEmpty(field.id))
                }

                let selectionTypes: Set<ComponentType> = [.radio, .segment, .dropdown]
                if selectionTypes.contains(field.componentType) {
                    if field.options == nil || field.options?.isEmpty == true {
                        issues.append(.selectionFieldMissingOptions(field.id))
                    }
                }
            }
        }

        return issues
    }
}

/// Issues found during schema validation.
public enum SchemaValidationIssue: Sendable, Hashable, CustomStringConvertible {
    case formIDEmpty
    case formTitleEmpty
    case noSections
    case duplicateSectionID(String)
    case emptySectionFields(sectionID: String)
    case duplicateFieldID(FormFieldIdentifier)
    case fieldTitleEmpty(FormFieldIdentifier)
    case selectionFieldMissingOptions(FormFieldIdentifier)

    public var description: String {
        switch self {
        case .formIDEmpty:
            return "Form ID is empty"
        case .formTitleEmpty:
            return "Form title is empty"
        case .noSections:
            return "Form has no sections"
        case .duplicateSectionID(let id):
            return "Duplicate section ID: \(id)"
        case .emptySectionFields(let id):
            return "Section '\(id)' has no fields"
        case .duplicateFieldID(let id):
            return "Duplicate field ID: \(id)"
        case .fieldTitleEmpty(let id):
            return "Field '\(id)' has empty title"
        case .selectionFieldMissingOptions(let id):
            return "Selection field '\(id)' has no options"
        }
    }
}
