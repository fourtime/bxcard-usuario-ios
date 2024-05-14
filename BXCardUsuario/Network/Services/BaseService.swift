//
//  BaseService.swift
//  VittaCardUsuario
//
//  Created by Rafael Rocha Gans on 05/06/22.
//  Copyright © 2022 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class BaseService {
    func appAuthHeader() -> HTTPHeaders {
        return ["Authorization": "Bearer \(AppContext.shared.appToken?.accessToken ?? "")"]
    }
    func userAuthHeader() -> HTTPHeaders {
        return ["Authorization": "Bearer \(AppContext.shared.user.token?.accessToken ?? "")"]
    }
    
    func request(_ url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil) -> DataRequest {
        return AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .log()
            .responseString(completionHandler: { (response) in
                debugPrint(response)
            })
    }
}
