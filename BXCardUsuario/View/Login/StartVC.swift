//
//  StartVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 20/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class StartVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var btnEnter: Button!
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()

        configureScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.btnEnter.isHidden = true
        
        let user = AppContext.shared.user
        
        if user.isAuthenticated {
            if user.hasEmail {
                self.performSegue(withIdentifier: "home", sender: nil)
            } else {
                self.performSegue(withIdentifier: "informEmail", sender: nil)
            }
        } else if user.hasCredentials {
            self.performSegue(withIdentifier: "informPassword", sender: nil)
        } else {
            self.btnEnter.isHidden = false
        }
    }
    
    // MARK: - Unwind Segues
    @IBAction func startUnwindAction(unwindSegue: UIStoryboardSegue) { }
    
}
