//
//  RouteStore.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/12.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import RxSwift

final class RouteStore {
    enum LoginDisplayType {
        case root
        case webView
    }
    
    static let shared = RouteStore()
    
    let login: Observable<LoginDisplayType>
    private let _login = PublishSubject<LoginDisplayType>()
    
    private let disposeBag = DisposeBag()
    
    init(dispatcher: AnyObservableDispatcher<RouteDispatcher> = .init(.shared)) {
        self.login = _login.asObservable()
                        .shareReplayLatestWhileConnected()
        
        dispatcher.login
            .bindTo(_login)
            .addDisposableTo(disposeBag)
    }
}
