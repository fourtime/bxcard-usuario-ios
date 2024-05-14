//
//  UsefullLinksResponse.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 12/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

// MARK: - UsefullLinksResponse
struct UsefullLinksResponse: Codable {
    
    // MARK: - Public API
    let status: Int
    let links: Links
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case status
        case links = "results"
    }
    
}


// MARK: - Links
struct Links: Codable {
    
    // MARK: - Public API
    let operatorWarnings: String
    let operatorContact: String
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case operatorWarnings = "avisosOperadora"
        case operatorContact = "contatoOperadora"
    }
    
}
