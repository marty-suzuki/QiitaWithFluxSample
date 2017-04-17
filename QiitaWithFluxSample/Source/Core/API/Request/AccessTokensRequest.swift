//
//  AccessTokensRequest.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/15.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import APIKit
import Himotoki

struct AccessTokensRequest: QiitaRequest {
    let clientId: String
    let clientSecret: String
    let code: String
    
    let method: HTTPMethod = .post
    let path: String = "/access_tokens"
    
    var queryParameters: [String : Any]? {
        return [
            "client_id" : clientId,
            "client_secret" : clientSecret,
            "code" : code
        ]
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> AccessTokensResponse {
        return try decodeValue(object)
    }
}
