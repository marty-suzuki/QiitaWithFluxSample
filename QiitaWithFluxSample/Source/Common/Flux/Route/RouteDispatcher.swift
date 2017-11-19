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
extension Dispatch where Dispatcher: RouteDispatcher {
    var login: AnyObserver<LoginDisplayType> {
        return dispatcher.login.asObserver()
    }
    
    var search: AnyObserver<SearchDisplayType> {
        return dispatcher.search.asObserver()
    }
}

extension RouteDispatcher: RegisterCompatible {}
extension Register where Dispatcher: RouteDispatcher {
    var login: Observable<LoginDisplayType> {
        return dispatcher.login
    }
    
    var search: Observable<SearchDisplayType> {
        return dispatcher.search
    }
}

import QiitaSession
extension RouteDispatcher: TestableCompatible {}
extension Testable where Base == RouteDispatcher.Type {
    func make() -> RouteDispatcher {
        return RouteDispatcher()
    }
}

