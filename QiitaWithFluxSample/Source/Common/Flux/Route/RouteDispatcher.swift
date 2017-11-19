//
//  RouteDispatcher.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/12.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import RxSwift

final class RouteDispatcher {
    static let shared = RouteDispatcher()
    
    fileprivate let login = PublishSubject<LoginDisplayType>()
    fileprivate let search = PublishSubject<SearchDisplayType>()

    fileprivate init() {}
}

extension RouteDispatcher: DispatchCompatible {}
extension Dispatcher where Base: RouteDispatcher {
    var login: AnyObserver<LoginDisplayType> {
        return base.login.asObserver()
    }
    
    var search: AnyObserver<SearchDisplayType> {
        return base.search.asObserver()
    }
}

extension RouteDispatcher: RegisterCompatible {}
extension Registrator where Base: RouteDispatcher {
    var login: Observable<LoginDisplayType> {
        return base.login
    }
    
    var search: Observable<SearchDisplayType> {
        return base.search
    }
}

import QiitaSession
extension RouteDispatcher: TestableCompatible {}
extension Testable where Base == RouteDispatcher.Type {
    func make() -> RouteDispatcher {
        return RouteDispatcher()
    }
}

