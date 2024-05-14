//
//  PaymentResponse.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 15/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

// MARK: - PaymentIDResponse
struct PaymentIDResponse: Codable {
    
    // MARK: - Public Properties
    let status: Int
    let paymentID: PaymentID
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case status
        case paymentID = "results"
    }
    
}


// MARK: - PaymentID
struct PaymentID: Codable {
    
    // MARK: - Public Properties
    let condition: String
    let transactionTime: String
    let address: String
    let associated: String
    let value: Double
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case condition = "condicao"
        case transactionTime = "dataHoraTransacao"
        case address = "endereco"
        case associated = "estabelecimento"
        case value = "valor"
    }
    
}


// MARK: - Extensions
extension PaymentID {
    
    var formattedValue: String {
        return Utils.formatCurrency(value: value, "R$ ")
    }
    
}
