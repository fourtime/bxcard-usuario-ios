//
//  ErrorResponse.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 04/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

// MARK: - ErrorResponse
struct ErrorResponse: Codable {
    
    // MARK: - Public API
    let status: Int
    let details: [String]
    let moreInfo: String
    
}


// MARK: - Extensions
extension ErrorResponse {
    
    var errorDescription: String {
        if !details.isEmpty {
            return details[0]
        }
        return ""
    }
    
}
