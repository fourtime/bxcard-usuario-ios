//
//  BXCardApp.swift
//  BXCard
//
//  Created by Daive Simões on 20/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

struct TokenData: Codable {
    var scope: String
    var tokenType: String
    var accessToken: String
    var expiresIn: Date?
    var isExpired: Bool {
        return Date() > (expiresIn ?? Date())
    }
}

extension TokenResponse {
    func transform() -> TokenData { return TokenData(scope: scope, tokenType: tokenType, accessToken: accessToken, expiresIn: Calendar.current.date(byAdding: .second, value: expiresIn, to: Date())) }
}

struct UserData: Codable {
    var name: String?
    
    var firstName: String? {
        guard let a = name?.split(separator: " "), let b = a.first else { return nil }
        return String(b)
    }
    
    var email: String?

    var cardTail: String?
    
    var login: String?
    var password: String?

    var profile: Profile?
    
    var hasEmail: Bool = false
    var isFirstAccess: Bool = false
    var isAuthenticated: Bool {
        guard let token = self.token, !token.isExpired else { return false }
        return true
    }
    var hasCredentials: Bool {
        return login != nil && password != nil && cardTail != nil
    }
    
    var selectedCard: Card?
    
    var token: TokenData?
}
extension UserInfo {
    func transform() -> UserData { return UserData(name: name, hasEmail: hasEmail, isFirstAccess: isFirstAccess) }
}

class AppContext {
    
    // MARK: - Singleton
    static let shared = AppContext()

    // MARK: - Public Properties
    private let DB = UserDefaults.standard
    var fcmToken: String = ""
    var firebaseToken: String = ""

    var autoSynchronize = true
    
    private let kcDeviceIDKey = "_kcDeviceIDKey_"
    private let kcAppTokenKey = "_kcAppTokenKey_"
    private let kcUserDataKey = "_kcUserDataKey_"
    private let kcUserPhotoKey = "_kcUserPhotoKey_"
    
    var userPhoto: UIImage? {
        get {
            guard let data = DB.data(forKey: kcUserPhotoKey), let photo = UIImage(data: data) else {
                return nil
            }
            return photo
        }
        set {
            DB.set(newValue?.jpegData(compressionQuality:0.3), forKey: kcUserPhotoKey)
        }
    }
    
    var appToken: TokenData? {
        get { return DB.codable(forKey: kcAppTokenKey) }
        set { DB.set(data: newValue, forKey: kcAppTokenKey) }
    }
    var user: UserData {
        get {
            return DB.codable(forKey: kcUserDataKey) ?? UserData()
        }
        set {
            DB.set(data: newValue, forKey: kcUserDataKey)
        }
    }

    var deviceID: String {
        if !Constants.isProductionEnvironment() {
            return "9F25F778-3F27-490D-855B-F48663DA2FD6"
        } else {
            guard let id = DB.string(forKey: kcDeviceIDKey) else {
                let id = NSUUID().uuidString
                DB.set(id, forKey: kcDeviceIDKey)
                return id
            }
            return id
        }
    }
    
    func logout() {
        self.user.token = nil
    }
}
