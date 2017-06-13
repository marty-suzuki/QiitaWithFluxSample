//
//  ApplicationAction.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/15.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import RxSwift
import RxCocoa
import QiitaSession

final class ApplicationAction {
    static let shared = ApplicationAction()
    
    private let dispatcher: AnyObserverDispatcher<ApplicationDispatcher>
    private let routeAction: RouteAction
    private let session: SessionType
    private let config: Config
    
    private let disposeBag = DisposeBag()
    
    init(dispatcher: AnyObserverDispatcher<ApplicationDispatcher> = .init(.shared),
         routeAction: RouteAction = .shared,
         session: SessionType = QiitaSession.shared,
         config: Config = .shared) {
        self.dispatcher = dispatcher
        self.routeAction = routeAction
        self.session = session
        self.config = config
    }
    
    func requestAccessToken(withCode code: String) {
        let request = AccessTokensRequest(clientId: config.clientId,
                                          clientSecret: config.clientSecret,
                                          code: code)
        session.send(request)
            .map { Optional.some($0.token) }
            .do(onError: dispatcher.accessTokenError.onNext)
            .subscribe(onNext: dispatcher.accessToken.onNext)
            .addDisposableTo(disposeBag)
    }
    
    func removeAccessToken() {
        dispatcher.accessToken.onNext(nil)
    }
}
