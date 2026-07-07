# Architecture Overview

## Dependency Graph

```
                    SwiftFormCore
                    /    |    \
                   /     |     \
          Utilities  Schema  Theme   Plugins  Analytics
                    / |  \     |
                   /  |   \    |
              State Rules  DSL |
               |    |     JSON |
               |    |      |   |
               |    |  Networking
               |    |      
           Components      
               |           
           Renderer  Accessibility
               |
           Layouts
               
           Capture (UIKit boundary)
               
           SwiftForm (umbrella)
```

## Data Flow

```
Input                    Processing               Output
─────                    ──────────               ──────
Swift DSL ──┐                                   
             ├── Schema ── Rules ── Validation    
JSON ───────┘      │                    │         
                   │              State Engine    
                   │                    │         JSON Output
                   └── Layout Engine ───┘         
                          │                       
                      Renderer                    
                          │                       
                     SwiftUI Views                
```

## Module Responsibilities

### Core Layer (no dependencies)
- **SwiftFormCore** — Identifiers, value protocols, component types, errors, configuration, versioning

### Schema Layer
- **SwiftFormSchema** — FieldSchema/SectionSchema/FormSchema protocols, FormFieldDescriptor, FormSectionDescriptor, FormDescriptor, FieldOption, SchemaValidator
- **SwiftFormDSL** — FormBuilder/SectionBuilder result builders, field helper functions (textField, emailField, toggle, etc.)
- **SwiftFormJSON** — SchemaEncoder/SchemaDecoder protocols, JSONSchemaEncoder, JSONSchemaDecoder, FormOutputEncoder/Decoder

### Logic Layer
- **SwiftFormState** — FormStateStore (@Observable), FieldState, InteractionState (17 cases), FormStateContainer protocol
- **SwiftFormValidation** — 7 built-in rules (Required, Email, Phone, Regex, Length, Range, Password), CompositeValidator, CrossFieldRule, ValidationSeverity
- **SwiftFormRules** — ExpressionLexer, ExpressionParser (recursive-descent), DefaultExpressionEvaluator, RuleEngine, ExpressionRule

### Presentation Layer
- **SwiftFormTheme** — Design tokens (Color, Spacing, Typography, Radius, Elevation), DefaultThemeProvider, environment injection
- **SwiftFormComponents** — 14 SwiftUI component views (Text, SecureField, Email, Phone, TextEditor, Date, Time, Toggle, Checkbox, Slider, Dropdown, Radio, Segment, Rating), FormFieldView wrapper, FormComponent protocol
- **SwiftFormRenderer** — FormLayoutEngine protocol, StackFormLayout (default), BuiltInComponentFactory, DefaultComponentRegistry, DefaultFormRenderer, FormView entry point, public SectionView
- **SwiftFormLayouts** — FormLayout protocol, 8 layout engines (Card, Wizard, Accordion, Grid, Tabs, GroupedSections, Stepper, ResponsiveGrid), BuiltInLayoutRegistry

### Extension Layer
- **SwiftFormPlugins** — Plugin lifecycle hooks
- **SwiftFormAccessibility** — Accessibility descriptors and configuration
- **SwiftFormAnalytics** — Event tracking protocol
- **SwiftFormNetworking** — SchemaCache protocol (MemorySchemaCache, DiskSchemaCache), CachingSchemaProvider with TTL + offline fallback, SchemaVersionCheck, SchemaMigrator protocol, URLSchemaProvider, RemoteFormView

### Platform Layer
- **SwiftFormCapture** — UIKit/AVFoundation bridging (iOS only)
- **SwiftFormUtilities** — Shared extensions

### Umbrella
- **SwiftForm** — Re-exports all modules
