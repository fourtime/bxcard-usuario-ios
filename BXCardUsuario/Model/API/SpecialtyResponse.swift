//
//  SpecialtyResponse.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 16/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

// MARK: - SpecialtyResponse
struct SpecialtyResponse: Codable {
    
    // MARK: - Public Properties
    let status: Int
    let results: [String]
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case status
        case results
    }
    
}


// MARK: - Specialty
struct Specialty: Codable {
    
    // MARK: - Public Properties
    let name: String
    
}


// MARK: - PickerData
extension Specialty: PickerData {
    
    var pickerRowTitle: String {
        return name
    }
    
}


// MARK: - SpecialtyResponse Extension
extension SpecialtyResponse {
    
    var specialties: [Specialty] {
        var temp = [Specialty]()
        for result in results {
            temp.append(Specialty(name: result))
        }
        return temp
    }
    
}

