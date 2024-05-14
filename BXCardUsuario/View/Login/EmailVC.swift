//
//  EmailVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 25/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class EmailVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwContents: UIView!
    @IBOutlet weak var svScroll: UIScrollView!
    @IBOutlet weak var tfEmail: TextField!
    @IBOutlet weak var btnContinue: Button!
    @IBOutlet weak var lbTitle: UILabel!
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tfEmail.becomeFirstResponder()
    }
    
    override func configureScreen() {
        super.configureScreen()
        
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 90
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scrollViewHideKeyboard))
        svScroll.addGestureRecognizer(tapGesture)
        
        setupColors()
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        vwHeader.backgroundColor = UIColor.windowBackground
        vwContents.backgroundColor = UIColor.windowBackground
        
        lbTitle.textColor = UIColor.primaryFontColor
        
        tfEmail.bottomBorderColor = UIColor.defaultBorderColor
        tfEmail.placeholderColor = UIColor.primaryPlaceHolderColor
        tfEmail.textColor = UIColor.secondaryFontColor
        tfEmail.backgroundColor = UIColor.fieldBackgroundColor
        
        btnContinue.disable()
    }
    
    private func saveEmail() {
        guard let email = tfEmail.text else { return }

        serviceExecute { logged in
            if logged {
                LoadingVC.instance.show()
                UserService.shared.updateEmail(email) { (error) in
                    LoadingVC.instance.hide()
                    if let error = error {
                        self.handleNetworking(error: error, forViewController: self, completion: nil)
                        
                    } else {
                        AppContext.shared.user.profile?.email = email
                        AppContext.shared.user.email = email
                        self.performSegue(withIdentifier: "welcome", sender: nil)
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
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        if let email = tfEmail.text, !email.isEmpty, email.isValidEmail() {
            btnContinue.enable()
            
        } else {
            btnContinue.disable()
        }
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        closeViewController()
    }
    
    @IBAction func didTapContinueButton(_ sender: UIButton) {
        saveEmail()
    }
    
}
