//
//  QiitaSession.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/02.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import APIKit
import RxSwift

class QiitaSession {
    
    static let shared = QiitaSession()
    
    private let session: Session = {
        let configuration = URLSessionConfiguration.default
        let adapter = URLSessionAdapter(configuration: configuration)
        return Session(adapter: adapter)
    }()
    
    private init() {}
    
    func send<T: QiitaRequest>(_ request: T) -> Observable<T.Response> {
        return Observable.create { [unowned self] observer in
            let task = self.session.send(request) { result in
                switch result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }.take(1)
    }
}
