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
    func send<T: QiitaRequest>(_ request: T) -> Observable<T.Response>
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
    private let tokenGetter: () -> (String?)

    public init(tokenGetter: @escaping () -> (String?),
                baseURL: String = "https://qiita.com/api",
                configuration: URLSessionConfiguration = .default) {
        self.tokenGetter = tokenGetter
        self.baseURL = baseURL
        self.session = Session(adapter: URLSessionAdapter(configuration: configuration))
    }
    
    public func send<T: QiitaRequest>(_ request: T) -> Observable<T.Response> {
        return Single<T.Response>.create { [weak self] observer in
            guard let me = self else {
                observer(.error(QiitaSession.Error.sessionMissing))
                return Disposables.create()
            }

            let proxy: QiitaRequestProxy<T>
            do {
                proxy = try QiitaRequestProxy(request: request,
                                              token: me.tokenGetter(),
                                              baseURL: me.baseURL)
            } catch let error {
                observer(.error(error))
                return Disposables.create()
            }

            let task = me.session.send(proxy) { result in
                switch result {
                case .success(let value):
                    observer(.success(value))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }.asObservable()
    }
}
