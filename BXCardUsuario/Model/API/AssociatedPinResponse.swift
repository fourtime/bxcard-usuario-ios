//
//  AssociatedPinResponse.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 21/05/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

// MARK: - AssociatedPinResponse
struct AssociatedPinResponse: Codable {
    
    // MARK: - Public API
    let status: Int
    let associatedPositions: [AssociatedPosition]
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case status
        case associatedPositions = "results"
    }
    
}


// MARK: - Result
struct AssociatedPosition: Codable {
    
    // MARK: - Public API
    let code: String
    let latitude: String
    let longitude: String
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case code = "codigo"
        case latitude
        case longitude
    }
    
}
