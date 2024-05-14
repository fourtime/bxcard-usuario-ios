//
//  File.swift
//  VittaCardUsuario
//
//  Created by Daive Simões on 21/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire

class SegmentService: BaseService {
    
    // MARK: - Singleton
    static let instance = SegmentService()
    
    // MARK: - Public API
    var segments = [Segment]()
    
    // MARK: - Public Methods
    func getSegments(forCard card: Card, withCompletion completion: @escaping (Error?) -> ()) {
        let params: Parameters = [
            "idCartao" : card.id,
            "tipoCartao" : card.type
        ]
        request(Constants.URLS._SEGMENTS_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: userAuthHeader()).responseJSON { (response) in
            self.segments.removeAll()
            
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        do {
                            let segmentResponse = try JSONDecoder().decode(SegmentResponse.self, from: response.data!)
                            self.segments = segmentResponse.segments
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
