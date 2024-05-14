//
//  SendEmailVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 21/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class SendEmailVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var btnLogin: Button!
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupColors()
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        lbTitle.textColor = UIColor.primaryFontColor
        lbDescription.textColor = UIColor.secondaryFontColor
        
        btnLogin.enable()
    }

}
