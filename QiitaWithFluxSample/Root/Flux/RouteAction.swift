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
    
    private let dispatcher: AnyObserverDispatcher<RouteDispatcher>
    
    init(dispatcher: AnyObserverDispatcher<RouteDispatcher> = .init(.shared)) {
        self.dispatcher = dispatcher
    }
    
    func show(loginDisplayType: RouteStore.LoginDisplayType) {
        dispatcher.login.onNext(loginDisplayType)
    }
}

