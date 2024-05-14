//
//  PaymentConfirmationVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 14/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import NotificationCenter

class PaymentConfirmationVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var btnFinish: Button!
    @IBOutlet weak var lbScreenTitle: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var vwContainer: ShadowedView!
    @IBOutlet weak var vwImage: ShadowedView!
    @IBOutlet weak var vwVoucher: ShadowedView!
    
    @IBOutlet weak var lbAssociatedName: UILabel!
    
    @IBOutlet weak var lbPaymentValueLabel: UILabel!
    @IBOutlet weak var lbPaymentValue: UILabel!
    
    @IBOutlet weak var lbPaymentDateTimeLabel: UILabel!
    @IBOutlet weak var lbPaymentDateTime: UILabel!
    
    @IBOutlet weak var lbAuthorizationIDLabel: UILabel!
    @IBOutlet weak var lbAuthorizationID: UILabel!
    
    @IBOutlet weak var lbNewBalanceLabel: UILabel!
    @IBOutlet weak var lbNewBalance: UILabel!
    
    @IBOutlet weak var lbTransactionIDLabel: UILabel!
    @IBOutlet weak var lbTransactionID: UILabel!
    
    
    
    // MARK: - Public Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var paymentResponse: PaymentResponse?
    var paymentIdResponse: PaymentIDResponse?
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()

        configureScreen()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeVCSegue" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NOTIFICATIONS._PAYMENT_CONFIRMATION_NOTIFICATION), object: nil)
        }
    }
    
    override func configureScreen() {
        setupColors()
        loadPaymentSummary()
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        vwHeader.backgroundColor = .titleBarBackgroundColor
        view.applyGradient(withColours: Constants.COLORS._GRADIENT_ENABLED_COLORS, gradientOrientation: .horizontal)
        lbScreenTitle.textColor = UIColor.degradeTitleFontColor
        
        vwContainer.backgroundColor = UIColor.slideUpAlertBackground
        vwImage.backgroundColor = UIColor.cardBackground
        lbTitle.textColor = UIColor.primaryFontColor
        
        vwVoucher.borderColor = UIColor.lightBorderColor
        vwVoucher.backgroundColor = UIColor.extraLightHighlightBackground
        
        lbAssociatedName.textColor = UIColor.primaryDarkFontColor
        
        lbPaymentValueLabel.textColor = UIColor.primaryDarkFontColor
        lbPaymentValue.textColor = UIColor.primaryDarkFontColor
        
        lbPaymentDateTimeLabel.textColor = UIColor.primaryDarkFontColor
        lbPaymentDateTime.textColor = UIColor.primaryDarkFontColor
        
        lbAuthorizationIDLabel.textColor = UIColor.primaryDarkFontColor
        lbAuthorizationID.textColor = UIColor.primaryDarkFontColor
        
        lbNewBalanceLabel.textColor = UIColor.primaryDarkFontColor
        lbNewBalance.textColor = UIColor.primaryDarkFontColor
        
        lbTransactionIDLabel.textColor = UIColor.primaryDarkFontColor
        lbTransactionID.textColor = UIColor.primaryDarkFontColor
        
        btnFinish.enable()
    }
    
    private func loadPaymentSummary() {
        if let paymentResponse = paymentResponse, let paymentIdResponse = paymentIdResponse {
            lbAssociatedName.text = paymentIdResponse.paymentID.associated
            lbPaymentValue.text = paymentIdResponse.paymentID.formattedValue
            lbPaymentDateTime.text = paymentResponse.payment.formattedAuthDateTime
            lbAuthorizationID.text = paymentResponse.payment.nsuAuth
            lbNewBalance.text = paymentResponse.payment.formattedNewBalance
            lbTransactionID.text = paymentResponse.payment.nsuHost
        }
    }
    
    // MARK: - IBActions
    @IBAction func didPressFinishButton(_ sender: UIButton) {
        performSegue(withIdentifier: "homeVCSegue", sender: nil)
    }
    
}
