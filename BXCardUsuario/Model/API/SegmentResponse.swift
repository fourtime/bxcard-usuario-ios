//
//  SegmentResponse.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 15/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

// MARK: - SegmentType Enum
enum SegmentType: Int {
    case normal = 0
    case health = 2
}


//MARK: - SegmentResponse
struct SegmentResponse: Codable {
    
    // MARK: - Public Properties
    let status: Int
    let segments: [Segment]
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case status
        case segments = "results"
    }
    
}


// MARK: - Segment
struct Segment: Codable {
    
    // MARK: - Public Properties
    let name: String
    let type: Int
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case name = "nome"
        case type = "tipo"
    }
    
}


// MARK: - PickerData
extension Segment: PickerData {
    
    var pickerRowTitle: String {
        return name
    }
    
}
