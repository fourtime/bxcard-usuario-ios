//
//  RouteService.swift
//  VittaCardUsuario
//
//  Created by Daive Simões on 18/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: - RouteEngine Enum
enum RouteEngine {
    case googleMaps
    case appleMaps
    case waze
}


class RouteService: BaseService {
    
    // MARK: - Singleton
    static let instance = RouteService()
    
    private func drawRouteBetween(sourceCoordinate source: CLLocationCoordinate2D?, andDestinationAddress destination: String?, withEngine engine: RouteEngine, withCompletion completion: ((Bool) -> ())?) {
        if let source = source, let destination = destination?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            switch engine {
            case .googleMaps:
                UIApplication.shared.open(NSURL(string:
                    "comgooglemaps://?saddr=\(source.latitude),\(source.longitude)&daddr=\(destination)&directionsmode=driving")! as URL, options: [:], completionHandler: completion)
                
            case .waze:
                UIApplication.shared.open(NSURL(string: "waze://?q=\(destination)&navigate=yes")! as URL, options: [:], completionHandler: completion)
                
            case .appleMaps:
                UIApplication.shared.open(NSURL(string:
                    "maps://?saddr=\(source.latitude),\(source.longitude)&daddr=\(destination)")! as URL, options: [:], completionHandler: completion)
            }
        }
    }
    
    // MARK: - Public API
    func drawRoute(forController controller: UIViewController, sourceCoordinate source: CLLocationCoordinate2D?, andDestinationAddress destination: String?, withCompletion completion: ((Bool) -> ())?) {
        let alert = UIAlertController(title: "Rota", message: "Qual ferramenta deseja utilizar?", preferredStyle: .actionSheet)
        
        if UIApplication.shared.canOpenURL(NSURL(string: "comgooglemaps://")! as URL) {
            let mapAction = UIAlertAction(title: "Google Maps", style: .default) { (alertAction) in
                self.drawRouteBetween(sourceCoordinate: source, andDestinationAddress: destination, withEngine: .googleMaps, withCompletion: completion)
            }
            alert.addAction(mapAction)
        }
        
        if UIApplication.shared.canOpenURL(NSURL(string: "waze://")! as URL) {
            let mapAction = UIAlertAction(title: "Waze", style: .default) { (alertAction) in
                self.drawRouteBetween(sourceCoordinate: source, andDestinationAddress: destination, withEngine: .waze, withCompletion: completion)
            }
            alert.addAction(mapAction)
        }
        
        if UIApplication.shared.canOpenURL(NSURL(string:"maps://")! as URL) {
            let mapAction = UIAlertAction(title: "Apple Maps", style: .default) { (alertAction) in
                self.drawRouteBetween(sourceCoordinate: source, andDestinationAddress: destination, withEngine: .appleMaps, withCompletion: completion)
            }
            alert.addAction(mapAction)
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        controller.present(alert, animated: true, completion: nil)
    }
    
}
