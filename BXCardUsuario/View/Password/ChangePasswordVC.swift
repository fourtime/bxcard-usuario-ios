//
//  ChangePasswordVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 21/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

// MARK: - ChangePasswordDelegate Protocol
protocol ChangePasswordDelegate: class {
    func didChangePassword()
}


class ChangePasswordVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var btnSave: Button!
    @IBOutlet weak var lbErrorMessage: UILabel!
    @IBOutlet weak var vwError: ShadowedView!
    @IBOutlet weak var errorTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var svScroll: UIScrollView!
    @IBOutlet weak var vwContent: UIView!
    
    @IBOutlet weak var lbOldPassword: UILabel!
    @IBOutlet weak var tfOldPassword: UITextField!
    @IBOutlet weak var vwOldPasswordSeparator: UIView!
    
    @IBOutlet weak var lbNewPassword: UILabel!
    @IBOutlet weak var tfNewPassword: UITextField!
    @IBOutlet weak var vwNewPasswordSeparator: UIView!
    
    @IBOutlet weak var lbConfirmation: UILabel!
    @IBOutlet weak var tfConfirmation: UITextField!
    @IBOutlet weak var vwConfirmationSeparator: UIView!
    
    
    // MARK: - Private Properties
    private var currentTopConstraint: CGFloat!
    
    // MARK: - Public Properties
    weak var delegate: ChangePasswordDelegate?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
   
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        vwError.isHidden = false
        checkConnection()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        vwError.isHidden = true
    }
    
    override func configureScreen() {
        vwError.isHidden = true
        
        setupColors()
        
        currentTopConstraint = errorTopConstraint.constant
        errorTopConstraint.constant = (vwError.frame.height + currentTopConstraint) * -1.0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollViewHideKeyboard))
        svScroll.addGestureRecognizer(tapGesture)
    }
    
    @objc override func lostConnection(_ notification: Notification) {
        checkConnection()
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        vwHeader.backgroundColor = .titleBarBackgroundColor
        vwContent.backgroundColor = UIColor.windowBackground
        
        vwError.backgroundColor = UIColor.defaultErrorColor
        lbErrorMessage.textColor = UIColor.defaultErrorMessageColor
        
        lbOldPassword.textColor = UIColor.secondaryFontColor
        tfOldPassword.textColor = UIColor.primaryDarkFontColor
        vwOldPasswordSeparator.backgroundColor = UIColor.separatorDarkColor
        
        lbNewPassword.textColor = UIColor.secondaryFontColor
        tfNewPassword.textColor = UIColor.primaryDarkFontColor
        vwNewPasswordSeparator.backgroundColor = UIColor.separatorDarkColor
        
        lbConfirmation.textColor = UIColor.secondaryFontColor
        tfConfirmation.textColor = UIColor.primaryDarkFontColor
        vwConfirmationSeparator.backgroundColor = UIColor.separatorDarkColor
        
        btnSave.disable()
    }
    
    private func checkConnection() {
        if !ConnectivityService.instance.isConnected {
            showNetworkConnectionAlert(forController: self)
        }
    }
    
    private func updateErrorPanel(showErrorPanel show: Bool, withMessage message: String = "") {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            if show {
                self.errorTopConstraint.constant = self.currentTopConstraint
            } else {
                self.errorTopConstraint.constant = (self.vwError.frame.height + self.currentTopConstraint) * -1.0
            }
            self.view.layoutIfNeeded()
        })
        
        if message != ""{
            lbErrorMessage.text = message
        }
    }
    
    private func validate() -> Bool {
        guard let oldPassword = tfOldPassword.text else { return false }
        guard let newPassword = tfNewPassword.text else { return false }
        guard let confirmation = tfConfirmation.text else { return false }
        
        hideKeyboard()
        if oldPassword != AppContext.shared.user.password {
            updateErrorPanel(showErrorPanel: true, withMessage: "A senha atual não confere, tente novamente.")
            return false
        }
        
        if newPassword.count < 6 {
            updateErrorPanel(showErrorPanel: true, withMessage: "A senha deve conter no mínimo seis caracteres.")
            return false
        }
        
        if newPassword != confirmation {
            updateErrorPanel(showErrorPanel: true, withMessage: "As senhas não coincidem, tente novamente.")
            return false
        }
        
        updateErrorPanel(showErrorPanel: false)
        return true
    }
    
    private func changePassword() {
        guard let oldPassword = AppContext.shared.user.password, let newPassword = self.tfNewPassword.text, validate() else { return }
        
        serviceExecute { logged in
            if logged {
                LoadingVC.instance.show()
                UserService.shared.changeUserPassword(from: oldPassword, to: newPassword) { (error) in
                    LoadingVC.instance.hide()
                    if let error = error {
                        self.handleNetworking(error: error, forViewController: self, completion: nil)
                        
                    } else {
                        self.delegate?.didChangePassword()
                        self.closeViewController()
                    }
                }
                
            } else {
                self.showGenericErrorAlert(forController: self)
            }
        }
    }
    
    @objc private func scrollViewHideKeyboard() {
        hideKeyboard()
    }
    
    // MARK: - IBActions
    @IBAction func textfieldEditingChanged(_ sender: UITextField) {
        if let oldPassword = tfOldPassword.text, let newPassword = tfNewPassword.text, let confirmation = tfConfirmation.text, !oldPassword.isEmpty, !newPassword.isEmpty, !confirmation.isEmpty {
            btnSave.enable()
            
        } else {
            btnSave.disable()
        }
    }
    
    @IBAction func didTapCloseErrorPanelButton(_ sender: Any) {
        updateErrorPanel(showErrorPanel: false)
    }
    
    @IBAction func didTapSaveButton(_ sender: Button) {
        changePassword()
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        closeViewController()
    }
    
}


// MARK: - AlertDelegate
extension ChangePasswordVC: AlertDelegate {
    
    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?) {
        if result == .right, id == Constants.ALERTS._CHECK_CONNECTION_ALERT_ID {
            checkConnection()
        }
    }
    
}

