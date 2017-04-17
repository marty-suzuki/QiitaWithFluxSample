//
//  LoginViewModel.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/17.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import RxSwift

final class LoginViewModel {
    let isLoadgin: Property<Bool>
    private let _isLoading = Variable<Bool>(false)
    
    let authorizeRequest = OauthAuthorizeRequest(scope: [.read, .write])
    let authorizeUrl: URL
    
    private let applicationAction: ApplicationAction
    private let disposeBag = DisposeBag()
    
    init(applicationStore: ApplicationStore = .shared,
         applicationAction: ApplicationAction = .shared) {
        self.applicationAction = applicationAction
        self.isLoadgin = Property(_isLoading)
        
        do {
            self.authorizeUrl = try authorizeRequest.createURL()
        } catch let e {
            fatalError("\(e)")
        }
        
        Observable.combineLatest(
                applicationStore.accessToken.asObservable()
                    .shareReplayLatestWhileConnected(),
                applicationStore.accessTokenError
            )
            .map { _ in false }
            .bindTo(_isLoading)
            .addDisposableTo(disposeBag)
    }
    
    func requestAccessToken(withCode code: String) {
        _isLoading.value = true
        applicationAction.requestAccessToken(withCode: code)
    }
}
