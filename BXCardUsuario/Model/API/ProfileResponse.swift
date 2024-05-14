//
//  ProfileResponse.swift
//  BXCardUsuario
//
//  Created by Daive Simões on 11/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

// MARK: - ProfileResponse
struct ProfileResponse: Codable {
    
    // MARK: - Public Properties
    let status: Int
    let profile: Profile
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case status
        case profile = "results"
    }
    
}


// MARK: - Profile
struct Profile: Codable {
    
    // MARK: - Public Properties
    var neighborhood: String
    var postalCode: String
    var city: String
    var complement: String
    var birthday: String
    var email: String
    var address: String
    var name: String?
    var number: String
    var phone: String
    var state: String?
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case neighborhood = "bairro"
        case postalCode = "cep"
        case city = "cidade"
        case complement = "complemento"
        case birthday = "dataNascimento"
        case email = "email"
        case address = "endereco"
        case name = "nome"
        case number = "numero"
        case phone = "telefone"
        case state = "uf"
    }
    
    init() {
        neighborhood = ""
        postalCode = ""
        city = ""
        complement = ""
        birthday = ""
        email = ""
        address = ""
        name = ""
        number = ""
        phone = ""
        state = ""
    }
    
    init(name: String, email: String, phone: String, birthday: String) {
        self.init()
        self.name = name
        self.email = email
        self.phone = phone
        self.birthday = birthday
    }
    
}


// MARK: - Extensions
extension Profile {
    
    var formattedBirthDay: String {
        if let birthday = birthday.toDate() {
            return Utils.formatDate(date: birthday, withOutFormat: "dd/MM/yyyy")
        }
        return ""
    }
    
    
    var initials: String {
        let initials = name != nil ? name!.components(separatedBy: " ").reduce("") { $0 + String($1[$1.startIndex]) } : ""
        return String(initials.prefix(2))
    }
    
    var json: [String : Any] {
        return [CodingKeys.neighborhood.rawValue : neighborhood,
                CodingKeys.postalCode.rawValue : postalCode,
                CodingKeys.city.rawValue : city,
                CodingKeys.complement.rawValue : complement,
                CodingKeys.birthday.rawValue : birthday,
                CodingKeys.email.rawValue : email,
                CodingKeys.address.rawValue : address,
                CodingKeys.name.rawValue : name ?? "",
                CodingKeys.number.rawValue : number,
                CodingKeys.phone.rawValue : phone,
                CodingKeys.state.rawValue : state ?? ""]
    }
    
}
