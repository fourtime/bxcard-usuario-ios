//
//  AssociatedService.swift
//  VittaCardUsuario
//
//  Created by Daive Simões on 18/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation
import GoogleMaps

class AssociatedService: BaseService {
    
    // MARK: - Singleton
    static let instance = AssociatedService()
    
    // MARK: - Public Methods
    func getAssociated(forPage pageIndex: Int, bySegment segment: Segment?, andActivity activity: Activity?, andSpecialty specialty: Specialty?, andState state: State?, andCity city: City?, andNeighborhood neighborhood: Neighborhood?, withCompletion completion: @escaping ([Associated], Int, Error?) -> ()) {
        let params: Parameters = [
            "idCartao" : AppContext.shared.user.selectedCard!.id,
            "tipoCartao" : AppContext.shared.user.selectedCard!.type,
            "segmento" : segment != nil ? segment!.name : "",
            "especialidade" : specialty != nil ? specialty!.name : "",
            "uf" : state != nil ? state!.description : "",
            "cidade" : city != nil ? city!.description : "",
            "bairro" : neighborhood != nil ? neighborhood!.description : "",
            "ramoAtividade" : activity != nil ? activity!.description : "",
            "numeroPagina" : pageIndex,
            "tamanhoPagina" : Constants.PAGINATION._PAGE_SIZE
        ]
        request(Constants.URLS._ASSOCIATED_SEARCH_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: userAuthHeader()).responseJSON { (response) in
            switch response.result {
            case .success(_):
                print(response.result)
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        do {
                            let associatedResponse = try JSONDecoder().decode(AssociatedResponse.self, from: response.data!)
                            completion(associatedResponse.results.data, associatedResponse.results.totalRecords, nil)
                            
                        } catch {
                            completion([Associated](), 0, error)
                        }
                        
                    case 400..<500:
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                            completion([Associated](), 0, NSError(domain: errorResponse.errorDescription, code: httpResponseCode, userInfo: Constants.ERRORS._CATCHED_ERROR))
                            
                        } catch {
                            completion([Associated](), 0, error)
                        }
                        
                    default:
                        completion([Associated](), 0, NSError(domain: Constants.MESSAGES._NETWORK_UNCATCHED_ERROR, code: httpResponseCode, userInfo: nil))
                    }
                    
                } else {
                    completion([Associated](), 0, NSError(domain: Constants.MESSAGES._NO_HTTP_RESPONSE_ERROR, code: -1, userInfo: nil))
                }
                
            case .failure(let error):
                completion([Associated](), 0, error)
            }
        }
    }
    
    func getAssociatedCoordinatesAround(coordinate: CLLocationCoordinate2D, withCompletion completion: @escaping ([AssociatedPosition], Error?) -> ()) {
        let params: Parameters = [
            "idCartao" : AppContext.shared.user.selectedCard!.id,
            "tipoCartao" : AppContext.shared.user.selectedCard!.type,
            "latitude" : "\(coordinate.latitude.rounded(toPlaces: 4))",
            "longitude" : "\(coordinate.longitude.rounded(toPlaces: 4))"
        ]
        request(Constants.URLS._ASSOCIATED_GEOLOCATION_SEARCH_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: userAuthHeader()).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        do {
                            let associatedResponse = try JSONDecoder().decode(AssociatedPinResponse.self, from: response.data!)
                            completion(associatedResponse.associatedPositions, nil)
                            
                        } catch {
                            completion([AssociatedPosition](), error)
                        }
                        
                    case 400..<500:
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                            completion([AssociatedPosition](), NSError(domain: errorResponse.errorDescription, code: httpResponseCode, userInfo: Constants.ERRORS._CATCHED_ERROR))
                            
                        } catch {
                            completion([AssociatedPosition](), error)
                        }
                        
                    default:
                        completion([AssociatedPosition](), NSError(domain: Constants.MESSAGES._NETWORK_UNCATCHED_ERROR, code: httpResponseCode, userInfo: nil))
                    }
                    
                } else {
                    completion([AssociatedPosition](), NSError(domain: Constants.MESSAGES._NO_HTTP_RESPONSE_ERROR, code: -1, userInfo: nil))
                }
                
            case .failure(let error):
                completion([AssociatedPosition](), error)
            }
        }
    }
    
    func getAssociatedDetails(fromAssociatedId associatedId: String, withCompletion completion: @escaping (Associated?, Error?) -> ()) {
        let url = "\(Constants.URLS._ASSOCIATED_DATA_URL)/\(associatedId)"
        request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: userAuthHeader()).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        do {
                            let detailsResponse = try JSONDecoder().decode(AssociatedDetailResponse.self, from: response.data!)
                            completion(detailsResponse.associated, nil)
                            
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
