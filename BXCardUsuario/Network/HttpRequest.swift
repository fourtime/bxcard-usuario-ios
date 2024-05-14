//
//  HttpRequest.swift
//  VittaCardUsuario
//
//  Created by Rafael Rocha Gans on 05/06/22.
//  Copyright © 2022 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire

class HttpRequest {
    @discardableResult
    func request(_ url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil) -> DataRequest {
        return AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
}
