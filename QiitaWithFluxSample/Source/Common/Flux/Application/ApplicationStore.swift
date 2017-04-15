//
//  ApplicationStore.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/15.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import RxSwift
import SwiftyUserDefaults

final class ApplicationStore {
    static let shared = ApplicationStore()
    
    let accessToken: Property<String?>
    private let _accessToken = Variable<String?>(nil)
    
    let accessTokenError: Observable<Error>
    private let _accessTokenError = PublishSubject<Error>()
    
    private let disposeBag = DisposeBag()
    
    init(dispatcher: AnyObservableDispatcher<ApplicationDispatcher> = .init(.shared)) {
        if let token = Defaults[.accessToken] {
            _accessToken.value = token
        }
        
        self.accessToken = Property(_accessToken)
        self.accessTokenError = _accessTokenError.asObservable()
                .shareReplayLatestWhileConnected()
        
        dispatcher.accessToken
            .do(onNext: { Defaults[.accessToken] = $0 })
            .bindTo(_accessToken)
            .addDisposableTo(disposeBag)
        
        dispatcher.accessTokenError
            .bindTo(_accessTokenError)
            .addDisposableTo(disposeBag)
    }
}
