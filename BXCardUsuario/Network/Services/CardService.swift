//
//  CardService.swift
//  VittaCardUsuario
//
//  Created by Daive Simões on 12/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire

class CardService: BaseService {
    
    // MARK: - Singleton
    static let instance = CardService()
    
    // MARK: - Public Properties
    var cards = [Card]()
    
    // MARK: - Public Methods
    func getCards(withCompletion completion: @escaping (Error?) -> ()) {
        request(Constants.URLS._USER_CARDS_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: userAuthHeader()).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        do {
                            let cardsResponse = try JSONDecoder().decode(CardsResponse.self, from: response.data!)
                            self.cards = cardsResponse.cards
                            //self.cards.append(contentsOf: cardsResponse.cards)
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
    
    func getBalance(forCard card: Card, withCompletion completion: @escaping (Double, Error?) -> ()) {
        let params: Parameters = [
            "idCartao" : card.id,
            "tipoCartao" : card.type
        ]
        request(Constants.URLS._CARD_BALANCE_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: userAuthHeader()).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        do {
                            let balanceResponse = try JSONDecoder().decode(CardBalanceResponse.self, from: response.data!)
                            completion(balanceResponse.cardBalance.balance, nil)
                            
                        } catch {
                            completion(0.0, error)
                        }
                        
                    case 400..<500:
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                            completion(0.0, NSError(domain: errorResponse.errorDescription, code: httpResponseCode, userInfo: Constants.ERRORS._CATCHED_ERROR))
                            
                        } catch {
                            completion(0.0, error)
                        }
                        
                    default:
                        completion(0.0, NSError(domain: Constants.MESSAGES._NETWORK_UNCATCHED_ERROR, code: httpResponseCode, userInfo: nil))
                    }
                    
                } else {
                    completion(0.0, NSError(domain: Constants.MESSAGES._NO_HTTP_RESPONSE_ERROR, code: -1, userInfo: nil))
                }
                
            case .failure(let error):
                completion(0.0, error)
            }
        }
        
    }
    
}
