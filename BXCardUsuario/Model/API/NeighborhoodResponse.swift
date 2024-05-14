//
//  NeighborhoodResponse.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 21/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

// MARK: - NeighborhoodResponse
struct NeighborhoodResponse: Codable {
    
    // MARK: - Public API
    let status: Int
    let results: [String]
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case status
        case results
    }
    
}


// MARK: - Neighborhood
struct Neighborhood {
    
    // MARK: - Public Properties
    let description: String
    
}


// MARK: - PickerData
extension Neighborhood: PickerData {
    
    var pickerRowTitle: String {
        return description
    }
    
}


// MARK: - NeighborhoodResponse Extension
extension NeighborhoodResponse {
    
    var neighborhoods: [Neighborhood] {
        var temp = [Neighborhood]()
        for result in results {
            temp.append(Neighborhood(description: result))
        }
        return temp
    }
    
}

