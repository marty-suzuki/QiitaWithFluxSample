//
//  LoginTopViewModelCase.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/19.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa

class LoginTopViewModelCase: XCTestCase {
    var routeDispatcher: AnyObservableDispatcher<RouteDispatcher>!
    var routeAction: RouteAction!
    var loginButtonTap: AnyObserver<Void>!
    var loginTopViewModel: LoginTopViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        #if TEST
            let routeParentDispatcher = RouteDispatcher()
            routeDispatcher = AnyObservableDispatcher(routeParentDispatcher)
            routeAction = RouteAction(dispatcher: AnyObserverDispatcher(routeParentDispatcher))
            let loginButtonSubject = PublishSubject<Void>()
            loginButtonTap = loginButtonSubject.asObserver()
            loginTopViewModel = LoginTopViewModel(loginButtonTap: ControlEvent<Void>(events: loginButtonSubject),
                                                  routeAction: routeAction)
        #endif
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoginDisplayTypeWhenLoginButtonTap() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let loginDisplayTypeExpectation = expectation(description: "loginDisplayType is .webview")
        
        let disposeBag = DisposeBag()
        routeDispatcher.login
            .subscribe(onNext: {
                XCTAssertEqual($0, LoginDisplayType.webView)
                loginDisplayTypeExpectation.fulfill()
            })
            .addDisposableTo(disposeBag)
        loginButtonTap.onNext()
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}

