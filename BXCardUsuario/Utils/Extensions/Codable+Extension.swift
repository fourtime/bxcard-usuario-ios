//
//  Codable+Extension.swift
//  BXCardUsuario
//
//  Created by Rafael Rocha Gans on 05/06/22.
//  Copyright © 2022 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

extension Encodable {
    func encode(with encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
    
    func encode(with encoder: JSONEncoder = JSONEncoder()) -> Data? {
        return try? encoder.encode(self)
    }
}

extension Decodable {
    static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }

    static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data) -> Self? {
        return try? decoder.decode(Self.self, from: data)
    }
    
    static func decode(with decoder: JSONDecoder = JSONDecoder(), from string: String) -> Self? {
        let data = Data(string.utf8)
        return try? decoder.decode(Self.self, from: data)
    }
}
