//
//  LoginPasswordVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 21/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class LoginPasswordVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var tfPassword: TextField!
    @IBOutlet weak var btnContinue: Button!
    @IBOutlet weak var vwError: ShadowedView!
    @IBOutlet weak var lbErrorMessage: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var errorTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnForgetPassword: Button!
    
    // MARK: - Private Properties
    private var currentTopConstraint: CGFloat!
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentTopConstraint = errorTopConstraint.constant
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkConnection()
    }
    
    override func configureScreen() {
        super.configureScreen()
        
        vwError.isHidden = true
        errorTopConstraint.constant = (vwError.frame.height + currentTopConstraint) * -1.0
        
        tfPassword.clear()
        tfPassword.becomeFirstResponder()
        
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
        vwError.backgroundColor = UIColor.defaultErrorColor
        lbErrorMessage.textColor = UIColor.defaultErrorMessageColor
        
        lbTitle.textColor = UIColor.primaryFontColor
        
        tfPassword.placeholderColor = UIColor.primaryPlaceHolderColor
        tfPassword.borderColor = UIColor.defaultBorderColor
        tfPassword.textColor = UIColor.secondaryFontColor
        tfPassword.backgroundColor = UIColor.fieldBackgroundColor
        
        btnContinue.disable()
        btnForgetPassword.tintColor = UIColor.secondaryFontColor
    }
    
    private func checkConnection() {
        if !ConnectivityService.instance.isConnected {
            showNetworkConnectionAlert(forController: self)
        }
    }
    
    private func updateErrorInfo(showErrorPanel show: Bool) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.vwError.isHidden = !show
            if show {
                self.errorTopConstraint.constant = self.currentTopConstraint
            } else {
                self.errorTopConstraint.constant = (self.vwError.frame.height + self.currentTopConstraint) * -1.0
            }
            self.view.layoutIfNeeded()
        })
        
        if show {
            tfPassword.borderColor = UIColor.errorBorderColor
            tfPassword.rightImage = Constants.IMAGES._TEXTFIELD_ERROR_IMAGE
            
        } else {
            tfPassword.borderColor = UIColor.defaultBorderColor
            tfPassword.rightImage = nil
        }
    }
    
    private func login() {
        hideKeyboard()
        
        guard let login = AppContext.shared.user.login, let password = tfPassword.text else { return }
        
        LoadingVC.instance.show()
        UserService.shared.authenticate(login: login, password: password) { (error) in
            LoadingVC.instance.hide()
            if let error = error {
                self.handleNetworking(error: error, forViewController: self) { self.updateErrorInfo(showErrorPanel: true) }
            } else {
                UserService.shared.startUserTerminal { error in
                    if let error = error {
                        self.handleNetworking(error: error, forViewController: self) { self.updateErrorInfo(showErrorPanel: true) }
                    } else {
                        if AppContext.shared.user.hasEmail {
                            if AppContext.shared.user.isFirstAccess {
                                self.performSegue(withIdentifier: "welcome", sender: nil)
                            } else {
                                self.performSegue(withIdentifier: "home", sender: nil)
                            }
                        } else {
                            self.performSegue(withIdentifier: "informEmail", sender: nil)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        if let password = tfPassword.text, !password.isEmpty {
            btnContinue.enable()
        } else {
            btnContinue.disable()
        }
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        closeViewController()
    }
    
    @IBAction func didTapCloseErrorPanelButton(_ sender: Any) {
        updateErrorInfo(showErrorPanel: false)
    }
    
    @IBAction func didTapContinueButton(_ sender: UIButton) {
        login()
    }
    
    // MARK: - Unwind Segues
    @IBAction func loginPasswordUnwindAction(unwindSegue: UIStoryboardSegue) { }

}


// MARK: - AlertDelegate
extension LoginPasswordVC: AlertDelegate {
    
    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?) {
        if result == .right && id == Constants.ALERTS._CHECK_CONNECTION_ALERT_ID {
            checkConnection()
        }
    }
    
}
