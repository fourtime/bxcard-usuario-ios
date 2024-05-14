//
//  AlertController.swift
//  Vagow
//
//  Created by Daive Simões on 11/01/19.
//  Copyright © 2018 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

// MARK: - Protocols
protocol AlertDelegate {
    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?)
}


// MARK: - AlertResult Enum
enum AlertResult {
    case right
    case left
    case close
}


// MARK: - ButtonType Enum
enum ButtonType {
    case normal
    case destructive
    case bordered
}


typealias Completion = (() -> ())?


class AlertVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var container: ShadowedView!
    @IBOutlet weak var lbAlertTitle: UILabel!
    @IBOutlet weak var tvAlertDescription: UITextView!
    @IBOutlet weak var btnAlertLeftButton: Button!
    @IBOutlet weak var btnAlertRightButton: Button!
    @IBOutlet weak var btnCloseButton: UIButton!
    @IBOutlet weak var imImage: UIImageView!
    @IBOutlet weak var messageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwContainer: ShadowedView!
    
    // MARK: - Public Properties
    var messageImage: UIImage?
    var messageTitle: String?
    var messageDescription: String?
    var messageDescriptionAlignment: NSTextAlignment?
    var leftButtonTitle: String?
    var rightButtonTitle: String?
    var closeButtonImage: UIImage?
    
    var alertId: String?
    var sender: Any?
    var delegate: AlertDelegate?
    
    var leftButtonType: ButtonType?
    var rightButtonType: ButtonType?
    var leftButtonBorderColor: UIColor?
    var rightButtonBorderColor: UIColor?
    
    var canCloseClickingOutside = false
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAlert()
        container.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupColors()
        openContainer()
    }
    
    // MARK: - Private Methods
    private func openContainer() {
        container.center.y += container.frame.height
        container.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.container.center.y -= self.container.frame.height
        })
    }
    
    private func closeContainer(withCompletion completion: Completion) {
        UIView.animate(withDuration: 0.3, animations: {
            self.container.center.y += self.container.frame.height
        }) { (_) in
            completion?()
        }
    }
    
    private func configureAlert() {
        background.backgroundColor = UIColor.alertTransparentBackground
        vwContainer.backgroundColor = UIColor.slideUpAlertBackground
        imImage.image = messageImage
        lbAlertTitle.text = messageTitle
        tvAlertDescription.text = messageDescription
        btnAlertLeftButton.setTitle(leftButtonTitle, for: UIControl.State())
        btnAlertRightButton.setTitle(rightButtonTitle, for: UIControl.State())
        
        lbAlertTitle.isHidden = messageTitle == nil
        imImage.isHidden = messageImage == nil
        btnCloseButton.isHidden = closeButtonImage == nil
        btnAlertLeftButton.isHidden = leftButtonTitle == nil
        btnAlertRightButton.isHidden = rightButtonTitle == nil
        tvAlertDescription.textAlignment = messageDescriptionAlignment ?? .left
    }
    
    private func setupColors() {
        lbAlertTitle.textColor = UIColor.primaryFontColor
        tvAlertDescription.textColor = UIColor.primaryFontColor
        
        configureButtonsColors()
    }
    
    private func configureButtonsColors() {
        if let leftButtonType = leftButtonType {
            switch leftButtonType {
            case .normal:
                btnAlertLeftButton.setTitleColor(UIColor.white, for: UIControl.State())
                btnAlertLeftButton.setGradientWith(colors: Constants.COLORS._GRADIENT_ENABLED_COLORS)
                
            case .destructive:
                btnAlertLeftButton.setTitleColor(UIColor.white, for: UIControl.State())
                btnAlertLeftButton.setGradientWith(colors: Constants.COLORS._GRADIENT_ERROR_COLORS)
                
            case .bordered:
                btnAlertLeftButton.setTitleColor(leftButtonBorderColor, for: UIControl.State())
                btnAlertLeftButton.borderColor = leftButtonBorderColor ?? UIColor.clear
                btnAlertLeftButton.backgroundColor = UIColor.clear
            }
            
        } else {
            btnAlertLeftButton.borderColor = UIColor.clear
            btnAlertLeftButton.backgroundColor = UIColor.clear
            btnAlertLeftButton.setTitleColor(UIColor.primaryFontColor, for: .normal)
        }
        
        if let rightButtonType = rightButtonType {
            switch rightButtonType {
            case .normal:
                btnAlertRightButton.setTitleColor(UIColor.white, for: UIControl.State())
                btnAlertRightButton.setGradientWith(colors: Constants.COLORS._GRADIENT_ENABLED_COLORS)
                
            case .destructive:
                btnAlertRightButton.setTitleColor(UIColor.white, for: UIControl.State())
                btnAlertRightButton.setGradientWith(colors: Constants.COLORS._GRADIENT_ERROR_COLORS)
                
            case .bordered:
                btnAlertRightButton.setTitleColor(rightButtonBorderColor, for: UIControl.State())
                btnAlertRightButton.borderColor = rightButtonBorderColor ?? UIColor.clear
                btnAlertRightButton.backgroundColor = UIColor.clear
            }
            
        } else {
            btnAlertRightButton.borderColor = UIColor.clear
            btnAlertRightButton.backgroundColor = UIColor.clear
            btnAlertRightButton.setTitleColor(UIColor.primaryFontColor, for: .normal)
        }
    }
    
    // MARK: - IBActions
    @IBAction func didPressLeftButton(_ sender: Button) {
        closeContainer {
            self.dismiss(animated: false, completion: {
                self.delegate?.didPressAlertButton(withResult: .left, forId: self.alertId!, sender: self.sender)
            })
        }
    }
    
    @IBAction func didPressRightButton(_ sender: Button) {
        closeContainer {
            self.dismiss(animated: false, completion: {
                self.delegate?.didPressAlertButton(withResult: .right, forId: self.alertId!, sender: self.sender)
            })
        }
    }
    
    @IBAction func didPressCloseButton(_ sender: Any) {
        if canCloseClickingOutside {
            closeContainer {
                self.dismiss(animated: false, completion: {
                    self.delegate?.didPressAlertButton(withResult: .close, forId: self.alertId!, sender: self.sender)
                })
            }
        }
    }
    
}
