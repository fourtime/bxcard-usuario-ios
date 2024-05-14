//
//  UtilService.swift
//  VittaCardUsuario
//
//  Created by Daive Simões on 12/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - UsefullLink Enum
enum UsefullLink: String {
    case operatorWarnings = "avisosOperadora"
    case operatorContact = "contatoOperadora"
}


class UtilService: BaseService {
    
    // MARK: - Singleton
    static let instance = UtilService()
    
    // MARK: - Public Methods
    func getUseTerms(withCompletion completion: @escaping (Data?, Error?) -> ()) {
        let url = "\(Constants.URLS._USE_TERMS_URL)/\(Constants.AUTH._OPERATOR_CODE)"
        request(url).responseData { (response) in
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        completion(response.data, nil)
                        
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
    
    func getPrivacyPolitics(withCompletion completion: @escaping (Data?, Error?) -> ()) {
        let url = "\(Constants.URLS._PRIVACY_POLITICS_URL)/\(Constants.AUTH._OPERATOR_CODE)"
        request(url).responseData { (response) in
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        completion(response.data, nil)
                        
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
    
    func getUsefullLink(forId id: UsefullLink, withCompletion completion: @escaping (String?, Error?) -> ()) {
        let url = "\(Constants.URLS._USEFULL_LINKS_URL)/\(Constants.AUTH._OPERATOR_CODE)"
        request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        do {
                            let linksResponse = try JSONDecoder().decode(UsefullLinksResponse.self, from: response.data!)
                            switch id {
                            case .operatorWarnings:
                                completion(linksResponse.links.operatorWarnings, nil)
                                
                            case .operatorContact:
                                completion(linksResponse.links.operatorContact, nil)
                            }
                            
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
    
}
