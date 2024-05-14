//
//  Associated.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 18/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

// MARK: - AssociatedDetailResponse
struct AssociatedDetailResponse: Codable {
    
    // MARK: - Public Properties
    let status: Int
    let associated: Associated
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case status
        case associated = "results"
    }
    
}


// MARK: - AssociatedResponse
struct AssociatedResponse: Codable {

    // MARK: - Public Properties
    let status: Int
    let results: AssociatedResults
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case status
        case results
    }
    
}


// MARK: - AssociatedResults
struct AssociatedResults: Codable {
    
    // MARK: - Public Properties
    let page: Int
    let pageSize: Int
    let totalRecords: Int
    let data: [Associated]
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case page = "numeroPagina"
        case pageSize = "tamanhoPagina"
        case totalRecords = "totalRegistros"
        case data = "dados"
    }
    
}


// MARK: - Associated
struct Associated: Codable {
    
    // MARK: - Public Properties
    let id: String
    let name: String
    let address: String
    let complement: String?
    let city: String
    let neighborhood: String
    let state: String
    let latitude: String
    let longitude: String
    let phone: String?
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case id = "codigo"
        case name = "nomeFantasia"
        case address = "endereco"
        case complement = "complemento"
        case city = "cidade"
        case neighborhood = "bairro"
        case state = "uf"
        case latitude
        case longitude
        case phone = "telefone"
    }
    
}


// MARK: - Extensions
extension Associated {
    
    var distance: Int {
        return 0
    }
    
    var fullAddress: String {
        var address = self.address
        address += complement != nil ? " \(complement!) " : " "
        address += "\(city) (\(state))"
        
        return address
    }
    
    var numericLatitude: Double? {
        return Double(latitude)
    }
    
    var numericLongitude: Double? {
        return Double(longitude)
    }
    
}
