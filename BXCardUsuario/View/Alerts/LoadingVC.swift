//
//  LoadingController.swift
//  Vagow
//
//  Created by Daive Simões on 11/01/19.
//  Copyright © 2018 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class LoadingVC: UIViewController {

    static let instance: LoadingVC = UIStoryboard(name: "Alerts", bundle: nil).instantiateViewController(withIdentifier: "LoadingVC") as! LoadingVC
    
    // MARK: - IBOutlets
    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var imImage: UIImageView!

    // MARK: - Public Properties
    var showing: Bool = false
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.alpha = 0.0
        
        setupColors()
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        vwBackground.backgroundColor = UIColor.alertTransparentBackground
    }
    
    // MARK: - Public Methods
    func show() {
        if !showing {
            showing = true
            
            if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
                window.bringSubviewToFront(view)
            }
            
            DispatchQueue.main.async {
                self.imImage.rotate()
            }
        
            view.alpha = 0.0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.alpha = 1.0
            })
        }
    }
    
    func hide(){
        showing = false
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0.0
        })
    }

}
