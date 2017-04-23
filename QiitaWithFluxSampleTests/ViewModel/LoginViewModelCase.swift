//
//  LoginViewModelCase.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/20.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa

private class RequestAccessTokenMockSession: SessionType {
    func send<T : QiitaRequest>(_ request: T) -> Observable<T.Response> {
        let element = AccessTokensResponse(cliendId: "clientId",
                                           scopes: [],
                                           token: "accessToken") as! T.Response
        return Observable.just(element)
    }
}

class LoginViewModelCase: XCTestCase {
    var applicationAction: ApplicationAction!
    var applicationObserverDispatcherForAction: AnyObserverDispatcher<ApplicationDispatcher>!
    var applicationObserverDispatcherForStore: AnyObserverDispatcher<ApplicationDispatcher>!
    var applicationObservableDispatcherForStore: AnyObservableDispatcher<ApplicationDispatcher>!
    var applicationStore: ApplicationStore!
    
    var loginViewModel: LoginViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        #if TEST
            let routeAction = RouteAction(dispatcher: AnyObserverDispatcher(RouteDispatcher()))
            let mockSession = RequestAccessTokenMockSession()
            let config = Config(baseUrl: "https://github.com",
                                redirectUrl: "https://github.com",
                                clientId: "clientId",
                                clientSecret: "secret")
            applicationObserverDispatcherForAction = AnyObserverDispatcher(ApplicationDispatcher())
            applicationAction = ApplicationAction(dispatcher: applicationObserverDispatcherForAction,
                                                  routeAction: routeAction,
                                                  session: mockSession,
                                                  config: config)
            let applicationDispatcher = ApplicationDispatcher()
            applicationObserverDispatcherForStore = AnyObserverDispatcher(applicationDispatcher)
            applicationObservableDispatcherForStore = AnyObservableDispatcher(applicationDispatcher)
            applicationStore = ApplicationStore(dispatcher: applicationObservableDispatcherForStore)
            loginViewModel = LoginViewModel(applicationStore: applicationStore,
                                            applicationAction: applicationAction,
                                            config: config)

        #endif
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIsLoading() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        loginViewModel.requestAccessToken(withCode: "code")
        XCTAssertTrue(loginViewModel.isLoading.value)
        
        applicationObserverDispatcherForStore.accessToken.onNext("accessToken2")
        XCTAssertFalse(loginViewModel.isLoading.value)
    }
    
    func testAuthorizeUrl() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(loginViewModel.authorizeUrl.absoluteString.hasPrefix("https://github.com/v2/oauth/authorize?client_id=clientId&scope=read_qiita+write_qiita&state="))
    }
}
