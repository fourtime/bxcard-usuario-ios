//
//  NeighborhoodService.swift
//  VittaCardUsuario
//
//  Created by Daive Simões on 21/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire

class NeighborhoodService: BaseService {
    
    // MARK: - Singleton
    static let instance = NeighborhoodService()
    
    // MARK: - Public Properties
    var neighborhoods = [Neighborhood]()
    
    // MARK: - Public Properties
    func getNeighborhoods(forSegment segment: Segment?, andActivity activity: Activity?, andSpecialty specialty: Specialty?, andState state: State, andCity city: City, withCompletion completion: @escaping (Error?) -> ()) {
        let params: Parameters = [
            "idCartao" : AppContext.shared.user.selectedCard!.id,
            "tipoCartao" : AppContext.shared.user.selectedCard!.type,
            "segmento" : segment != nil ? segment!.name : "",
            "ramoAtividade" : activity != nil ? activity!.description : "",
            "especialidade" : specialty != nil ? specialty!.name : "",
            "uf" : state.description,
            "cidade" : city.description
        ]
        request(Constants.URLS._NEIGHBORHOODS_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: userAuthHeader()).responseJSON { (response) in
            self.neighborhoods.removeAll()
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        do {
                            let neighborhoodResponse = try JSONDecoder().decode(NeighborhoodResponse.self, from: response.data!)
                            self.neighborhoods = neighborhoodResponse.neighborhoods
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
