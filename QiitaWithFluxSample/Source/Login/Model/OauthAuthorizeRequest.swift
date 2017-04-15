//
//  OauthAuthorizeRequest.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/11.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Foundation

struct OauthAuthorizeRequest {
    enum Scope: String {
        case read = "read_qiita"
        case write = "write_qiita"
    }
    
    let clientId: String
    let scope: [Scope]
    let state: String
    
    func createURL() -> URL {
        var component: URLComponents = URLComponents(string: Config.shared.baseUrl + QiitaApiVersion.v2.rawValue + "/oauth/authorize")!
        component.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "scope", value: scope.reduce("") { $0 + ($0.isEmpty ? "" : "+") + $1.rawValue }),
            URLQueryItem(name: "state", value: state)
        ]
        return component.url!
    }
}
