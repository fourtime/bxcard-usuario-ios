//
//  StateResponse.swift
//  PersonalCardUsuario
//
//  Created by Daive Simões on 21/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

struct StateResponse: Codable {
    
    // MARK: - Public Properties
    let status: Int
    let results: [String]

    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case status
        case results
    }
    
}

struct State: Codable {

    // MARK: - Public Properties
    let description: String
    
}


// MARK: - PickerData
extension State: PickerData {
    
    var pickerRowTitle: String {
        return description
    }
    
}


// MARK: - StateResponse Extension
extension StateResponse {
    
    var states: [State] {
        var temp = [State]()
        for result in results {
            temp.append(State(description: result))
        }
        return temp
    }
    
}
