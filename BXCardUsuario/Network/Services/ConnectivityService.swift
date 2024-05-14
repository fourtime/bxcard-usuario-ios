//
//  ConnectivityService.swift
//  VittaCard
//
//  Created by Daive Simões on 20/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire

class ConnectivityService {
    
    // MARK: - Singleton
    static let instance = ConnectivityService()
    
    // MARK: - Public Properties
    var isConnected: Bool = false
    
    // MARK: - Private Properties
    private let reachbilityManager = NetworkReachabilityManager()
    
    // MARK: - Public Methods
    func startConnectionListener() {
        if !isConnected {
            reachbilityManager?.startListening(onUpdatePerforming: { status in
                if let isNetworkReachable = self.reachbilityManager?.isReachable, isNetworkReachable {
                    self.isConnected = true
                    NotificationCenter.default.post(name: NSNotification.Name(Constants.NOTIFICATIONS._REACHABLE_CONNECTION_NOTIFICATION), object: nil)
                    
                } else {
                    self.isConnected = false
                    NotificationCenter.default.post(name: NSNotification.Name(Constants.NOTIFICATIONS._UNREACHABLE_CONNECTION_NOTIFICATION), object: nil)
                }
            })
        }
    }
    
    func stopConnectionListener() {
        if isConnected {
            reachbilityManager?.stopListening()
        }
    }
    
}
