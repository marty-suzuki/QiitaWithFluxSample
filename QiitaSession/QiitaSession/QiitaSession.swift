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
    
    public static let shared = QiitaSession()
    
    private let session: Session = {
        let configuration = URLSessionConfiguration.default
        let adapter = URLSessionAdapter(configuration: configuration)
        return Session(adapter: adapter)
    }()
    
    private init() {}
    
    public func send<T: QiitaRequest>(_ request: T) -> Observable<T.Response> {
        return Single<T.Response>.create { [unowned self] observer in
            let task = self.session.send(request) { result in
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
