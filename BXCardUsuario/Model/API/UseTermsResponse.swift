//
//  UseTermsResponse.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 12/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

struct UseTermsResponse: Codable {
    
    // MARK: - Public API
    let status: Int
    let useTerms: String
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case status
        case useTerms = "results"
    }
    
}
