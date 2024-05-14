//
//  InitializeUserResponse.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 02/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

// MARK: - InitializeUserResponse
struct InitializeUserResponse: Codable {
    
    // MARK: - Public API
    let status: Int
    let userInfo: UserInfo
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case status
        case userInfo = "results"
    }
    
}


// MARK: - UserInfo
struct UserInfo: Codable {
    
    // MARK: - Public API
    let name: String?
    let isFirstAccess: Bool
    let hasEmail: Bool
    let hasPhoto: Bool
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case name = "nomeUsuario"
        case isFirstAccess = "primeiroAcesso"
        case hasEmail = "temEmail"
        case hasPhoto = "temFoto"
    }
    
}
