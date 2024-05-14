//
//  CardsResponse.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 11/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

// MARK: - CardsResponse
struct CardsResponse: Codable {
    
    // MARK: - Public Properties
    let status: Int
    let cards: [Card]
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case status
        case cards = "results"
    }
    
}


// MARK: - Card
struct Card: Codable {
    
    // MARK: - Public Properties
    let id: String
    let ownerName: String
    let label: String
    var balance: Double
    let type: Int
    let last4Digits: String
    let renewDate: String?
    let limitValue: Double
    let scheduleRechargeDate: String?
    let scheduleRechargeValue: Double
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case id = "idCartao"
        case ownerName = "nomeTitular"
        case label = "rotulo"
        case balance = "saldo"
        case type = "tipoCartao"
        case last4Digits = "ultimosDigitosCartao"
        case renewDate = "dataRenovacao"
        case limitValue = "valorLimite"
        case scheduleRechargeDate = "dataProgramadaCarga"
        case scheduleRechargeValue = "valorProgramadoCarga"
    }
    
}

extension Card : Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Extensions
extension Card {
    
    enum CardType: Int {
        
        case posPago = 0
        case prePago = 1
        case frota = 2
        
        var color: UIColor {
            switch self {
            case .posPago:
                return UIColor(red: 23.0 / 255.0, green: 71.0 / 255.0, blue: 94.0 / 255.0, alpha: 1.0)
                
            case .prePago:
                return UIColor(red: 122.0/255.0, green: 95.0/255.0, blue: 32.0/255.0, alpha: 1.0)
            
            case .frota:
                return UIColor(red: 87.0/255.0, green: 128.0/255.0, blue: 158.0/255.0, alpha: 1.0)
            }
        }
        
        var description: String {
            switch self {
            case .posPago:
                return "Pós-Pago"
                
            case .prePago:
                return "Pré-Pago"
                
            case .frota:
                return "Frota"
            }
        }
        
    }
    
    var cardColor: UIColor {
        return CardType(rawValue: type)?.color ?? UIColor.clear
    }
    
    var cardType: String {
        return CardType(rawValue: type)?.description ?? ""
    }
    
    var formattedBalance: String {
        return Utils.formatCurrency(value: balance)
    }
    
    var formattedLast4Digits: String {
        return "**** \(last4Digits)"
    }
    
    var formattedRechargeDate: String {
        if let scheduleRechargeDate = scheduleRechargeDate {
            return Utils.formatDate(string: scheduleRechargeDate, andOutFormat: Constants.MASKS._BR_DATE)
        }
        return "-"
    }
    
    var formattedRechargeValue: String {
        return Utils.formatCurrency(value: scheduleRechargeValue, "R$ ")
    }
    
    var formattedRenewDate: String {
        if let renewDate = renewDate {
            return Utils.formatDate(string: renewDate, andOutFormat: Constants.MASKS._BR_DATE)
        }
        return "-"
    }
    
    var formattedLimitValue: String {
        return Utils.formatCurrency(value: limitValue, "R$ ")
    }
    
    var nextDateLabel: String {
        if let cardType = CardType(rawValue: type) {
            switch cardType {
            case .posPago:
                return "próxima renovação"
                
            case .prePago:
                return "próxima carga"
                
            case .frota:
                return ""
            }
        } else {
            return ""
        }
    }
    
    var nextDate: String {
        if let cardType = CardType(rawValue: type) {
            switch cardType {
            case .posPago:
                return formattedRenewDate
                
            case .prePago:
                return formattedRechargeDate
                
            case .frota:
                return "-"
            }
        } else {
            return "-"
        }
    }
    
    var nextValueLabel: String {
        if let cardType = CardType(rawValue: type) {
            switch cardType {
            case .posPago:
                return "valor limite"
                
            case .prePago:
                return "valor próxima carga"
                
            case .frota:
                return ""
            }
        } else {
            return ""
        }
    }
    
    var nextValue: String {
        if let cardType = CardType(rawValue: type) {
            switch cardType {
            case .posPago:
                return formattedLimitValue
                
            case .prePago:
                return formattedRechargeValue
                
            case .frota:
                return "-"
            }
        } else {
            return "-"
        }
    }
    
}
