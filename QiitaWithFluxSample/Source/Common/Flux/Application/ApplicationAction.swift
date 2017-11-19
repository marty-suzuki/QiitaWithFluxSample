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
    
    private let dispatcher: ApplicationDispatcher
    private let routeAction: RouteAction
    private let session: QiitaSessionType
    private let config: Config
    
    private let disposeBag = DisposeBag()
    
    init(dispatcher: ApplicationDispatcher = .shared,
         routeAction: RouteAction = .shared,
         session: QiitaSessionType = QiitaSession.shared,
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
            .do(onError: dispatcher.dispatch.accessTokenError.onNext)
            .subscribe(onNext: dispatcher.dispatch.accessToken.onNext)
            .disposed(by: disposeBag)
    }
    
    func removeAccessToken() {
        dispatcher.dispatch.accessToken.onNext(nil)
    }
}
