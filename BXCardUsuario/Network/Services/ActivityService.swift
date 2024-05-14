//
//  ActivityService.swift
//  VittaCardUsuario
//
//  Created by Daive Simões on 21/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire

class ActivityService: BaseService {
    
    // MARK: - Singleton
    static let instance = ActivityService()
    
    // MARK: - Public Properties
    var activities = [Activity]()
    
    // MARK: - Public Methods
    func getActivities(forSegment segment: Segment, andSpecialty specialty: Specialty?, andState state: State?, andCity city: City?, withCompletion completion: @escaping (Error?) ->()) {
        let params: Parameters = [
            "idCartao" : AppContext.shared.user.selectedCard!.id,
            "tipoCartao" : AppContext.shared.user.selectedCard!.type,
            "segmento" : segment.name,
            "especialidade" : specialty != nil ? specialty!.name : "",
            "uf" : state != nil ? state!.description : "",
            "cidade" : city != nil ? city!.description : ""
        ]
        request(Constants.URLS._ACTIVITIES_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: userAuthHeader()).responseJSON { (response) in
            self.activities.removeAll()
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        do {
                            let activitiesResponse = try JSONDecoder().decode(ActivityResponse.self, from: response.data!)
                            self.activities = activitiesResponse.activities
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
