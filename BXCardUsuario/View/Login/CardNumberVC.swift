//
//  CardNumberVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 21/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CardNumberVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwContents: UIView!
    @IBOutlet weak var vwError: ShadowedView!
    @IBOutlet weak var svScroll: UIScrollView!
    @IBOutlet weak var tfDigit1: TextField!
    @IBOutlet weak var tfDigit2: TextField!
    @IBOutlet weak var tfDigit3: TextField!
    @IBOutlet weak var tfDigit4: TextField!
    @IBOutlet weak var btnContinue: Button!
    @IBOutlet weak var errorTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lbErrorMessage: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    
    // MARK: - Private Properties
    private var currentTopConstraint: CGFloat!
    private var oldDigit1 = ""
    private var oldDigit2 = ""
    private var oldDigit3 = ""
    private var oldDigit4 = ""
    
    var cpf: String?
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollViewHideKeyboard))
        svScroll.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToPrevious(_:)), name: Notification.Name(Constants.NOTIFICATIONS._DELETE_EDIT_TEXT_CHAR_NOTIFICATION), object: nil)
        
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 90
        currentTopConstraint = errorTopConstraint.constant
        
        if cpf == nil || cpf?.isEmpty == true {
            self.closeViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkConnection()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func configureScreen() {
        super.configureScreen()
        
        errorTopConstraint.constant = (vwError.frame.height + currentTopConstraint) * -1.0
        
        tfDigit1.clear()
        tfDigit2.clear()
        tfDigit3.clear()
        tfDigit4.clear()
        /*
        if let card = AppContext.shared.user.cardTail {
            tfDigit1.text = card.charAt(index: 0)
            tfDigit2.text = card.charAt(index: 1)
            tfDigit3.text = card.charAt(index: 2)
            tfDigit4.text = card.charAt(index: 3)
        }*/
        
        setupColors()
        setButtonStatus()
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
        vwContents.backgroundColor = UIColor.windowBackground
        
        vwError.backgroundColor = UIColor.defaultErrorColor
        lbErrorMessage.textColor = UIColor.defaultErrorMessageColor
        
        lbTitle.textColor = UIColor.primaryFontColor
        
        tfDigit1.bottomBorderColor = UIColor.defaultBorderColor
        tfDigit1.placeholderColor = UIColor.primaryPlaceHolderColor
        tfDigit1.textColor = UIColor.secondaryFontColor
        tfDigit1.backgroundColor = UIColor.fieldBackgroundColor
        
        tfDigit2.bottomBorderColor = UIColor.defaultBorderColor
        tfDigit2.placeholderColor = UIColor.primaryPlaceHolderColor
        tfDigit2.textColor = UIColor.secondaryFontColor
        tfDigit2.backgroundColor = UIColor.fieldBackgroundColor
        
        tfDigit3.bottomBorderColor = UIColor.defaultBorderColor
        tfDigit3.placeholderColor = UIColor.primaryPlaceHolderColor
        tfDigit3.textColor = UIColor.secondaryFontColor
        tfDigit3.backgroundColor = UIColor.fieldBackgroundColor
        
        tfDigit4.bottomBorderColor = UIColor.defaultBorderColor
        tfDigit4.placeholderColor = UIColor.primaryPlaceHolderColor
        tfDigit4.textColor = UIColor.secondaryFontColor
        tfDigit4.backgroundColor = UIColor.fieldBackgroundColor
    }
    
    private func checkConnection() {
        if !ConnectivityService.instance.isConnected {
            showNetworkConnectionAlert(forController: self)
            
        } else {
            if let digit1 = tfDigit1.text, digit1.isEmpty {
                tfDigit1.becomeFirstResponder()
                
            } else if let digit2 = tfDigit2.text, digit2.isEmpty {
                tfDigit2.becomeFirstResponder()
                
            } else if let digit3 = tfDigit3.text, digit3.isEmpty {
                tfDigit3.becomeFirstResponder()
                
            } else if let digit4 = tfDigit4.text, digit4.isEmpty {
                tfDigit4.becomeFirstResponder()
            }
        }
    }
    
    private func setButtonStatus() {
        if let digit1 = tfDigit1.text, let digit2 = tfDigit2.text, let digit3 = tfDigit3.text, let digit4 = tfDigit4.text, digit1.count == 1, digit2.count == 1, digit3.count == 1, digit4.count == 1 {
            btnContinue.enable()
            
        } else {
            btnContinue.disable()
        }
    }
    
    private func updateErrorInfo(showErrorPanel show: Bool) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            if show {
                self.errorTopConstraint.constant = self.currentTopConstraint
                
            } else {
                self.errorTopConstraint.constant = (self.vwError.frame.height + self.currentTopConstraint) * -1.0
            }
            
            self.view.layoutIfNeeded()
        })
        
        if show {
            tfDigit1.borderColor = UIColor.errorBorderColor
            tfDigit2.borderColor = UIColor.errorBorderColor
            tfDigit3.borderColor = UIColor.errorBorderColor
            tfDigit4.borderColor = UIColor.errorBorderColor
            
        } else {
            tfDigit1.borderColor = UIColor.defaultBorderColor
            tfDigit2.borderColor = UIColor.defaultBorderColor
            tfDigit3.borderColor = UIColor.defaultBorderColor
            tfDigit4.borderColor = UIColor.defaultBorderColor
        }
    }
    
    private func validateCard() {
        LoadingVC.instance.show()
        ApplicationService.shared.authenticate { (error) in
            if let error = error {
                LoadingVC.instance.hide()
                self.handleNetworking(error: error, forViewController: self, completion: nil)
                
            } else {
                let username = self.cpf ?? ""
                let last4Digits = "\(self.tfDigit1.text!)\(self.tfDigit2.text!)\(self.tfDigit3.text!)\(self.tfDigit4.text!)"

                UserService.shared.startUserTerminal(forCPF: username, andLast4Digits: last4Digits) { (error) in
                    LoadingVC.instance.hide()
                    if let error = error {
                        self.handleNetworking(error: error, forViewController: self, completion: nil)
                    } else {
                        if AppContext.shared.user.isFirstAccess {
                            self.performSegue(withIdentifier: "createPassword", sender: nil)
                        } else {
                            self.performSegue(withIdentifier: "informPassword", sender: nil)
                        }
                    }
                }
            }
        }
    }
    
    @objc private func scrollViewHideKeyboard() {
        hideKeyboard()
    }
    
    @objc private func goToPrevious(_ notification: Notification) {
        if let digitPressed = notification.object as? TextField {
            if digitPressed == tfDigit2 {
                tfDigit1.becomeFirstResponder()
            } else if digitPressed == tfDigit3 {
                tfDigit2.becomeFirstResponder()
            } else if digitPressed == tfDigit4 {
                tfDigit3.becomeFirstResponder()
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func textFieldEditingChanged(_ sender: TextField) {
        guard let newDigit1 = tfDigit1.text else { return }
        guard let newDigit2 = tfDigit2.text else { return }
        guard let newDigit3 = tfDigit3.text else { return }
        guard let newDigit4 = tfDigit4.text else { return }

        if sender == tfDigit1, newDigit1.count == 1 {
            tfDigit2.becomeFirstResponder()
        } else if sender == tfDigit2 {
            if newDigit2.count == 1 {
                tfDigit3.becomeFirstResponder()
            } else if newDigit2.count == 0 && oldDigit2.count == 1 {
                tfDigit1.becomeFirstResponder()
            }
        } else if sender == tfDigit3 {
            if newDigit3.count == 1 {
                tfDigit4.becomeFirstResponder()
            } else if newDigit3.count == 0 && oldDigit3.count == 1 {
                tfDigit2.becomeFirstResponder()
            }
        } else if sender == tfDigit4 {
            if newDigit4.count == 1 {
                tfDigit4.resignFirstResponder()
            } else if newDigit4.count == 0 && oldDigit4.count == 1 {
                tfDigit3.becomeFirstResponder()
            }
        }

        oldDigit1 = newDigit1.prefix(1).trimmingCharacters(in: .whitespaces)
        oldDigit2 = newDigit2.prefix(1).trimmingCharacters(in: .whitespaces)
        oldDigit3 = newDigit3.prefix(1).trimmingCharacters(in: .whitespaces)
        oldDigit4 = newDigit4.prefix(1).trimmingCharacters(in: .whitespaces)

        setButtonStatus()
    }
    
    @IBAction func didTapCloseErrorPanelButton(_ sender: Any) {
        updateErrorInfo(showErrorPanel: false)
    }
    
    @IBAction func didTapContinueButton(_ sender: UIButton) {
        validateCard()
    }
    @IBAction func didTapBackButton(_ sender: UIButton) {
        closeViewController()
    }
}


// MARK: - AlertDelegate
extension CardNumberVC: AlertDelegate {
    
    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?) {
        if result == .right && id == Constants.ALERTS._CHECK_CONNECTION_ALERT_ID {
            checkConnection()
        }
    }
    
}

