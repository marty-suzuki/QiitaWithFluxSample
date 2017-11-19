//
//  QiitaSession.shared.swift
//  QiitaWithFluxSample
//
//  Created by 鈴木大貴 on 2017/11/18.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import QiitaSession
import Result
import RxSwift

protocol QiitaSessionType: SessionType {
    func send<T: QiitaRequest>(_ request: T) -> Observable<T.Response>
}

extension QiitaSession: QiitaSessionType {
    static let shared: QiitaSession = .init(tokenGetter: { ApplicationStore.shared.accessToken.value },
                                            baseURL: Config.shared.baseUrl)
    
    func send<T: QiitaRequest>(_ request: T) -> Observable<T.Response> {
        return Single<T.Response>.create { [weak self] observer in
            guard let me = self else {
                observer(.error(QiitaSession.Error.sessionMissing))
                return Disposables.create()
            }
            let task = me.send(request) {
                switch $0 {
                case .success(let value):
                    observer(.success(value))
                case .failure(let anyError):
                    observer(.error(anyError.error))
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }.asObservable()
    }
}
