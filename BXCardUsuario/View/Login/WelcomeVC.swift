//
//  WelcomeVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 25/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import NotificationCenter

class WelcomeVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var btnEnter: Button!
    @IBOutlet weak var lbUsername: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    
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
        lbUsername.text = "Boas-vindas, \(AppContext.shared.user.firstName ?? "")"
        setupColors()
    }
    
    @objc override func lostConnection(_ notification: Notification) {
        checkConnection()
    }

    // MARK: - Private Methods
    private func setupColors() {
        lbUsername.textColor = UIColor.primaryFontColor
        lbDescription.textColor = UIColor.secondaryFontColor
        
        btnEnter.setGradientWith(colors: Constants.COLORS._GRADIENT_ENABLED_COLORS)
    }
    
    private func checkConnection() {
        if !ConnectivityService.instance.isConnected {
            showNetworkConnectionAlert(forController: self)
        }
    }
    
    private func login() {
        serviceExecute { loggedIn in
            if loggedIn {
                self.performSegue(withIdentifier: "notification", sender: nil)
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func didTapEnterButton(_ sender: UIButton) {
        login()
    }
    
}


// MARK: - AlertDelegate
extension WelcomeVC: AlertDelegate {
    
    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?) {
        if result == .right, id == Constants.ALERTS._CHECK_CONNECTION_ALERT_ID {
            checkConnection()
        }
    }
    
}



