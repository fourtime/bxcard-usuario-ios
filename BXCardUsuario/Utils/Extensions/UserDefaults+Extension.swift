//
//  UserDefaults+Extension.swift
//  BXCardUsuario
//
//  Created by Rafael Rocha Gans on 05/06/22.
//  Copyright © 2022 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

extension UserDefaults {
    func set<T: Codable>(data: T, forKey: String) {
        let encoder = JSONEncoder()
        do {
            let encoded = try! encoder.encode(data)
            self.set(encoded, forKey: forKey)
        }
    }
    
    func codable<T: Decodable>(forKey: String) -> T? {
        if let resultData = self.object(forKey: forKey) as? Data {
            let decoder = JSONDecoder()
            if let result = try? decoder.decode(T.self, from: resultData) {
                return result
            }
        }
        
        return nil
    }
}
