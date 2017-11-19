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
    
    private let dispatcher: RouteDispatcher
    
    init(dispatcher: RouteDispatcher = .shared) {
        self.dispatcher = dispatcher
    }
    
    func show(loginDisplayType: LoginDisplayType) {
        dispatcher.dispatch.login.onNext(loginDisplayType)
    }
    
    func show(searchDisplayType: SearchDisplayType) {
        dispatcher.dispatch.search.onNext(searchDisplayType)
    }
}

