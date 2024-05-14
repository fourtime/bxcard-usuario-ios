//
//  SpecialtyService.swift
//  VittaCardUsuario
//
//  Created by Daive Simões on 16/04/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire

class SpecialtyService: BaseService {
    
    // MARK: - Singleton
    static let instance = SpecialtyService()
    
    // MARK: - Public API
    var specialties = [Specialty]()
    
    // MARK: - Public Methods
    func getSpecialties(forSegment segment: Segment, withCompletion completion: @escaping (Error?) -> ()) {
        let params: Parameters = [
            "idCartao" : AppContext.shared.user.selectedCard!.id,
            "tipoCartao" : AppContext.shared.user.selectedCard!.type,
            "segmento" : segment.name
        ]
        let request = super.request(Constants.URLS._SPECIALTIES_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: userAuthHeader())
        request.responseJSON { response in
            self.specialties.removeAll()

            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        do {
                            let specialtyResponse = try JSONDecoder().decode(SpecialtyResponse.self, from: response.data!)
                            self.specialties = specialtyResponse.specialties
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
