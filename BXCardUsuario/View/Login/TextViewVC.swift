//
//  TextViewVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 12/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

// MARK: - TextType Enum
enum TextType {
    
    case useTerms
    case privacyPolitics
    
    var description: String {
        switch self {
        case .useTerms:
            return "Termo de Uso"
            
        case .privacyPolitics:
            return "Política de Privacidade"
        }
    }
    
}


class TextViewVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var lbWindowTitle: UILabel!
    @IBOutlet weak var taText: UITextView!
    @IBOutlet weak var vwContainer: ShadowedView!
    
    // MARK: - Public Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var textType: TextType?
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColors()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkConnection()
    }
    
    @objc override func lostConnection(_ notification: Notification) {
        checkConnection()
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        view.applyGradient(withColours: Constants.COLORS._GRADIENT_ENABLED_COLORS, gradientOrientation: .horizontal)
        vwContainer.backgroundColor = UIColor.slideUpAlertBackground
        
    }
    
    private func checkConnection() {
        if !ConnectivityService.instance.isConnected {
            showNetworkConnectionAlert(forController: self)
            
        } else {
            if let textType = textType {
                lbWindowTitle.text = textType.description
                
                switch textType {
                case .useTerms:
                    loadUseTerms()
                    
                case .privacyPolitics:
                    loadPrivacyPolitics()
                }
            }
        }
    }
    
    private func getHtml(fromData data: Data) -> NSAttributedString? {
        do {
            let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return attributedString
            
        } catch {
            return nil
        }
    }
    
    private func loadUseTerms() {
        LoadingVC.instance.show()
        UtilService.instance.getUseTerms { (useTermsData, error) in
            LoadingVC.instance.hide()
            if let error = error {
                self.handleNetworking(error: error, forViewController: self, completion: nil)
                
            } else if let useTermsData = useTermsData, let attributedText = self.getHtml(fromData: useTermsData) {
                self.taText.attributedText = attributedText
            } else {
                self.taText.text = ""
            }
        }
    }
    
    private func loadPrivacyPolitics() {
        LoadingVC.instance.show()
        UtilService.instance.getPrivacyPolitics { (privacyPoliticsData, error) in
            LoadingVC.instance.hide()
            if let error = error {
                self.handleNetworking(error: error, forViewController: self, completion: nil)
                
            } else if let privacyPoliticsData = privacyPoliticsData, let attributedText = self.getHtml(fromData: privacyPoliticsData) {
                self.taText.attributedText = attributedText
            } else {
                self.taText.text = ""
            }
        }
        
    }
    
    // MARK: - IBActions
    @IBAction func didTapBackButton(_ sender: UIButton) {
        closeViewController()
    }

}


// MARK: - AlertDelegate
extension TextViewVC: AlertDelegate {
    
    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?) {
        if result == .right, id == Constants.ALERTS._CHECK_CONNECTION_ALERT_ID {
            checkConnection()
        }
    }
    
}
