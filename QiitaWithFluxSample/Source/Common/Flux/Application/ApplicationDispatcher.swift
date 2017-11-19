//
//  ApplicationDispatcher.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/15.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import RxSwift

final class ApplicationDispatcher {
    static let shared = ApplicationDispatcher()
    
    fileprivate let accessToken = PublishSubject<String?>()
    fileprivate let accessTokenError = PublishSubject<Error>()
    
    fileprivate init() {}
}

extension ApplicationDispatcher: DispatchCompatible {}
extension Dispatcher where Base: ApplicationDispatcher {
    var accessToken: AnyObserver<String?> {
        return base.accessToken.asObserver()
    }
    var accessTokenError: AnyObserver<Error> {
        return base.accessTokenError.asObserver()
    }
}

extension ApplicationDispatcher: RegisterCompatible {}
extension Registrator where Base: ApplicationDispatcher {
    var accessToken: Observable<String?> {
        return base.accessToken
    }
    var accessTokenError: Observable<Error> {
        return base.accessTokenError
    }
}

import QiitaSession
extension ApplicationDispatcher: TestableCompatible {}
extension Testable where Base == ApplicationDispatcher.Type {
    func make() -> ApplicationDispatcher {
        return ApplicationDispatcher()
    }
}
