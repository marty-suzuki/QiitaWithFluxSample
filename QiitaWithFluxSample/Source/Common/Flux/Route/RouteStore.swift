//
//  RouteStore.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/12.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import RxSwift
import RxCocoa

enum LoginDisplayType {
    case root
    case webView
}

enum SearchDisplayType {
    case root
    case webView(URL)
}

final class RouteStore {
    static let shared = RouteStore()
    
    let login: Observable<LoginDisplayType?>
    private let _login = BehaviorSubject<LoginDisplayType?>(value: nil)
    
    let search: Observable<SearchDisplayType?>
    private let _search = BehaviorSubject<SearchDisplayType?>(value: nil)
    
    private let disposeBag = DisposeBag()
    
    init(dispatcher: RouteDispatcher = .shared) {
        self.login = _login
        self.search = _search
        
        dispatcher.register.login
            .bind(to: _login)
            .disposed(by: disposeBag)
        
        dispatcher.register.search
            .bind(to: _search)
            .disposed(by: disposeBag)
    }
}
