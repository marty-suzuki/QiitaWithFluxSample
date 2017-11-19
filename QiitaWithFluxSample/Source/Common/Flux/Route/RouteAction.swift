//
//  RouteAction.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/12.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import RxSwift

final class RouteAction {
    static let shared = RouteAction()
    
    private let dispatcher: Dispatcher<RouteDispatcher>
    
    init(dispatcher: Dispatcher<RouteDispatcher> = RouteDispatcher.shared.dispatcher) {
        self.dispatcher = dispatcher
    }
    
    func show(loginDisplayType: LoginDisplayType) {
        dispatcher.login.onNext(loginDisplayType)
    }
    
    func show(searchDisplayType: SearchDisplayType) {
        dispatcher.search.onNext(searchDisplayType)
    }
}

