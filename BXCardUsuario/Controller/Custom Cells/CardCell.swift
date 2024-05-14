//
//  CardCell.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 12/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var vwColor: UIView!
    @IBOutlet weak var lbCardNumber: UILabel!
    @IBOutlet weak var lbCardType: UILabel!
    @IBOutlet weak var lbAvailableBalance: UILabel!
    @IBOutlet weak var lbNextRechargeDateLabel: UILabel!
    @IBOutlet weak var lbNextRechargeDate: UILabel!
    @IBOutlet weak var lbNextRechargeValueLabel: UILabel!
    @IBOutlet weak var lbNextRechargeValue: UILabel!
    @IBOutlet weak var lbCurrencySymbol: UILabel!
    @IBOutlet weak var lbAvailableBalanceLabel: UILabel!
    @IBOutlet weak var vwTopSeparator: UIView!
    @IBOutlet weak var vwBottomSeparator: UIView!
    
    // MARK: - Public Properties
    var card: Card? {
        didSet {
            updateUI()
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        contentView.backgroundColor = UIColor.defaultTableViewBackground
        lbCardNumber.textColor = UIColor.primaryDarkFontColor
        lbCardType.textColor = UIColor.primaryDarkFontColor
        vwTopSeparator.backgroundColor = UIColor.separatorColor
        lbCurrencySymbol.textColor = UIColor.primaryFontColor
        lbAvailableBalance.textColor = UIColor.primaryFontColor
        lbAvailableBalanceLabel.textColor = UIColor.secondaryFontColor
        vwBottomSeparator.backgroundColor = UIColor.separatorColor
        lbNextRechargeDate.textColor = UIColor.primaryDarkFontColor
        lbNextRechargeDateLabel.textColor = UIColor.secondaryFontColor
        lbNextRechargeValue.textColor = UIColor.primaryDarkFontColor
        lbNextRechargeValueLabel.textColor = UIColor.secondaryFontColor
    }
    
    // MARK: - Public Methods
    private func updateUI() {
        setupColors()
        
        if let card = card {
            vwColor.backgroundColor = card.cardColor
            lbCardNumber.text = card.formattedLast4Digits
            lbCardType.text = card.label
            lbAvailableBalance.text = card.formattedBalance
            lbNextRechargeDateLabel.text = card.nextDateLabel
            lbNextRechargeDate.text = card.nextDate
            lbNextRechargeValueLabel.text = card.nextValueLabel
            lbNextRechargeValue.text = card.nextValue
        }
    }
    
}
