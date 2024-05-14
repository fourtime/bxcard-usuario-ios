//
//  CreatePasswordVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 25/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CreatePasswordVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwError: ShadowedView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var svScroll: UIScrollView!
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var tfPassword: TextField!
    @IBOutlet weak var tfConfirmation: TextField!
    @IBOutlet weak var btnContinue: Button!
    @IBOutlet weak var errorTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lbErrorMessage: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    
    // MARK: - Private Properties
    private var currentTopConstraint: CGFloat!
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setButtonStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkConnection()
    }
    
    override func configureScreen() {
        super.configureScreen()
        
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 90
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollViewHideKeyboard))
        svScroll.addGestureRecognizer(tapGesture)
        
        currentTopConstraint = errorTopConstraint.constant
        errorTopConstraint.constant = (vwError.frame.height + currentTopConstraint) * -1.0
        
        setupColors()
    }
    
    @objc override func keyboardWillAppear(_ notification: Notification) {
        updateErrorInfo(showErrorPanel: false)
    }
    
    @objc override func lostConnection(_ notification: Notification) {
        checkConnection()
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        vwHeader.backgroundColor = UIColor.windowBackground
        vwContent.backgroundColor = UIColor.windowBackground
        
        vwError.backgroundColor = UIColor.defaultErrorColor
        lbErrorMessage.textColor = UIColor.defaultErrorMessageColor
        
        lbTitle.textColor = UIColor.primaryFontColor

        tfPassword.bottomBorderColor = UIColor.defaultBorderColor
        tfPassword.placeholderColor = UIColor.primaryPlaceHolderColor
        tfPassword.textColor = UIColor.secondaryFontColor
        tfPassword.backgroundColor = UIColor.fieldBackgroundColor
        
        tfConfirmation.bottomBorderColor = UIColor.defaultBorderColor
        tfConfirmation.placeholderColor = UIColor.primaryPlaceHolderColor
        tfConfirmation.textColor = UIColor.secondaryFontColor
        tfConfirmation.backgroundColor = UIColor.fieldBackgroundColor
        
        btnContinue.disable()
    }
    
    private func checkConnection() {
        if !ConnectivityService.instance.isConnected {
            showNetworkConnectionAlert(forController: self)
            
        } else {
            if let password = tfPassword.text, password.isEmpty {
                tfPassword.becomeFirstResponder()
            }
        }
    }
    
    private func setButtonStatus() {
        if let password = tfPassword.text, let confirmation = tfConfirmation.text, !password.isEmpty, !confirmation.isEmpty {
            btnContinue.enable()
            
        } else {
            btnContinue.disable()
        }
    }
    
    private func updateErrorInfo(showErrorPanel show: Bool, withMessage message: String = "") {
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
        
        if show {
            tfPassword.borderColor = UIColor.errorBorderColor
            tfPassword.rightImage = Constants.IMAGES._TEXTFIELD_ERROR_IMAGE
            tfConfirmation.borderColor = UIColor.errorBorderColor
            tfConfirmation.rightImage = Constants.IMAGES._TEXTFIELD_ERROR_IMAGE
            
        } else {
            tfPassword.borderColor = UIColor.defaultBorderColor
            tfPassword.rightImage = nil
            tfConfirmation.borderColor = UIColor.defaultBorderColor
            tfConfirmation.rightImage = nil
        }
    }
    
    private func validate() -> Bool {
        guard let password = tfPassword.text, !password.isEmpty else { return false }
        guard let confirmation = tfConfirmation.text, !confirmation.isEmpty else { return false }
        if password.count < 6 {
            updateErrorInfo(showErrorPanel: true, withMessage: "A senha deve conter ao menos 6 caracteres.")
            return false
        }
        
        if password != confirmation {
            updateErrorInfo(showErrorPanel: true, withMessage: "As senhas não coincidem, tente novamente.")
            return false
        }
        
        updateErrorInfo(showErrorPanel: false)
        return true
    }
    
    private func createPassword() {
        if !validate() {
            return
        }

        guard let username = AppContext.shared.user.login, let newPassword = self.tfPassword.text else { return }
        let oldPassword = username.onlyNumbers().prefix(8).trimmingCharacters(in: .whitespaces)

        LoadingVC.instance.show()
        UserService.shared.requestUserToken(login: username, password: oldPassword) { (error) in
            LoadingVC.instance.hide()
            if let error = error {
                self.handleNetworking(error: error, forViewController: self, completion: nil)
            } else {
                UserService.shared.changeUserPassword(from: oldPassword, to: newPassword, withCompletion: { (error) in
                    LoadingVC.instance.hide()
                    if let error = error {
                        self.handleNetworking(error: error, forViewController: self, completion: nil)
                        
                    } else {
                        AppContext.shared.user.login = username
                        AppContext.shared.user.password = newPassword
                        
                        if AppContext.shared.user.hasEmail {
                            self.performSegue(withIdentifier: "welcome", sender: nil)
                        } else {
                            self.performSegue(withIdentifier: "informEmail", sender: nil)
                        }
                    }
                })
            }
        }
    }
    
    @objc private func scrollViewHideKeyboard() {
        hideKeyboard()
    }
    
    // MARK: - IBActions
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        setButtonStatus()
    }
    
    @IBAction func didTapCloseErrorPanelButton(_ sender: Any) {
        updateErrorInfo(showErrorPanel: false)
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        closeViewController()
    }
    
    @IBAction func didTapContinueButton(_ sender: UIButton) {
        createPassword()
    }
    
}


// MARK: - AlertDelegate
extension CreatePasswordVC: AlertDelegate {
    
    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?) {
        if result == .right, id == Constants.ALERTS._CHECK_CONNECTION_ALERT_ID {
            checkConnection()
        }
    }
    
}
