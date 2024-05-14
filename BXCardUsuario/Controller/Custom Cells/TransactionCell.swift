//
//  TransactionCell.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 12/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var lbPlace: UILabel!
    @IBOutlet weak var lbDay: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    
    // MARK: - Public API
    var transaction: Transaction? {
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
        lbPlace.textColor = UIColor.primaryDarkFontColor
        lbDay.textColor = UIColor.secondaryFontColor
        lbValue.textColor = UIColor.primaryDarkFontColor
    }
    
    private func updateUI() {
        setupColors()
        if let transaction = transaction {
            lbPlace.text = transaction.place
            lbDay.text = transaction.day
            lbValue.text = transaction.formattedValue
            lbValue.textColor = transaction.type.typeColor
        }
    }
    
}
