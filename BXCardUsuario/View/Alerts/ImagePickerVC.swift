//
//  ImagePickerVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 25/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import AVFoundation
import PhotosUI

// MARK: - Protocols
protocol ImagePickerDelegate: AnyObject {
    func didSelectImage(image: UIImage)
}


class ImagePickerVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var vwContainer: ShadowedView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnCapture: Button!
    @IBOutlet weak var btnPick: Button!
    
    // MARK: - Public Properties
    weak var delegate: ImagePickerDelegate?
    
    // MARK: - AttachmentType Enum
    private enum AttachmentType: String {
        case camera, video, photoLibrary
    }
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()

        setupColors()
        
        vwContainer.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        openContainer()
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        background.backgroundColor = UIColor.alertTransparentBackground
        vwContainer.backgroundColor = UIColor.slideUpAlertBackground
        
        lbTitle.textColor = UIColor.primaryFontColor
        
        btnCapture.setGradientWith(colors: Constants.COLORS._GRADIENT_ENABLED_COLORS)
        btnPick.setGradientWith(colors: Constants.COLORS._GRADIENT_ENABLED_COLORS)
    }
    
    private func openContainer() {
        vwContainer.center.y += vwContainer.frame.height
        vwContainer.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.vwContainer.center.y -= self.vwContainer.frame.height
        })
    }
    
    private func closeContainer(withCompletion completion: Completion) {
        UIView.animate(withDuration: 0.3, animations: {
            self.vwContainer.center.y += self.vwContainer.frame.height
        }) { (_) in
            completion?()
        }
    }
    
    private func getPhotoFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            myPickerController.cameraDevice = .front
            myPickerController.isEditing = false
            present(myPickerController, animated: true, completion: nil)
        }
    }
    
    private func getPhotoFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            myPickerController.isEditing = false
            present(myPickerController, animated: true, completion: nil)
        }
    }
    
    private func authorisationStatus(attachmentTypeEnum: AttachmentType){
        if attachmentTypeEnum ==  AttachmentType.camera{
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status{
            case .authorized: // The user has previously granted access to the camera.
                getPhotoFromCamera()
                
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        DispatchQueue.main.async {
                            self.getPhotoFromCamera()
                        }
                    }
                }
                
            case .denied, .restricted:
                print("Sem permissao")
                return
                
            default:
                break
            }
            
        } else if attachmentTypeEnum == AttachmentType.photoLibrary || attachmentTypeEnum == AttachmentType.video {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status{
            case .authorized:
                if attachmentTypeEnum == AttachmentType.photoLibrary{
                    getPhotoFromLibrary()
                }
                
            case .denied, .restricted:
                print("Sem permissao")
                
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == PHAuthorizationStatus.authorized{
                        DispatchQueue.main.async {
                            self.getPhotoFromLibrary()
                        }
                    }
                    
                    print("Sem permissao")
                })
                
            default:
                break
            }
        }
        
    }
    
    // MARK: - IBActions
    @IBAction func didTapCloseButton(_ sender: Any) {
        closeContainer {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func didTapCaptureButton(_ sender: UIButton) {
        authorisationStatus(attachmentTypeEnum: .camera)
    }
    
    @IBAction func didTapSelectImageButton(_ sender: UIButton) {
        authorisationStatus(attachmentTypeEnum: .photoLibrary)
    }
    
}


// MARK: - UIImagePickerControllerDelegate
extension ImagePickerVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        closeContainer {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            closeContainer {
                self.dismiss(animated: false, completion: {
                    self.delegate?.didSelectImage(image: image)
                })
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
