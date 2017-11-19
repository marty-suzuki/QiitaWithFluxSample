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
@testable import QiitaWithFluxSample

class LoginTopViewModelCase: XCTestCase {
    var routeDispatcher: RouteDispatcher!
    var routeAction: RouteAction!
    var loginButtonTap: AnyObserver<Void>!
    var loginTopViewModel: LoginTopViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.\

        let routeParentDispatcher = RouteDispatcher.testable.make()
        routeDispatcher = routeParentDispatcher
        routeAction = RouteAction(dispatcher: routeParentDispatcher)
        let loginButtonSubject = PublishSubject<Void>()
        loginButtonTap = loginButtonSubject.asObserver()
        loginTopViewModel = LoginTopViewModel(loginButtonTap: ControlEvent<Void>(events: loginButtonSubject),
                                              routeAction: routeAction)
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
        routeDispatcher.register.login
            .subscribe(onNext: {
                XCTAssertEqual($0, LoginDisplayType.webView)
                loginDisplayTypeExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        loginButtonTap.onNext(())
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}

