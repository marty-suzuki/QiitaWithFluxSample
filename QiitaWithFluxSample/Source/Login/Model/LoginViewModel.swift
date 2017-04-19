//
//  LoginViewModel.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/17.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import RxSwift

final class LoginViewModel {
    let isLoading: Property<Bool>
    private let _isLoading = Variable<Bool>(false)
    
    let authorizeRequest: OauthAuthorizeRequest
    let authorizeUrl: URL
    
    private let applicationAction: ApplicationAction
    private let disposeBag = DisposeBag()
    
    init(applicationStore: ApplicationStore = .shared,
         applicationAction: ApplicationAction = .shared,
         config: Config = .shared) {
        self.applicationAction = applicationAction
        self.isLoading = Property(_isLoading)
        self.authorizeRequest = OauthAuthorizeRequest(scope: [.read, .write], config: config)
        
        do {
            self.authorizeUrl = try authorizeRequest.createURL()
        } catch let e {
            fatalError("\(e)")
        }
        
        applicationStore.accessToken.asObservable()
            .map { _ in false }
            .bind(to: _isLoading)
            .addDisposableTo(disposeBag)
        applicationStore.accessTokenError
            .map { _ in false }
            .bind(to: _isLoading)
            .addDisposableTo(disposeBag)
    }
    
    func requestAccessToken(withCode code: String) {
        _isLoading.value = true
        applicationAction.requestAccessToken(withCode: code)
    }
}
