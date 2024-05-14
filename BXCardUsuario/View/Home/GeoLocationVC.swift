//
//  GeoLocationVC.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 29/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import CoreLocation

class GeoLocationVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var btnActivate: Button!
    
    // MARK: - Private Properties
    private var locationManager = CLLocationManager()
    
    // MARK: - Inheritance
    override func viewDidLoad() {
        super.viewDidLoad()

        configureScreen()
    }
    
    override func configureScreen() {
        setupColors()
        
        locationManager.delegate = self
    }
    
    // MARK: - Private Methods
    private func setupColors() {
        lbTitle.textColor = UIColor.primaryFontColor
        lbDescription.textColor = UIColor.secondaryFontColor
        
        btnActivate.enable()
    }
    
    // MARK: - IBActions
    @IBAction func didTapActivateGeoLocationButton(_ sender: Button) {
        locationManager.requestWhenInUseAuthorization()
    }
    
}


// MARK: - CLLocationManagerDelegate
extension GeoLocationVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            performSegue(withIdentifier: "associatedNetworkVCSegue", sender: nil)
            
        } else if status == .denied {
            performSegue(withIdentifier: "noGeoLocationVCSegue", sender: nil)
        }
    }
    
}
