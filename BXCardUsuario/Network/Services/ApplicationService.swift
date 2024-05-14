//
//  ApplicationService.swift
//  VittaCardUsuario
//
//  Created by Daive Simões on 16/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire

class ApplicationService: BaseService {
    
    // MARK: - Singleton
    static let shared = ApplicationService()
    
    // MARK: - Public Methods
    func authenticate(_ completion: @escaping (Error?) -> ()) {
        let params: Parameters = [
            "applicationKey" : Constants.AUTH._APPLICATION_TOKEN,
        ]
        request(Constants.URLS._TOKEN_REQUEST_URL, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        do {
                            let response = try JSONDecoder().decode(TokenResponse.self, from: response.data!)
                            
                            AppContext.shared.appToken = response.transform()
                            
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
    
}
