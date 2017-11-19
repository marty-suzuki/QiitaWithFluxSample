//
//  QiitaSession.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/02.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import APIKit
import Result
import RxSwift

public protocol SessionType: class {
    func send<T: QiitaRequest>(_ request: T, completion: @escaping (Result<T.Response, AnyError>) -> ()) -> SessionTask?
}

public final class QiitaSession: SessionType {
    public enum Error: Swift.Error {
        case isNotData(Any)
        case typeMismatch(String, actual: Any?)
        case createBaseURLFailed(String)
        case sessionMissing
    }
    
    private let session: Session
    private let baseURL: String
    private let tokenGetter: () -> String?

    public init(tokenGetter: @escaping () -> String?,
                baseURL: String = "https://qiita.com/api",
                configuration: URLSessionConfiguration = .default) {
        self.tokenGetter = tokenGetter
        self.baseURL = baseURL
        self.session = Session(adapter: URLSessionAdapter(configuration: configuration))
    }
    
    public func send<T: QiitaRequest>(_ request: T, completion: @escaping (Result<T.Response, AnyError>) -> ()) -> SessionTask? {
        let proxy: QiitaRequestProxy<T>
        do {
            proxy = try QiitaRequestProxy(request: request,
                                          token: tokenGetter(),
                                          baseURL: baseURL)
        } catch let error {
            completion(.failure(AnyError(error)))
            return nil
        }
        return session.send(proxy) { result in
            switch result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(AnyError(error)))
            }
        }
    }
}
