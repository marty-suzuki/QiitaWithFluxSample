//
//  ApplicationStore.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/15.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import RxSwift
import RxCocoa
import SwiftyUserDefaults

final class ApplicationStore {
    static let shared = ApplicationStore()
    
    let accessToken: Property<String?>
    private let _accessToken = Variable<String?>(nil)
    
    let accessTokenError: Observable<Error>
    private let _accessTokenError = PublishSubject<Error>()
    
    private let disposeBag = DisposeBag()
    
    init(dispatcher: AnyObservableDispatcher<ApplicationDispatcher> = .init(.shared)) {
        #if !TEST
            if let token = Defaults[.accessToken] {
                _accessToken.value = token
            }
        #endif
        
        self.accessToken = Property(_accessToken)
        self.accessTokenError = _accessTokenError
        
        #if TEST
            dispatcher.accessToken
                .bind(to: _accessToken)
                .addDisposableTo(disposeBag)
        #else
            dispatcher.accessToken
                .do(onNext: { Defaults[.accessToken] = $0 })
                .bind(to: _accessToken)
                .addDisposableTo(disposeBag)
        #endif
        
        dispatcher.accessTokenError
            .bind(to: _accessTokenError)
            .addDisposableTo(disposeBag)
    }
}
