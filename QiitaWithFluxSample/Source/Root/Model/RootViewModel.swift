//
//  RootViewModel.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/17.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import RxSwift

final class RootViewModel {
    private let disposeBag = DisposeBag()
    
    let login: Observable<LoginDisplayType?>
    let search: Observable<SearchDisplayType?>
    
    init(applicationStore: ApplicationStore = .shared,
         routeAction: RouteAction = .shared,
         routeStore: RouteStore = .shared) {
        
        let accessTokenObservable = applicationStore.accessToken.asObservable()
            .shareReplayLatestWhileConnected()
        
        accessTokenObservable
            .filter { $0 != nil }
            .map { _ in SearchDisplayType.root }
            .bindNext(routeAction.show)
            .addDisposableTo(disposeBag)
        
        accessTokenObservable
            .filter { $0 == nil }
            .map { _ in LoginDisplayType.root }
            .bindNext(routeAction.show)
            .addDisposableTo(disposeBag)
        
        self.login = routeStore.login
        self.search = routeStore.search
    }
}
