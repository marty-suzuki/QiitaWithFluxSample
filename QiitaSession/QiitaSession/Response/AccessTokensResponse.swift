//
//  AccessTokensResponse.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/15.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Foundation

public struct AccessTokensResponse: Codable {
    public let cliendId: String
    public let scopes: [QiitaScope]
    public let token: String

    private enum CodingKeys: String, CodingKey {
        case cliendId = "client_id"
        case scopes
        case token
    }
}

extension AccessTokensResponse: TestableCompatible {}
extension Testable where Base == AccessTokensResponse.Type {
    public func make(cliendId: String, scopes: [QiitaScope], token: String) -> AccessTokensResponse {
        return AccessTokensResponse(cliendId: cliendId, scopes: scopes, token: token)
    }
}
