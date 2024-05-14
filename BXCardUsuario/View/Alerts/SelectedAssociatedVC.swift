//
//  SelectedAssociatedVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 18/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

// MARK: - SelectedAssociatedDelegate Protocol
protocol SelectedAssociatedDelegate: AnyObject {
    func didCall(associated: Associated)
    func didRouteTo(associated: Associated)
    func didClose(isJustClosing: Bool)
}


class SelectedAssociatedVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var container: ShadowedView!
    @IBOutlet weak var lbAssociatedName: UILabel!
    @IBOutlet weak var lbAssociatedAddress: UILabel!
    @IBOutlet weak var btnCall: Button!
    @IBOutlet weak var btnRoute: Button!
    @IBOutlet weak var vwSeparator: UIView!
    
    // MARK: - Public API
    var associated: Associated?
    weak var delegate: SelectedAssociatedDelegate?
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container.isHidden = true

        setupColors()
        loadAssociated()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        openContainer()
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        vwBackground.backgroundColor = UIColor.clear
        container.backgroundColor = UIColor.slideUpAlertBackground
        
        lbAssociatedName.textColor = UIColor.primaryFontColor
        lbAssociatedAddress.textColor = UIColor.primaryLightFontColor
        
        vwSeparator.backgroundColor = UIColor.separatorColor
        
        btnCall.setGradientWith(colors: Constants.COLORS._GRADIENT_ENABLED_COLORS)
        btnRoute.setGradientWith(colors: Constants.COLORS._GRADIENT_ENABLED_COLORS)
    }
    
    private func loadAssociated() {
        if let associated = associated {
            lbAssociatedName.text = associated.name
            lbAssociatedAddress.text = associated.address
        }
    }
    
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
    
    // MARK: - IBActions
    @IBAction func didTapBackground(_ sender: Any) {
        closeContainer {
            self.dismiss(animated: false) {
                self.delegate?.didClose(isJustClosing: true)
            }
        }
    }
    
    @IBAction func didTapCallButton(_ sender: UIButton) {
        closeContainer {
            self.dismiss(animated: false) {
                self.delegate?.didCall(associated: self.associated!)
                self.delegate?.didClose(isJustClosing: false)
            }
        }
    }
    
    @IBAction func didTapRouteButton(_ sender: UIButton) {
        closeContainer {
            self.dismiss(animated: false) {
                self.delegate?.didRouteTo(associated: self.associated!)
                self.delegate?.didClose(isJustClosing: false)
            }
        }
    }
    
}
