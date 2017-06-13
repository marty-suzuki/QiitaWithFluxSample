//
//  OauthAuthorizeRequest.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/11.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Foundation
import QiitaSession

struct OauthAuthorizeRequest {
    enum Error: Swift.Error {
        case failedInitializingURLComponents(String)
        case nilReceived(URLComponents)
    }
    
    let state: String = UUID().uuidString
    let scope: [QiitaScope]
    let config: Config
    
    func createURL() throws -> URL {
        let urlString = config.baseUrl + QiitaApiVersion.v2.rawValue + "/oauth/authorize"
        var component = try URLComponents(string: urlString) ?? {
            throw Error.failedInitializingURLComponents(urlString)
        }()
        component.queryItems = [
            URLQueryItem(name: "client_id", value: config.clientId),
            URLQueryItem(name: "scope", value: scope.reduce("") { $0 + ($0.isEmpty ? "" : "+") + $1.rawValue }),
            URLQueryItem(name: "state", value: state)
        ]
        return try component.url ?? {
            throw Error.nilReceived(component)
        }()
    }
}
