//
//  PaymentSummaryVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 14/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class PaymentSummaryVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var lbAssociatedName: UILabel!
    @IBOutlet weak var lbAssociatedAddress: UILabel!
    @IBOutlet weak var lbPaymentValue: UILabel!
    @IBOutlet weak var lbPaymentParcels: UILabel!
    @IBOutlet weak var lbCardType: UILabel!
    @IBOutlet weak var lbCardLastDigits: UILabel!
    @IBOutlet weak var btnPay: Button!
    @IBOutlet weak var vwContainer: ShadowedView!
    @IBOutlet weak var vwImage: ShadowedView!
    @IBOutlet weak var vwAssociated: ShadowedView!
    @IBOutlet weak var lbCurrencySymbol: UILabel!
    @IBOutlet weak var vwValue: ShadowedView!
    @IBOutlet weak var lbScreenTitle: UILabel!
    
    // MARK: - Public Properties
    var token: String?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private Properties
    private var paymentIdResponse: PaymentIDResponse?
    
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
        setupColors()
        clearSummary()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paymentPasswordVCSegue", let paymentPasswordVC = segue.destination as? PaymentPasswordVC {
            paymentPasswordVC.paymentToken = sender as? String
            paymentPasswordVC.paymentIdResponse = paymentIdResponse
        }
    }
    
    @objc override func lostConnection(_ notification: Notification) {
        checkConnection()
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        vwHeader.backgroundColor = .titleBarBackgroundColor
        view.applyGradient(withColours: Constants.COLORS._GRADIENT_ENABLED_COLORS, gradientOrientation: .horizontal)
        lbScreenTitle.textColor = UIColor.degradeTitleFontColor
        
        vwContainer.backgroundColor = UIColor.slideUpAlertBackground
        vwImage.backgroundColor = UIColor.cardBackground
        
        vwAssociated.bottomBorderColor = UIColor.defaultBorderColor
        lbAssociatedName.textColor = UIColor.primaryFontColor
        lbAssociatedAddress.textColor = UIColor.primaryLightFontColor
        
        vwValue.bottomBorderColor = UIColor.defaultBorderColor
        lbCurrencySymbol.textColor = UIColor.secondaryFontColor
        lbPaymentValue.textColor = UIColor.secondaryFontColor
        
        lbCardType.textColor = UIColor.secondaryFontColor
        lbCardLastDigits.textColor = UIColor.secondaryFontColor
        
        btnPay.enable()
    }
    
    private func loadPaymentInfo() {
        if let token = token {
            serviceExecute { logged in
                if logged {
                    LoadingVC.instance.show()
                    PaymentService.instance.identifyPayment(forToken: token) { (response, error) in
                        LoadingVC.instance.hide()
                        if let error = error {
                            self.handleNetworking(error: error, forViewController: self, completion: nil)
                            
                        } else if let response = response {
                            self.loadPaymentInfo(fromPaymentResponse: response)
                            
                        } else {
                            self.showGenericErrorAlert(forController: self)
                        }
                    }
                    
                } else {
                    self.showGenericErrorAlert(forController: self)
                }
            }
        }
    }
    
    private func checkConnection() {
        if !ConnectivityService.instance.isConnected {
            showNetworkConnectionAlert(forController: self)
            
        } else {
            loadPaymentInfo()
        }
    }
    
    private func clearSummary() {
        lbAssociatedName.clear()
        lbAssociatedAddress.clear()
        lbPaymentValue.text = "0,00"
        lbPaymentParcels.clear()
        lbCardType.clear()
        lbCardLastDigits.clear()
    }
    
    private func loadPaymentInfo(fromPaymentResponse response: PaymentIDResponse) {
        paymentIdResponse = response
        
        lbAssociatedName.text = paymentIdResponse!.paymentID.associated
        lbAssociatedAddress.text = paymentIdResponse!.paymentID.address
        lbPaymentParcels.text = paymentIdResponse!.paymentID.condition
        lbPaymentValue.text = Utils.formatCurrency(value: paymentIdResponse!.paymentID.value)
        
        if let selectedCard = AppContext.shared.user.selectedCard {
            lbCardType.text = selectedCard.label
            lbCardLastDigits.text = selectedCard.last4Digits
        }
    }
    
    // MARK: - IBActions
    @IBAction func didTapBackButton(_ sender: UIButton) {
        closeViewController()
    }
    
    @IBAction func didTapPayButton(_ sender: UIButton) {
        performSegue(withIdentifier: "paymentPasswordVCSegue", sender: token)
    }

}


// MARK: - AlertDelegate
extension PaymentSummaryVC: AlertDelegate {
    
    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?) {
        if result == .right, id == Constants.ALERTS._CHECK_CONNECTION_ALERT_ID {
            checkConnection()
        }
    }
    
}

