//
//  AccessTokensResponse.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/15.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Himotoki

public struct AccessTokensResponse: Decodable {
    public let cliendId: String
    public let scopes: [QiitaScope]
    public let token: String
    
    public static func decode(_ e: Extractor) throws -> AccessTokensResponse {
        return try AccessTokensResponse(
            cliendId: e <| "client_id",
            scopes: (e <|| "scopes").flatMap { QiitaScope(rawValue: $0) },
            token: e <| "token"
        )
    }
}
