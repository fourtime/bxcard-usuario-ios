//
//  QRCodeReaderVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 14/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeReaderVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwCapture: UIView!
    @IBOutlet weak var lbScreenTitle: UILabel!
    
    // MARK: - Public Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Barcode Capture Properties
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.qr]
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()

        configureScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        startCapture()
        setupVisual()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopCapture()
    }
    
    override func configureScreen() {
        setupColors()
        initBarcodeCapture()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paymentSummaryVCSegue", let paymentSummaryVC = segue.destination as? PaymentSummaryVC {
            paymentSummaryVC.token = sender as? String
        }
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        vwHeader.backgroundColor = .titleBarBackgroundColor
        lbScreenTitle.textColor = UIColor.degradeTitleFontColor
    }
    
    private func startCapture() {
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    private func stopCapture() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    private func captureBarcode(decodedBarcode codeBar: String) {
        stopCapture()
        performSegue(withIdentifier: "paymentSummaryVCSegue", sender: codeBar)
    }
    
    private func initBarcodeCapture() {
        LoadingVC.instance.show()
        
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            LoadingVC.instance.hide()
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            LoadingVC.instance.hide()
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        vwCapture.layer.addSublayer(videoPreviewLayer!)
        
        LoadingVC.instance.hide()
    }
    
    private func setupVisual() {
        DispatchQueue.main.async {
            let size = self.vwCapture.bounds.width - (Constants.SIZES._CAPTURE_RECT_MARGIN * 2.0)
            let overlay = Utils.createOverlay(frame: self.vwCapture.bounds, xOffset: self.vwCapture.bounds.midX, yOffset: self.vwCapture.bounds.midY, radius: size)
            self.vwCapture.addSubview(overlay)
            
            if let vwTitle = Bundle.main.loadNibNamed("QRCode", owner: nil, options: nil)?[0] as? UIView {
                self.vwCapture.addSubview(vwTitle)
                self.vwCapture.bringSubviewToFront(vwTitle)
                vwTitle.center.x = self.vwCapture.bounds.midX
                vwTitle.center.y = (self.vwCapture.bounds.midY - (size / 2.0)) - (vwTitle.bounds.size.height / 2.0) - Constants.SIZES._CAPTURE_INSTRUCTION_DOWN_MARGIN
            }
        }
    }

}


// MARK: - Extensions
extension QRCodeReaderVC: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type), let metadataObjStr = metadataObj.stringValue {
            captureBarcode(decodedBarcode: metadataObjStr)
        }
    }
    
}

