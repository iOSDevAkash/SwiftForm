import SwiftFormCore
import SwiftFormComponents
import SwiftFormSchema
import SwiftFormState

#if canImport(UIKit)
import UIKit

/// Marker protocol for components that bridge to UIKit/AVFoundation.
///
/// All UIKit-dependent components (Camera, Barcode, QR, Signature,
/// Document Picker) must live in this module. No other SwiftForm
/// module may import UIKit.
public protocol CaptureComponent: FormComponent, Sendable {
    var requiresUIKit: Bool { get }
}

#else

/// On non-UIKit platforms, CaptureComponent is available but
/// concrete implementations are unavailable.
public protocol CaptureComponent: FormComponent, Sendable {
    var requiresUIKit: Bool { get }
}

#endif
