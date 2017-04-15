//
//  ApplicationAction.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/15.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import RxSwift

final class ApplicationAction {
    static let shared = ApplicationAction()
    
    private let dispatcher: AnyObserverDispatcher<ApplicationDispatcher>
    private let applicationStore: ApplicationStore
    private let routeAction: RouteAction
    
    private let disposeBag = DisposeBag()
    
    init(dispatcher: AnyObserverDispatcher<ApplicationDispatcher> = .init(.shared),
         applicationStore: ApplicationStore = .shared,
         routeAction: RouteAction = .shared) {
        self.dispatcher = dispatcher
        self.applicationStore = applicationStore
        self.routeAction = routeAction
    }
    
    func requestAccessToken(withCode code: String) {
        let config = Config.shared
        let request = AccessTokensRequest(clientId: config.clientId,
                                          clientSecret: config.clientSecret,
                                          code: code)
        QiitaSession.shared.send(request)
            .map { Optional.some($0.token) }
            .do(onError: { [weak self] error in
                self?.dispatcher.accessTokenError.onNext(error)
            })
            .bindTo(dispatcher.accessToken)
            .addDisposableTo(disposeBag)
    }
}
