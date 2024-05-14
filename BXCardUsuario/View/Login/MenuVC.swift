//
//  MenuVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 21/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import SafariServices

class MenuVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var lbInitials: UILabel!
    @IBOutlet weak var lbUsername: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var imProfilePhoto: UIImageView!
    @IBOutlet weak var vwSeparator: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var btnAttendance: UIButton!
    @IBOutlet weak var btnUseTerms: UIButton!
    @IBOutlet weak var btnPrivacyPolitics: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    
    // MARK: - Public Properties
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureScreen()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "textViewVCSegue", let textViewVC = segue.destination as? TextViewVC {
            textViewVC.textType = sender as? TextType
        }
    }
    
    override func configureScreen() {
        setupColors()
        
        let user = AppContext.shared.user
        
        imProfilePhoto.image = AppContext.shared.userPhoto
        imProfilePhoto.isHidden = (imProfilePhoto.image == nil)
        
        lbUsername.text = user.profile?.name
        lbEmail.text = user.profile?.email
        lbInitials.text = user.profile?.initials
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        lbInitials.textColor = UIColor.highlightFontColor
        lbUsername.textColor = UIColor.primaryFontColor
        lbEmail.textColor = UIColor.primaryLightFontColor
        
        vwSeparator.backgroundColor = UIColor.separatorDarkColor
        
        btnEdit.tintColor = UIColor.primaryFontColor
        btnChangePassword.tintColor = UIColor.primaryFontColor
        btnAttendance.tintColor = UIColor.primaryFontColor
        btnUseTerms.tintColor = UIColor.primaryFontColor
        btnPrivacyPolitics.tintColor = UIColor.primaryFontColor
        btnLogout.tintColor = UIColor.primaryFontColor
        
        
    }
    
    private func editProfile() {
        revealViewController()?.revealToggle(animated: true)
        performSegue(withIdentifier: "profileVCSegue", sender: nil)
    }
    
    private func changePassword() {
        revealViewController()?.revealToggle(animated: true)
        performSegue(withIdentifier: "changePasswordVCSegue", sender: nil)
    }
    
    private func requestAttendance() {
        UtilService.instance.getUsefullLink(forId: .operatorContact) { (url, error) in
            if let error = error {
                if Constants.ERRORS.isCatchedError(error: error) {
                    self.showAlert(forController: self, message: error._domain, messageImage: Constants.IMAGES._ALERT_GREEN_IMAGE, messageAlignment: .center, leftButtonTitle: nil, rightButtonTitle: "Ok", canCloseClickingOutside: true, withId: "", sender: nil)
                    
                } else {
                    self.showGenericErrorAlert(forController: self)
                }
                
            } else if let url = url {
                Utils.openURLOnSafari(forController: self, withUrl: url)
            }
        }
    }
    
    private func useTerms() {
        revealViewController()?.revealToggle(animated: true)
        performSegue(withIdentifier: "textViewVCSegue", sender: TextType.useTerms)
    }
    
    private func privacyPolicits() {
        revealViewController()?.revealToggle(animated: true)
        performSegue(withIdentifier: "textViewVCSegue", sender: TextType.privacyPolitics)
    }
    
    private func logout() {
        AppContext.shared.logout()
        self.revealViewController()?.revealToggle(animated: false)
        (self.revealViewController()?.frontViewController as? UINavigationController)?.popToRootViewController(animated: true)
    }
    
    // MARK: - IBActions
    @IBAction func didTapEditProfileButton(_ sender: UIButton) {
        editProfile()
    }
    
    @IBAction func didTapChangePasswordButton(_ sender: UIButton) {
        changePassword()
    }
    
    @IBAction func didTapRequestAttendanceButton(_ sender: UIButton) {
        requestAttendance()
    }
    
    @IBAction func didTapUseTermsButton(_ sender: UIButton) {
        useTerms()
    }
    
    @IBAction func didTapPrivacyPoliticsButton(_ sender: UIButton) {
        privacyPolicits()
    }
    
    @IBAction func didTapLogoutButton(_ sender: UIButton) {
        logout()
    }
    
}


// MARK: - SFSafariViewControllerDelegate
extension MenuVC: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.revealViewController()?.revealToggle(animated: true)
    }
    
}
