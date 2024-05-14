//
//  UserService.swift
//  VittaCardUsuario
//
//  Created by Daive Simões on 02/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire

class UserService: BaseService {
    
    // MARK: - Singleton
    static let shared = UserService()
    
    func startUserTerminal(_ completion: @escaping (Error?) -> ()) {
        let cpf = AppContext.shared.user.login ?? ""
        let last4Digits = AppContext.shared.user.cardTail ?? ""

        startUserTerminal(forCPF: cpf, andLast4Digits: last4Digits, completion)
    }
    
    func startUserTerminal(forCPF cpf: String, andLast4Digits last4Digits: String, _ completion: @escaping (Error?) -> ()) {
        let params: Parameters = [
            "codigoOperadora" : Constants.AUTH._OPERATOR_CODE,
            "cpf" : cpf.onlyNumbers(),
            "ultimosDigitosCartao" : last4Digits,
            "imei" : AppContext.shared.deviceID
        ]

        request(Constants.URLS._USER_INITIALIZE_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: appAuthHeader()).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        do {
                            let initResponse = try JSONDecoder().decode(InitializeUserResponse.self, from: response.data!)
                            
                            AppContext.shared.user.login = cpf
                            AppContext.shared.user.name = initResponse.userInfo.name
                            AppContext.shared.user.hasEmail = initResponse.userInfo.hasEmail
                            AppContext.shared.user.isFirstAccess = initResponse.userInfo.isFirstAccess
                            AppContext.shared.user.cardTail = last4Digits
                            
                            completion(nil)
                            
                        } catch {
                            completion(error)
                        }
                        
                    case 400..<500:
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                            completion(NSError(domain: errorResponse.errorDescription, code: httpResponseCode, userInfo: Constants.ERRORS._CATCHED_ERROR))
                            
                        } catch {
                            completion(error)
                        }
                        
                    default:
                        completion(NSError(domain: Constants.MESSAGES._NETWORK_UNCATCHED_ERROR, code: httpResponseCode, userInfo: nil))
                    }
                    
                } else {
                    completion(NSError(domain: Constants.MESSAGES._NO_HTTP_RESPONSE_ERROR, code: -1, userInfo: nil))
                }
                
            case .failure(let error):
                completion(error)
            }
        }
    }

    func authenticate(login: String, password: String, _ completion: ((Error?) -> ())?) {
        requestUserToken(login: login, password: password) { (error) in
            if let error = error {
                completion?(error)
            } else {
                UserService.shared.getUserProfile(withCompletion: { (profile, error) in
                    if let error = error {
                        completion?(error)
                    } else if let profile = profile {
                        AppContext.shared.user.profile = profile
                        completion?(nil)
                    }
                })
            }
        }
    }
    
    
    func requestUserToken(login: String, password: String, _ completion: @escaping (Error?) -> ()) {
        let params: Parameters = [
            "applicationKey" : Constants.AUTH._USER_TOKEN,
            "username" : "\(Constants.AUTH._PADDED_OPERATOR_CODE)-\(AppContext.shared.deviceID)@\(login.onlyNumbers())",
            "password" : password
        ]
        request(Constants.URLS._TOKEN_REQUEST_URL, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil)
            .responseJSON { (response) in
                switch response.result {
                case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        do {
                            let response = try JSONDecoder().decode(TokenResponse.self, from: response.data!)
                            
                            AppContext.shared.user.login = login
                            AppContext.shared.user.password = password
                            AppContext.shared.user.token = response.transform()

                            completion(nil)
                            
                        } catch {
                            completion(error)
                        }
                        
                    case 400..<500:
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                            completion(NSError(domain: errorResponse.errorDescription, code: httpResponseCode, userInfo: Constants.ERRORS._CATCHED_ERROR))
                            
                        } catch {
                            completion(NSError(domain: "error.message.invalid_password".localized, code: httpResponseCode, userInfo: Constants.ERRORS._CATCHED_ERROR))
                        }
                        
                    default:
                        completion(NSError(domain: Constants.MESSAGES._NETWORK_UNCATCHED_ERROR, code: httpResponseCode, userInfo: nil))
                    }
                    
                } else {
                    completion(NSError(domain: Constants.MESSAGES._NO_HTTP_RESPONSE_ERROR, code: -1, userInfo: nil))
                }
                
                case .failure(let error):
                completion(error)
            }
        }
    }
    
    func saveToken(forFirebase token: String, withCompletion completion: ((Error?) -> ())?) {
        let params: Parameters = [
            "imei" : AppContext.shared.deviceID,
            "IdInstancia" : token,
            "versao" : 1,
            "plataforma" : "ios"
        ]
        request(Constants.URLS._FIREBASE_TOKEN_SAVE_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: userAuthHeader()).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        completion?(nil)
                        
                    case 400..<500:
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                            completion?(NSError(domain: errorResponse.errorDescription, code: httpResponseCode, userInfo: Constants.ERRORS._CATCHED_ERROR))
                            
                        } catch {
                            completion?(error)
                        }
                        
                    default:
                        completion?(NSError(domain: Constants.MESSAGES._NETWORK_UNCATCHED_ERROR, code: httpResponseCode, userInfo: nil))
                    }
                    
                } else {
                    completion?(NSError(domain: Constants.MESSAGES._NO_HTTP_RESPONSE_ERROR, code: -1, userInfo: nil))
                }
                
            case .failure(let error):
                completion?(error)
            }
        }
    }
    
    // MARK: - Public Methods
    func editUserProfile(_ profile: Profile, withCompletion completion: @escaping (Error?) -> ()) {
        let params: Parameters = [
            "dataNascimento" : profile.birthday,
            "email" : profile.email,
            "telefone" : profile.phone
        ]
        request(Constants.URLS._CHANGE_USER_PROFILE_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: userAuthHeader()).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        completion(nil)
                        
                    case 400..<500:
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                            completion(NSError(domain: errorResponse.errorDescription, code: httpResponseCode, userInfo: Constants.ERRORS._CATCHED_ERROR))
                            
                        } catch {
                            completion(error)
                        }
                        
                    default:
                        completion(NSError(domain: Constants.MESSAGES._NETWORK_UNCATCHED_ERROR, code: httpResponseCode, userInfo: nil))
                    }
                    
                } else {
                    completion(NSError(domain: Constants.MESSAGES._NO_HTTP_RESPONSE_ERROR, code: -1, userInfo: nil))
                }
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    // MARK: - Public Methods
    func updateEmail(_ email: String, withCompletion completion: @escaping (Error?) -> ()) {
        let params: Parameters = [
            "email" : email
        ]
        request(Constants.URLS._CHANGE_USER_PROFILE_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: userAuthHeader()).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        completion(nil)
                        
                    case 400..<500:
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                            completion(NSError(domain: errorResponse.errorDescription, code: httpResponseCode, userInfo: Constants.ERRORS._CATCHED_ERROR))
                            
                        } catch {
                            completion(error)
                        }
                        
                    default:
                        completion(NSError(domain: Constants.MESSAGES._NETWORK_UNCATCHED_ERROR, code: httpResponseCode, userInfo: nil))
                    }
                    
                } else {
                    completion(NSError(domain: Constants.MESSAGES._NO_HTTP_RESPONSE_ERROR, code: -1, userInfo: nil))
                }
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func changeUserPassword(from oldPassword: String, to newPassword: String, withCompletion completion: @escaping (Error?) -> ()) {
        let params: Parameters = [
            "senhaAtual" : oldPassword,
            "novaSenha" : newPassword
        ]
        request(Constants.URLS._CHANGE_USER_PASSWORD_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: userAuthHeader()).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        completion(nil)
                        
                    case 400..<500:
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                            completion(NSError(domain: errorResponse.errorDescription, code: httpResponseCode, userInfo: Constants.ERRORS._CATCHED_ERROR))
                            
                        } catch {
                            completion(error)
                        }
                        
                    default:
                        completion(NSError(domain: Constants.MESSAGES._NETWORK_UNCATCHED_ERROR, code: httpResponseCode, userInfo: nil))
                    }
                    
                } else {
                    completion(NSError(domain: Constants.MESSAGES._NO_HTTP_RESPONSE_ERROR, code: -1, userInfo: nil))
                }
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func getUserProfile(withCompletion completion: @escaping (Profile?, Error?) -> ()) {
        request(Constants.URLS._USER_PROFILE_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: userAuthHeader()).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        do {
                            let profileResponse = try JSONDecoder().decode(ProfileResponse.self, from: response.data!)
                            completion(profileResponse.profile, nil)
                            
                        } catch {
                            completion(nil, error)
                        }
                        
                    case 400..<500:
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                            completion(nil, NSError(domain: errorResponse.errorDescription, code: httpResponseCode, userInfo: Constants.ERRORS._CATCHED_ERROR))
                            
                        } catch {
                            completion(nil, error)
                        }
                        
                    default:
                        completion(nil, NSError(domain: Constants.MESSAGES._NETWORK_UNCATCHED_ERROR, code: httpResponseCode, userInfo: nil))
                    }
                    
                } else {
                    completion(nil, NSError(domain: Constants.MESSAGES._NO_HTTP_RESPONSE_ERROR, code: -1, userInfo: nil))
                }
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func recoverPassword(cpf: String, withCompletion completion: @escaping (Error?) -> ()) {
        ApplicationService.shared.authenticate { error in
            if let error = error {
                completion(error)
            } else {
                let params: Parameters = [
                    "codigoOperadora" : Constants.AUTH._OPERATOR_CODE,
                    "cpf" : cpf,
                    "imei" : AppContext.shared.deviceID
                ]
                
                self.request(Constants.URLS._RECOVER_USER_PASSWORD_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: self.appAuthHeader()).responseJSON { (response) in
                    switch response.result {
                    case .success(_):
                        if let httpResponseCode = response.response?.statusCode {
                            switch httpResponseCode {
                            case 200..<300:
                                completion(nil)
                                
                            case 400..<500:
                                do {
                                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                                    completion(NSError(domain: errorResponse.errorDescription, code: httpResponseCode, userInfo: Constants.ERRORS._CATCHED_ERROR))
                                    
                                } catch {
                                    completion(error)
                                }
                                
                            default:
                                completion(NSError(domain: Constants.MESSAGES._NETWORK_UNCATCHED_ERROR, code: httpResponseCode, userInfo: nil))
                            }
                            
                        } else {
                            completion(NSError(domain: Constants.MESSAGES._NO_HTTP_RESPONSE_ERROR, code: -1, userInfo: nil))
                        }
                        
                    case .failure(let error):
                        completion(error)
                    }
                }
            }
        }
    }
}
