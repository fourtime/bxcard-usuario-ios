//
//  GMSMapView.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 18/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import GoogleMaps

extension GMSMapView {
    
    func mapStyle(withFilename name: String, andType type: String) {
        do {
            if let styleURL = Bundle.main.url(forResource: name, withExtension: type) {
                self.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            }
        } catch {
            print("Failed to load map style: \(error.localizedDescription)")
        }
    }
    
}

