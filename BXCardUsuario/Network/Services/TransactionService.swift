//
//  TransactionService.swift
//  VittaCardUsuario
//
//  Created by Daive Simões on 13/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire

class TransactionService: BaseService {
    
    // MARK: - Singleton
    static let instance = TransactionService()
    
    // MARK: - Public Methods
    func getTransactions(forPage pageIndex: Int, andInitialDate initialDate: Date, andFinalDate finalDate: Date, ofCard card: Card, withCompletion completion: @escaping ([Transaction], Int, Error?) -> ()) {
        let params: Parameters = [
            "idCartao": card.id,
            "tipoCartao" : card.type,
            "dataInicio" : Utils.formatDate(date: initialDate, withOutFormat: Constants.MASKS._DEFAULT_DATE_TIME),
            "dataFim" : Utils.formatDate(date: finalDate, withOutFormat: Constants.MASKS._DEFAULT_DATE_TIME),
            "numeroPagina" : pageIndex,
            "tamanhoPagina" : Constants.PAGINATION._PAGE_SIZE
        ]
        request(Constants.URLS._TRANSACTIONS_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: userAuthHeader()).responseJSON { (response) in
            
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        do {
                            let transactionResponse = try JSONDecoder().decode(TransactionResponse.self, from: response.data!)
                            completion(transactionResponse.results.dados, transactionResponse.results.totalRegistros, nil)
                            
                        } catch {
                            completion([Transaction](), 0, error)
                        }
                        
                    case 400..<500:
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                            completion([Transaction](), 0, NSError(domain: errorResponse.errorDescription, code: httpResponseCode, userInfo: Constants.ERRORS._CATCHED_ERROR))
                            
                        } catch {
                            completion([Transaction](), 0, error)
                        }
                    
                    default:
                        completion([Transaction](), 0, NSError(domain: Constants.MESSAGES._NETWORK_UNCATCHED_ERROR, code: httpResponseCode, userInfo: nil))
                    }
                    
                } else {
                    completion([Transaction](), 0, NSError(domain: Constants.MESSAGES._NO_HTTP_RESPONSE_ERROR, code: -1, userInfo: nil))
                }
            case .failure(let error):
                completion([Transaction](), 0, error)
            }
        }
    }
    
}
