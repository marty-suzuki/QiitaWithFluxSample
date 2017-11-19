//
//  QiitaSessionType.swift
//  QiitaWithFluxSampleTests
//
//  Created by marty-suzuki on 2017/11/20.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Result
import APIKit
import QiitaSession
@testable import QiitaWithFluxSample

extension QiitaSessionType {
    func send<T: QiitaRequest>(_ request: T, completion: @escaping (Result<T.Response, AnyError>) -> ()) -> SessionTask? {
        fatalError("must implement")
    }
}
