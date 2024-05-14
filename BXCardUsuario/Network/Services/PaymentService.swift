//
//  PaymentService.swift
//  VittaCardUsuario
//
//  Created by Daive Simões on 15/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire
import CryptoSwift

class PaymentService: BaseService {
    
    // MARK: - Singleton
    static let instance = PaymentService()
    
    // MARK: - Private Methods
    private func encrypt(Password password: String, forCPF cpf: String, andDeviceID deviceId: String, andCardID cardId: String, andPayToken token: String) -> String?{
        let seed = "\(deviceId.prefix(8).lowercased())\(cardId.suffix(8))\(token.prefix(8))\(cpf.onlyNumbers().suffix(8))"
        let aesKey = String(seed.prefix(16))
        let cbcIV = String(seed.suffix(16))
        
        do {
            let aes = try AES(key: aesKey, iv: cbcIV, padding: .pkcs7)
            let encrypted = try aes.encrypt(Array("\(password)0000".bytes))
            return encrypted.toBase64()
        } catch {
            print(error)
            return ""
        }
    }
    
    // MARK: - Public Methods
    func identifyPayment(forToken token: String, withCompletion completion: @escaping (PaymentIDResponse?, Error?) -> ()) {
        let params: Parameters = [
            "token" : token
        ]
        request(Constants.URLS._PAYMENT_IDENTIFICATION_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: userAuthHeader()).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        do {
                            let paymentResponse = try JSONDecoder().decode(PaymentIDResponse.self, from: response.data!)
                            completion(paymentResponse, nil)
                            
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
    
    func pay(forToken token: String, withCardID cardID: String, andCardPassword password: String, withCompletion completion: @escaping (PaymentResponse?, Error?) ->()) {
        let cpf = AppContext.shared.user.login ?? ""
        if let encryptedPassword = self.encrypt(Password: password, forCPF: cpf, andDeviceID: AppContext.shared.deviceID, andCardID: cardID, andPayToken: token) {
            let params: Parameters = [
                "cartao" : cardID,
                "senhaCartao" : encryptedPassword,
                "token" : token
            ]
            request(Constants.URLS._PAYMENT_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: userAuthHeader()).responseJSON { (response) in
                switch response.result {
                case .success(_):
                    if let httpResponseCode = response.response?.statusCode {
                        switch httpResponseCode {
                        case 200..<300:
                            do {
                                let paymentResponse = try JSONDecoder().decode(PaymentResponse.self, from: response.data!)
                                completion(paymentResponse, nil)
                                
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
            
        } else {
            completion(nil, NSError(domain: Constants.MESSAGES._PASSWORD_ENCRYPT_ERROR, code: -9, userInfo: nil))
        }
    }
    
}
