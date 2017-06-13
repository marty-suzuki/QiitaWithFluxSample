//
//  AccessTokensRequest.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/15.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import APIKit
import Himotoki

public struct AccessTokensRequest: QiitaRequest {
    public let method: HTTPMethod = .post
    public let path: String = "/access_tokens"
    public var queryParameters: [String : Any]? {
        return [
            "client_id" : clientId,
            "client_secret" : clientSecret,
            "code" : code
        ]
    }
    
    public let clientId: String
    public let clientSecret: String
    public let code: String
    
    public init(clientId: String, clientSecret: String, code: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.code = code
    }
    
    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> AccessTokensResponse {
        return try decodeValue(object)
    }
}
