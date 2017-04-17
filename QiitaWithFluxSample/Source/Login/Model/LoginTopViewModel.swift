//
//  LoginTopViewModel.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/17.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import RxSwift
import RxCocoa

final class LoginTopViewModel {
    private let disposeBag = DisposeBag()
    
    init(loginButtonTap: ControlEvent<Void>,
         routeAction: RouteAction = .shared) {
        
        loginButtonTap
            .shareReplayLatestWhileConnected()
            .map { LoginDisplayType.webView }
            .bindNext(routeAction.show)
            .addDisposableTo(disposeBag)
    }
}
