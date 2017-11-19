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
    private let _accessToken: Variable<String?>
    
    let accessTokenError: Observable<Error>
    private let _accessTokenError = PublishSubject<Error>()
    
    private let disposeBag = DisposeBag()
    
    init(dispatcher: ApplicationDispatcher = .shared) {
        #if TEST
        _accessToken = Variable(nil)
        #else
        _accessToken = Variable(Defaults[.accessToken])
        #endif
        
        self.accessToken = Property(_accessToken)
        self.accessTokenError = _accessTokenError
        
        dispatcher.register.accessToken
            .do(onNext: { accessToken in
                #if !TEST
                Defaults[.accessToken] = accessToken
                #endif
            })
            .bind(to: _accessToken)
            .disposed(by: disposeBag)
        
        dispatcher.register.accessTokenError
            .bind(to: _accessTokenError)
            .disposed(by: disposeBag)
    }
}
