//
//  QiitaSession.shared.swift
//  QiitaWithFluxSample
//
//  Created by 鈴木大貴 on 2017/11/18.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import QiitaSession

extension QiitaSession {
    static let shared: QiitaSession = .init(tokenGetter: { ApplicationStore.shared.accessToken.value },
                                            baseURL: Config.shared.baseUrl)
}
