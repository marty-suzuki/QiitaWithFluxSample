//
//  QiitaRequest.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/02.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import APIKit

protocol QiitaRequest: Request {}

extension QiitaRequest {
    var baseURL: URL {
        return URL(string: Config.baseUrl)!
    }
}
