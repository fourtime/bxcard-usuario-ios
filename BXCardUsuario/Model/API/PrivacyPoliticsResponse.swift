//
//  PrivacyPoliticsResponse.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 12/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

struct PrivacyPoliticsResponse: Codable {
    
    // MARK: - Public Properties
    let status: Int
    let privacyPolitics: String
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case status
        case privacyPolitics = "results"
    }
    
}

