//
//  ProfileVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 20/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import Alamofire
import InputMask

class ProfileVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var imProfilePhoto: UIImageView!
    @IBOutlet weak var lbInitials: UILabel!
    @IBOutlet weak var phoneListener: MaskedTextFieldDelegate!
    @IBOutlet weak var brithdayListener: MaskedTextFieldDelegate!
    @IBOutlet weak var lbScreenTitle: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var vwContainer: ShadowedView!
    @IBOutlet weak var vwPhoto: ShadowedView!
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var vwNameSeparator: UIView!
    
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var tfPhone: TextField!
    @IBOutlet weak var vwPhoneSeparator: UIView!
    
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var vwEmailSeparator: UIView!

    @IBOutlet weak var lbBirthday: UILabel!
    @IBOutlet weak var tfBirthday: TextField!
    @IBOutlet weak var vwBirthdaySeparator: UIView!
    
    // MARK: - Public Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private Properties
    private var hasPhoto = false
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()

        configureScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkConnection()
    }
    
    override func configureScreen() {
        super.configureScreen()
        
        setupColors()
    }
    
    @objc override func lostConnection(_ notification: Notification) {
        hideKeyboard()
        checkConnection()
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        vwHeader.backgroundColor = .titleBarBackgroundColor
        lbScreenTitle.textColor = UIColor.degradeTitleFontColor
        btnSave.tintColor = UIColor.degradeTitleFontColor
        
        vwContainer.backgroundColor = UIColor.slideUpAlertBackground
        vwPhoto.backgroundColor = UIColor.photoBackground
        lbInitials.textColor = UIColor.highlightFontColor
        
        lbName.textColor = UIColor.secondaryFontColor
        tfName.textColor = UIColor.primaryDarkFontColor
        vwNameSeparator.backgroundColor = UIColor.separatorDarkColor
        
        lbPhone.textColor = UIColor.secondaryFontColor
        tfPhone.textColor = UIColor.primaryDarkFontColor
        vwPhoneSeparator.backgroundColor = UIColor.separatorDarkColor
        
        lbEmail.textColor = UIColor.secondaryFontColor
        tfEmail.textColor = UIColor.primaryDarkFontColor
        vwEmailSeparator.backgroundColor = UIColor.separatorDarkColor
        
        lbBirthday.textColor = UIColor.secondaryFontColor
        tfBirthday.textColor = UIColor.primaryDarkFontColor
        vwBirthdaySeparator.backgroundColor = UIColor.separatorDarkColor
    }
    
    private func checkConnection() {
        if !ConnectivityService.instance.isConnected {
            showNetworkConnectionAlert(forController: self)
        } else {
            loadProfile()
        }
    }
    
    private func loadProfile() {
        if let profile = AppContext.shared.user.profile {
            lbInitials.text = profile.initials
            tfName.text = profile.name.stringValue
            tfPhone.text = profile.phone
            tfEmail.text = profile.email
            tfBirthday.text = profile.formattedBirthDay
            
            loadProfilePhoto()
        }
    }
    
    private func loadProfilePhoto() {
        imProfilePhoto.image = AppContext.shared.userPhoto
        imProfilePhoto.isHidden = imProfilePhoto.image == nil
    }
    
    private func selectPhoto() {
        if let imagePickerVC = self.instantiateViewControllerFrom(storyBoardName: "Alerts", withIdentifier: "ImagePickerVC") as? ImagePickerVC {
            imagePickerVC.delegate = self
            
            providesPresentationContextTransitionStyle = true
            definesPresentationContext = true
            imagePickerVC.modalPresentationStyle = .overCurrentContext
            
            present(imagePickerVC, animated: false, completion: nil)
        }
    }
    
    private func validate() -> Bool {
        guard let name = tfName.text?.trimmingCharacters(in: .whitespaces) else { return false }
        guard let phone = tfPhone.text?.trimmingCharacters(in: .whitespaces) else { return false }
        guard let email = tfEmail.text?.trimmingCharacters(in: .whitespaces) else { return false }
        guard let birthday = tfBirthday.text?.trimmingCharacters(in: .whitespaces) else { return false }
            
        if phone.isEmpty || email.isEmpty || birthday.isEmpty {
            showAlert(forController: self, title: "Atenção", message: "Todos os campos devem ser preenchidos.", leftButtonTitle: nil, rightButtonTitle: "OK", closeButtonImage: Constants.IMAGES._CANCEL_GRAY_IMAGE, withId: "", sender: nil)
            return false
        }
        
        AppContext.shared.user.profile?.name = name
        AppContext.shared.user.profile?.email = email
        AppContext.shared.user.profile?.phone = phone.onlyNumbers()
        AppContext.shared.user.profile?.birthday = Utils.formatDate(string: birthday, withInFormat: Constants.MASKS._BR_DATE, andOutFormat: Constants.MASKS._DEFAULT_DATE_TIME)
        AppContext.shared.userPhoto = imProfilePhoto.image
        
        return true
    }
    
    private func saveProfile() {
        if !validate() { return }
        
        if let profile = AppContext.shared.user.profile {
            serviceExecute { logged in
                if logged {
                    LoadingVC.instance.show()
                    UserService.shared.editUserProfile(profile) { (error) in
                        LoadingVC.instance.hide()
                        if let error = error {
                            self.handleNetworking(error: error, forViewController: self, completion: nil)
                            
                        } else {
                            if let profilePhoto = self.imProfilePhoto.image {
                                ProfileService.instance.saveProfilePhoto(photo: profilePhoto, withCompletion: { (error) in
                                    if let error = error {
                                        self.handleNetworking(error: error, forViewController: self, completion: nil)
                                        
                                    } else {
                                        AppContext.shared.userPhoto = profilePhoto
                                    }
                                })
                            }
                            
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "homeUnwindActionSegue", sender: nil)
                            }
                        }
                    }
                    
                } else {
                    self.showGenericErrorAlert(forController: self)
                }
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func didTapSaveButton(_ sender: UIButton) {
        saveProfile()
    }
    
    @IBAction func didTapEditPhotoButton(_ sender: UIButton) {
        selectPhoto()
    }
    
}


// MARK: - ImagePickerDelegate
extension ProfileVC: ImagePickerDelegate {
    
    func didSelectImage(image: UIImage) {
        DispatchQueue.main.async {
            let newImage = image.resizeWithScaleAspectFitMode(to: 200, resizeFramework: .coreGraphics) ?? image
            
            self.imProfilePhoto.image = newImage
            self.imProfilePhoto.setNeedsDisplay()
        }
    }
    
}


// MARK: - AlertDelegate
extension ProfileVC: AlertDelegate {
    
    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?) {
        if result == .right, id == Constants.ALERTS._CHECK_CONNECTION_ALERT_ID {
            checkConnection()
        }
    }
    
}
