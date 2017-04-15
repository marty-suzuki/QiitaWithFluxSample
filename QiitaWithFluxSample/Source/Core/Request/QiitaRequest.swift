//
//  QiitaRequest.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/02.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import APIKit

enum QiitaApiVersion: String {
    case v2 = "/v2"
}

protocol QiitaRequest: Request {
    var apiVersion: QiitaApiVersion { get }
}

extension QiitaRequest {
    var baseURL: URL {
        return URL(string: Config.shared.baseUrl + apiVersion.rawValue)!
    }
    
    var apiVersion: QiitaApiVersion {
        return .v2
    }
}
