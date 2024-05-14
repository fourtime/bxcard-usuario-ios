//
//  ViewController.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 20/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import InputMask
import IQKeyboardManagerSwift

class CpfVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tfCPF: TextField!
    @IBOutlet weak var btnContinue: Button!
    @IBOutlet var cpfListener: MaskedTextFieldDelegate!
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkConnection()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let vc = segue.destination as? CardNumberVC {
            vc.cpf = self.tfCPF.text
        }
    }
    
    override func configureScreen() {
        super.configureScreen()
        
        tfCPF.clear()
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 90
        
        setupColors()
        setButtonStatus()
    }
    
    @objc override func lostConnection(_ notification: Notification) {
        checkConnection()
    }

    // MARK: - Private Methods
    private func setupColors() {
        lbTitle.textColor = UIColor.primaryFontColor
        
        tfCPF.placeholderColor = UIColor.primaryPlaceHolderColor
        tfCPF.borderColor = UIColor.defaultBorderColor
        tfCPF.textColor = UIColor.secondaryFontColor
        tfCPF.backgroundColor = UIColor.fieldBackgroundColor
    }
    
    private func checkConnection() {
        if !ConnectivityService.instance.isConnected {
            showNetworkConnectionAlert(forController: self)
            
        } else {
            tfCPF.becomeFirstResponder()
        }
    }
    
    private func setButtonStatus() {
        if let cpf = tfCPF.text, cpf.count == 14 {
            btnContinue.enable()
            hideKeyboard()
            
        } else {
            btnContinue.disable()
        }
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        closeViewController()
    }
}


// MARK: - MaskedTextFieldDelegateListener
extension CpfVC: MaskedTextFieldDelegateListener {
    
    func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        setButtonStatus()
    }
    
}


// MARK: - AlertDelegate
extension CpfVC: AlertDelegate {
    
    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?) {
        if result == .right && id == Constants.ALERTS._CHECK_CONNECTION_ALERT_ID {
            checkConnection()
        }
    }
    
}

