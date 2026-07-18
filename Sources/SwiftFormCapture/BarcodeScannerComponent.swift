import SwiftUI
import SwiftFormCore
import SwiftFormSchema
import SwiftFormState
import SwiftFormTheme
import SwiftFormComponents

@MainActor
public struct BarcodeScannerComponent: View {

    public let descriptor: FormFieldDescriptor
    public let store: any FormStateContainer

    public init(descriptor: FormFieldDescriptor, store: any FormStateContainer) {
        self.descriptor = descriptor
        self.store = store
    }

    @Environment(\.themeProvider) private var themeProvider
    @State private var showingScanner = false

    private var tokens: any DesignTokens {
        themeProvider?.tokens ?? DefaultDesignTokens()
    }

    private var scannedValue: String? {
        store.value(for: descriptor.id)?.stringValue
    }

    public var body: some View {
        FormFieldView(descriptor: descriptor, store: store) {
            VStack(alignment: .leading, spacing: tokens.spacing.xs) {
                HStack {
                    Image(systemName: descriptor.componentType == .qr ? "qrcode" : "barcode.viewfinder")
                        .foregroundStyle(tokens.colors.primary)

                    if let value = scannedValue, !value.isEmpty {
                        Text(value)
                            .font(tokens.typography.body)
                            .foregroundStyle(tokens.colors.onBackground)

                        Spacer()

                        Button {
                            store.setValue(nil, for: descriptor.id)
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(tokens.colors.secondary)
                        }
                    } else {
                        Text(descriptor.placeholder ?? "Scan Code...")
                            .font(tokens.typography.body)
                            .foregroundStyle(tokens.colors.secondary)

                        Spacer()

                        Button {
                            showingScanner = true
                        } label: {
                            Text("Scan")
                                .font(tokens.typography.caption)
                                .padding(.horizontal, tokens.spacing.sm)
                                .padding(.vertical, tokens.spacing.xs)
                                .background(tokens.colors.primary)
                                .foregroundStyle(tokens.colors.onPrimary)
                                .clipShape(RoundedRectangle(cornerRadius: tokens.radius.sm))
                        }
                    }
                }
                .padding(tokens.spacing.sm)
                .background(tokens.colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: tokens.radius.md))
                .sheet(isPresented: $showingScanner) {
                    VStack(spacing: tokens.spacing.md) {
                        Text(descriptor.componentType == .qr ? "Scan QR Code" : "Scan Barcode")
                            .font(tokens.typography.title)

                        #if canImport(UIKit)
                        BarcodeScannerViewControllerRepresentable { code in
                            store.setValue(.string(code), for: descriptor.id)
                            showingScanner = false
                        }
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: tokens.radius.lg))
                        #else
                        Text("Barcode scanning requires iOS device / AVFoundation")
                            .font(tokens.typography.caption)
                            .foregroundStyle(tokens.colors.secondary)
                        #endif

                        Button("Cancel") {
                            showingScanner = false
                        }
                        .font(tokens.typography.body)
                        .padding()
                    }
                    .padding()
                }
            }
        }
    }
}

#if canImport(UIKit)
import UIKit
import AVFoundation

struct BarcodeScannerViewControllerRepresentable: UIViewControllerRepresentable {
    var onScan: (String) -> Void

    func makeUIViewController(context: Context) -> BarcodeScannerViewController {
        let vc = BarcodeScannerViewController()
        vc.onScan = onScan
        return vc
    }

    func updateUIViewController(_ uiViewController: BarcodeScannerViewController, context: Context) {}
}

class BarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var onScan: ((String) -> Void)?
    private var captureSession: AVCaptureSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        let session = AVCaptureSession()
        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        } else {
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417, .code128]
        } else {
            return
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession = session
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first,
           let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
           let stringValue = readableObject.stringValue {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            captureSession?.stopRunning()
            onScan?(stringValue)
        }
    }
}
#endif
