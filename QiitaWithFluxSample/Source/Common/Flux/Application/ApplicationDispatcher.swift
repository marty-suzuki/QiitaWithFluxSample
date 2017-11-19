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
extension Dispatch where Dispatcher: ApplicationDispatcher {
    var accessToken: AnyObserver<String?> {
        return dispatcher.accessToken.asObserver()
    }
    var accessTokenError: AnyObserver<Error> {
        return dispatcher.accessTokenError.asObserver()
    }
}

extension ApplicationDispatcher: RegisterCompatible {}
extension Register where Dispatcher: ApplicationDispatcher {
    var accessToken: Observable<String?> {
        return dispatcher.accessToken
    }
    var accessTokenError: Observable<Error> {
        return dispatcher.accessTokenError
    }
}

import QiitaSession
extension ApplicationDispatcher: TestableCompatible {}
extension Testable where Base == ApplicationDispatcher.Type {
    func make() -> ApplicationDispatcher {
        return ApplicationDispatcher()
    }
}
