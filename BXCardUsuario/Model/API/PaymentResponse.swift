//
//  PaymentResponse.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 16/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

// MARK: - PaymentResponse
struct PaymentResponse: Codable {
    
    // MARK: - Public API
    let status: Int
    let payment: Payment
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case status
        case payment = "results"
    }
    
}


// MARK: - Payment
struct Payment: Codable {
    
    // MARK: - Public API
    let authDateTime: String
    let ownerName: String
    let nsuAuth: String
    let nsuHost: String
    let newBalance: Double
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case authDateTime = "dataHoraAutorizacao"
        case ownerName = "nomePortador"
        case nsuAuth = "nsuAutorizacao"
        case nsuHost
        case newBalance = "saldoAposTransacao"
    }
    
}


// MARK: - Extensions
extension Payment {
    
    var formattedAuthDateTime: String {
        if let authDateTime = authDateTime.toDate(withInFormat: Constants.MASKS._DEFAULT_DATE_TIME) {
            return Utils.formatDate(date: authDateTime, withOutFormat: Constants.MASKS._BR_DATE_TIME_NO_SECONDS)
        }
        return ""
    }
    
    var formattedNewBalance: String {
        return Utils.formatCurrency(value: newBalance, "R$ ")
    }
    
}
