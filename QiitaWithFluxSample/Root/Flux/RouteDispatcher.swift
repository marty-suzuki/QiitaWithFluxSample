//
//  RouteDispatcher.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/12.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import RxSwift

final class RouteDispatcher: DispatcherType {
    
    static let shared = RouteDispatcher()
    
    fileprivate let login = PublishSubject<RouteStore.LoginDisplayType>()
    
    private init() {}
}

extension AnyObserverDispatcher where Dispatcher: RouteDispatcher {
    var login: AnyObserver<RouteStore.LoginDisplayType> {
        return dispatcher.login.asObserver()
    }
}

extension AnyObservableDispatcher where Dispatcher: RouteDispatcher {
    var login: Observable<RouteStore.LoginDisplayType> {
        return dispatcher.login.asObservable()
    }
}
