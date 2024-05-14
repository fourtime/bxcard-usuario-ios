//
//  NoGeoLocationVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 18/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class NoGeoLocationVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwContainer: ShadowedView!
    @IBOutlet weak var btnSettings: Button!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var vwFilter: ShadowedView!
    @IBOutlet weak var lbScreenTitle: UILabel!
    
    // MARK: - Public Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColors()
        lbTitle.text = "Rede Credenciada \(AppContext.shared.user.selectedCard != nil ? " - \(AppContext.shared.user.selectedCard!.label)" : "")"
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        vwHeader.backgroundColor = .titleBarBackgroundColor
        vwContainer.backgroundColor = UIColor.slideUpAlertBackground
        
        vwFilter.backgroundColor = UIColor.cardBackground
        
        lbScreenTitle.textColor = UIColor.degradeTitleFontColor
        lbTitle.textColor = UIColor.primaryFontColor
        lbMessage.textColor = UIColor.primaryFontColor
        
        btnSettings.enable()
    }
    
    // MARK: - IBActions
    @IBAction func didTapSettingsButton(_ sender: UIButton) {
        Utils.openAppSettings { (_) in
            self.performSegue(withIdentifier: "backToHomeUnwindSegue", sender: nil)
        }
    }
    
}
