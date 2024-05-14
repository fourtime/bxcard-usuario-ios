//
//  CardBalanceResponse.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 22/05/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

// MARK: - CardBalanceResponse
struct CardBalanceResponse: Codable {
    
    // MARK: - Public API
    let status: Int
    let cardBalance: CardBalance
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case status
        case cardBalance = "results"
    }
}

// MARK: - CardBalance
struct CardBalance: Codable {
    
    // MARK: - Public API
    let balance: Double
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case balance = "saldo"
    }
    
}
