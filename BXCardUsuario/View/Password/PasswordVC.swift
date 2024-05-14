//
//  PasswordVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 21/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import InputMask

class PasswordVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var vwError: ShadowedView!
    @IBOutlet weak var lbErrorMessage: UILabel!
    @IBOutlet var cpfListener: MaskedTextFieldDelegate!
    @IBOutlet weak var tfCPF: TextField!
    @IBOutlet weak var btnRecover: Button!
    @IBOutlet weak var errorTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var btnHelp: Button!
    
    // MARK: - Private Properties
    private var currentTopConstraint: CGFloat!
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()

        configureScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.checkConnection()
    }
    
    override func configureScreen() {
        super.configureScreen()
        
        setupColors()
        
        currentTopConstraint = errorTopConstraint.constant
        errorTopConstraint.constant = (vwError.frame.height + currentTopConstraint) * -1.0
    }
    
    @objc override func keyboardWillAppear(_ notification: Notification) {
        updateErrorInfo(showErrorPanel: false)
    }
    
    @objc override func lostConnection(_ notification: Notification) {
        self.checkConnection()
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        vwError.backgroundColor = UIColor.defaultErrorColor
        lbErrorMessage.textColor = UIColor.defaultErrorMessageColor
        
        lbTitle.textColor = UIColor.primaryFontColor
        lbSubtitle.textColor = UIColor.secondaryFontColor
        
        tfCPF.placeholderColor = UIColor.primaryPlaceHolderColor
        tfCPF.borderColor = UIColor.defaultBorderColor
        tfCPF.textColor = UIColor.secondaryFontColor
        tfCPF.backgroundColor = UIColor.fieldBackgroundColor
        
        btnRecover.disable()
        btnHelp.tintColor = UIColor.secondaryFontColor
    }
    
    private func checkConnection() {
        if !ConnectivityService.instance.isConnected {
            showNetworkConnectionAlert(forController: self)
        }
    }
    
    private func updateErrorInfo(showErrorPanel show: Bool) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            if show {
                self.errorTopConstraint.constant = self.currentTopConstraint
            } else {
                self.errorTopConstraint.constant = (self.vwError.frame.height + self.currentTopConstraint) * -1.0
            }
            self.view.layoutIfNeeded()
        })
        
        if show {
            tfCPF.borderColor = UIColor.errorBorderColor
            tfCPF.rightImage = Constants.IMAGES._TEXTFIELD_ERROR_IMAGE
            
        } else {
            tfCPF.borderColor = UIColor.defaultBorderColor
            tfCPF.rightImage = nil
        }
    }
    
    private func recoveryPassword() {
        guard let username = self.tfCPF.text?.onlyNumbers() else {
            updateErrorInfo(showErrorPanel: true)
            return
        }

        UserService.shared.recoverPassword(cpf: username) { error in
            if let error = error {
                self.handleNetworking(error: error, forViewController: self, completion: nil)
            } else {
                self.performSegue(withIdentifier: "sendEmailVCSegue", sender: nil)
            }
        }
    }
    
    private func getHelp() {
        LoadingVC.instance.show()
        UtilService.instance.getUsefullLink(forId: .operatorContact) { (url, error) in
            LoadingVC.instance.hide()
            if let error = error {
                self.handleNetworking(error: error, forViewController: self, completion: nil)
            } else if let url = url {
                Utils.openURLOnSafari(forController: self, withUrl: url)
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func didTapBackButton(_ sender: UIButton) {
        closeViewController()
    }
    
    @IBAction func didTapCloseErrorPanelButton(_ sender: Any) {
        updateErrorInfo(showErrorPanel: false)
    }
    
    @IBAction func didTapRecoveryButton(_ sender: UIButton) {
        recoveryPassword()
    }
    
    @IBAction func didTapHelpButton(_ sender: UIButton) {
        getHelp()
    }
    
}


// MARK: - MaskedTextFieldDelegateListener
extension PasswordVC: MaskedTextFieldDelegateListener {
    
    func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        if textField == tfCPF, let cpf = tfCPF.text, cpf.count == 14 {
            btnRecover.enable()
            self.hideKeyboard()
            
        } else {
            btnRecover.disable()
        }
    }
    
}


// MARK: - AlertDelegate
extension PasswordVC: AlertDelegate {
    
    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?) {
        if result == .right && id == Constants.ALERTS._CHECK_CONNECTION_ALERT_ID {
            checkConnection()
        }
    }
    
}
