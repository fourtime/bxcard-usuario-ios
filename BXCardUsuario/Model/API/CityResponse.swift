//
//  CityResponse.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 21/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

// MARK: - CityResponse
struct CityResponse: Codable {

    // MARK: - Public API
    let status: Int
    let results: [String]
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case status
        case results
    }
}


// MARK: - City
struct City: Codable {
    
    // MARK: - Public Properties
    let description: String
    
}


// MARK: - PickerData
extension City: PickerData {
    
    var pickerRowTitle: String {
        return description
    }
    
}


// MARK: - CityResponse Extension
extension CityResponse {
    
    var cities: [City] {
        var temp = [City]()
        for result in results {
            temp.append(City(description: result))
        }
        return temp
    }
    
}

