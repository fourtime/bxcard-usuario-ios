//
//  Activity.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 21/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

// MARK: - ActivityResponse
struct ActivityResponse: Codable {
    
    // MARK: - Public Properties
    let status: Int
    let results: [String]
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case status
        case results
    }
    
}


// MARK: - Activity
struct Activity: Codable {
    
    // MARK: - Public Properties
    let description: String
    
}


// MARK: - PickerData
extension Activity: PickerData {
    
    var pickerRowTitle: String {
        return description
    }
    
}


// MARK: - ActivityResponse Extension
extension ActivityResponse {
    
    var activities: [Activity] {
        var temp = [Activity]()
        for result in results {
            temp.append(Activity(description: result))
        }
        return temp
    }
    
}
