//
//  ApplicationActionCase.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/19.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import XCTest
import RxSwift
import QiitaSession
@testable import QiitaWithFluxSample

private class RequestAccessTokenMockSession: QiitaSessionType {
    func send<T : QiitaRequest>(_ request: T) -> Observable<T.Response> {
        let element = AccessTokensResponse.testable.make(cliendId: "clientId",
                                                         scopes: [],
                                                         token: "accessToken") as! T.Response
        return Observable.just(element)
    }
}

class ApplicationActionCase: XCTestCase {
    var applicationAction: ApplicationAction!
    var applicationDispatcher: ApplicationDispatcher!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        let dispatcher = ApplicationDispatcher.testable.make()
        let routeAction = RouteAction(dispatcher: RouteDispatcher.testable.make())
        let mockSession = RequestAccessTokenMockSession()
        let config = Config(baseUrl: "https://github.com",
                            redirectUrl: "https://github.com",
                            clientId: "clientId",
                            clientSecret: "secret")
        applicationDispatcher = dispatcher
        applicationAction = ApplicationAction(dispatcher: dispatcher,
                                              routeAction: routeAction,
                                              session: mockSession,
                                              config: config)
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
        applicationDispatcher.register.accessToken
            .subscribe(onNext: {
                XCTAssertEqual($0, "accessToken")
                requestAccessTokenExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        applicationAction.requestAccessToken(withCode: "code")
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testRemoveAccessToken() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let removeAccessTokenExpectation = expectation(description: "accessToken is nil")
        
        let disposeBag = DisposeBag()
        applicationDispatcher.register.accessToken
            .subscribe(onNext: {
                XCTAssertNil($0)
                removeAccessTokenExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        applicationAction.removeAccessToken()
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
