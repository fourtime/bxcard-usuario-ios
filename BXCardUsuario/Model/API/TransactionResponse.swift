//
//  TransactionResponse.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 14/05/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

// MARK: - TransactionType Enum
enum TransactionType: Int {
    
    case debit = 0
    case credit = 1
    
    var typeSymbol: String {
        switch self {
        case .debit:
            return "-"
        default:
            return "+"
        }
    }
    
    var typeColor: UIColor {
        switch self {
        case .debit:
            return UIColor.primaryDarkFontColor
        default:
            return UIColor.highlightFontColor
        }
    }
}


// MARK: - TransactionResponse
struct TransactionResponse: Codable {
    
    // MARK: - Public API
    let status: Int
    let results: TransactionResults
    
}


// MARK: - TransactionResults
struct TransactionResults: Codable {
    
    // MARK: - Public API
    let numeroPagina: Int
    let tamanhoPagina: Int
    let totalRegistros: Int
    let dataProgramadaCarga: String?
    let valorProgramadoCarga: Double
    let dataRenovacao: String?
    let valorLimite: Double
    let dados: [Transaction]
    
}


// MARK: - Transaction
struct Transaction: Codable {
    
    // MARK: - Public API
    let place: String?
    let dateTime: String
    let cardId: String
    let last4Digits: String?
    let value: Double
    let parcels: Int
    let cardType: Int
    let nsuAuth: String?
    let nsuHost: String?
    let type: TransactionType = .debit
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case place = "estabelecimento"
        case dateTime = "dataHoraTransacao"
        case cardId = "idCartao"
        case last4Digits = "ultimosDigitosCartao"
        case value = "valor"
        case parcels = "numeroParcelas"
        case cardType = "tipoCartao"
        case nsuAuth = "nsuAutorizacao"
        case nsuHost
    }
    
}


// MARK: - Extensions Transaction
extension Transaction {
    
    var day: String {
        if let date = dateTime.toDate(withInFormat: Constants.MASKS._DEFAULT_DATE_TIME) {
            let day = "\(Calendar.current.component(Calendar.Component.day, from: date))".paddingToLeft(upTo: 2, using: "0")
            return "\(day) \(date.monthAsString())"
        }
        return ""
    }
    
    var formattedValue: String {
        return Utils.formatCurrency(value: value, "R$ ")
    }
    
}


// MARK: - Extensions TransactionResults
extension TransactionResults {
    
    var pages: Int {
        return totalRegistros / tamanhoPagina + (totalRegistros % tamanhoPagina > 0 ? 1 : 0)
    }
    
}
