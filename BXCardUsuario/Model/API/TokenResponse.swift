//
//  TokenResponse.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 01/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

struct TokenResponse: Codable {
    
    // MARK: - Public Properties
    let scope: String
    let tokenType: String
    let accessToken: String
    let expiresIn: Int
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case scope
        case tokenType = "token_type"
        case accessToken = "access_token"
        case expiresIn = "expires_in"
    }
    
}
