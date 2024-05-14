//
//  AssociatedCell.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 18/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class AssociatedCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var lbDistance: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    
    // MARK: - Public API
    var associated: Associated? {
        didSet {
            updateUI()
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        contentView.backgroundColor = UIColor.defaultTableViewCellBackground
        lbName.textColor = UIColor.primaryFontColor
        lbAddress.textColor = UIColor.primaryLightFontColor
        lbDistance.textColor = UIColor.primaryDarkFontColor
    }
    
    // MARK: - Public Methods
    func updateUI() {
        setupColors()
        
        if let associated = associated {
            lbDistance.text = "\(associated.distance) m"
            lbName.text = associated.name
            lbAddress.text = associated.address
        }
    }
    
}
