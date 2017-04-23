//
//  ApplicationActionCase.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/19.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import XCTest
import RxSwift

private class RequestAccessTokenMockSession: SessionType {
    func send<T : QiitaRequest>(_ request: T) -> Observable<T.Response> {
        let element = AccessTokensResponse(cliendId: "clientId",
                                           scopes: [],
                                           token: "accessToken") as! T.Response
        return Observable.just(element)
    }
}

class ApplicationActionCase: XCTestCase {
    var applicationAction: ApplicationAction!
    var applicationDispatcher: AnyObservableDispatcher<ApplicationDispatcher>!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        #if TEST
            let dispatcher = ApplicationDispatcher()
            let routeAction = RouteAction(dispatcher: AnyObserverDispatcher(RouteDispatcher()))
            let mockSession = RequestAccessTokenMockSession()
            let config = Config(baseUrl: "https://github.com",
                                redirectUrl: "https://github.com",
                                clientId: "clientId",
                                clientSecret: "secret")
            applicationDispatcher = AnyObservableDispatcher(dispatcher)
            applicationAction = ApplicationAction(dispatcher: AnyObserverDispatcher(dispatcher),
                                                  routeAction: routeAction,
                                                  session: mockSession,
                                                  config: config)
        #endif
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRequestAccessToken() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let requestAccessTokenExpectation = expectation(description: "accessToken is accessToken")
        
        let disposeBag = DisposeBag()
        applicationDispatcher.accessToken.subscribe(onNext: {
            XCTAssertEqual($0, "accessToken")
            requestAccessTokenExpectation.fulfill()
        })
        .addDisposableTo(disposeBag)
        applicationAction.requestAccessToken(withCode: "code")
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testRemoveAccessToken() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let removeAccessTokenExpectation = expectation(description: "accessToken is nil")
        
        let disposeBag = DisposeBag()
        applicationDispatcher.accessToken.subscribe(onNext: {
            XCTAssertNil($0)
            removeAccessTokenExpectation.fulfill()
        })
        .addDisposableTo(disposeBag)
        applicationAction.removeAccessToken()
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
