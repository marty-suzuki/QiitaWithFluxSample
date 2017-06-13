//
//  QiitaRequest.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/02.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import APIKit

public enum QiitaApiVersion: String {
    case v2 = "/v2"
}

public protocol QiitaRequest: Request {
    var apiVersion: QiitaApiVersion { get }
}

extension QiitaRequest {
    public var baseURL: URL {
        return URL(string: QiitaRequestConfig.baseUrl + apiVersion.rawValue)!
    }
    
    public var apiVersion: QiitaApiVersion {
        return .v2
    }
    
    public var headerFields: [String : String] {
        guard let token = QiitaRequestConfig.token else { return [:] }
        return [
            "Authorization" : "Bearer \(token)"
        ]
    }
}
