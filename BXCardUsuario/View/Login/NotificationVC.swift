//
//  NotificationVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 29/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var btnActivate: Button!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()

        setupColors()
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        lbTitle.textColor = UIColor.primaryFontColor
        lbDescription.textColor = UIColor.secondaryFontColor
        
        btnActivate.enable()
    }
    
    private func registerForNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = UIApplication.shared.delegate as? UNUserNotificationCenterDelegate
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                        self.closeNotificationVC()
                    }
                    
                } else {
                    self.closeNotificationVC()
                }
            }
            
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
            closeNotificationVC()
        }
    }
    
    private func closeNotificationVC() {
        performSegue(withIdentifier: "home", sender: nil)
    }
    
    // MARK: - IBActions
    @IBAction func didTapActiveNotificationsButton(_ sender: UIButton) {
        registerForNotifications()
    }
    
    @IBAction func didTapNoButton(_ sender: UIButton) {
        closeNotificationVC()
    }
    
}
