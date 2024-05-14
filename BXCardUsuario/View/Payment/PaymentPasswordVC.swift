//
//  PaymentPasswordVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 14/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class PaymentPasswordVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var tfDigit1: TextField!
    @IBOutlet weak var tfDigit2: TextField!
    @IBOutlet weak var tfDigit3: TextField!
    @IBOutlet weak var tfDigit4: TextField!
    @IBOutlet weak var btnPay: Button!
    @IBOutlet weak var lbScreenTitle: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var vwContainer: ShadowedView!
    @IBOutlet weak var vwImage: ShadowedView!
    
    // MARK: - Private Properties
    private var oldDigit1 = ""
    private var oldDigit2 = ""
    private var oldDigit3 = ""
    private var oldDigit4 = ""
    
    // MARK: - Public Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var paymentToken: String?
    var paymentIdResponse: PaymentIDResponse?
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(goToPrevious(_:)), name: Notification.Name(Constants.NOTIFICATIONS._DELETE_EDIT_TEXT_CHAR_NOTIFICATION), object: nil)
        
        configureScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkConnection()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paymentConfirmationVCSegue", let confirmationVC = segue.destination as? PaymentConfirmationVC {
            confirmationVC.paymentResponse = sender as? PaymentResponse
            confirmationVC.paymentIdResponse = paymentIdResponse
        }
    }
    
    override func configureScreen() {
        setupColors()
        
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 90
    }
    
    @objc override func lostConnection(_ notification: Notification) {
        hideKeyboard()
        checkConnection()
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        vwHeader.backgroundColor = .titleBarBackgroundColor
        view.applyGradient(withColours: Constants.COLORS._GRADIENT_ENABLED_COLORS, gradientOrientation: .horizontal)
        lbScreenTitle.textColor = UIColor.degradeTitleFontColor
        
        vwContainer.backgroundColor = UIColor.slideUpAlertBackground
        vwImage.backgroundColor = UIColor.cardBackground
        lbTitle.textColor = UIColor.primaryFontColor
        
        tfDigit1.placeholderColor = UIColor.primaryPlaceHolderColor
        tfDigit1.borderColor = UIColor.defaultBorderColor
        tfDigit1.textColor = UIColor.secondaryFontColor
        tfDigit1.backgroundColor = UIColor.fieldBackgroundColor
        
        tfDigit2.placeholderColor = UIColor.primaryPlaceHolderColor
        tfDigit2.borderColor = UIColor.defaultBorderColor
        tfDigit2.textColor = UIColor.secondaryFontColor
        tfDigit2.backgroundColor = UIColor.fieldBackgroundColor
        
        tfDigit3.placeholderColor = UIColor.primaryPlaceHolderColor
        tfDigit3.borderColor = UIColor.defaultBorderColor
        tfDigit3.textColor = UIColor.secondaryFontColor
        tfDigit3.backgroundColor = UIColor.fieldBackgroundColor
        
        tfDigit4.placeholderColor = UIColor.primaryPlaceHolderColor
        tfDigit4.borderColor = UIColor.defaultBorderColor
        tfDigit4.textColor = UIColor.secondaryFontColor
        tfDigit4.backgroundColor = UIColor.fieldBackgroundColor
        
        btnPay.disable()
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
    
    private func pay() {
        if let paymentToken = paymentToken, let selectedCard = AppContext.shared.user.selectedCard {
            serviceExecute { logged in
                if logged {
                    let cardPassword = "\(self.tfDigit1.text!)\(self.tfDigit2.text!)\(self.tfDigit3.text!)\(self.tfDigit4.text!)"
                    LoadingVC.instance.show()
                    PaymentService.instance.pay(forToken: paymentToken, withCardID: selectedCard.id, andCardPassword: cardPassword) { (response, error) in
                        LoadingVC.instance.hide()
                        if let error = error {
                            self.handleNetworking(error: error, forViewController: self, completion: nil)
                            
                        } else {
                            self.performSegue(withIdentifier: "paymentConfirmationVCSegue", sender: response)
                        }
                    }
                    
                } else {
                    self.showGenericErrorAlert(forController: self)
                }
            }
        }
    }
    
    private func setButtonStatus() {
        if let digit1 = tfDigit1.text, let digit2 = tfDigit2.text, let digit3 = tfDigit3.text, let digit4 = tfDigit4.text, digit1.count == 1, digit2.count == 1, digit3.count == 1, digit4.count == 1 {
            btnPay.enable()
        } else {
            btnPay.disable()
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
        
        oldDigit1 = newDigit1
        oldDigit2 = newDigit2
        oldDigit3 = newDigit3
        oldDigit4 = newDigit4
        
        setButtonStatus()
    }
    
    @IBAction func didTapPayButton(_ sender: UIButton) {
        pay()
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        closeViewController()
    }

}


// MARK: - AlertDelegate
extension PaymentPasswordVC: AlertDelegate {
    
    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?) {
        if result == .right, id == Constants.ALERTS._CHECK_CONNECTION_ALERT_ID {
            checkConnection()
            
        } else {
            performSegue(withIdentifier: "backToHomeVCSegue", sender: nil)
        }
    }
    
}
