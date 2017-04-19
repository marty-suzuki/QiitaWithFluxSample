//
//  RouteStoreCase.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/19.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import XCTest
import RxSwift

class RouteStoreCase: XCTestCase {
    var routeStore: RouteStore!
    var routeDispatcher: AnyObserverDispatcher<RouteDispatcher>!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        #if TEST
            let dispatcher = RouteDispatcher()
            routeDispatcher = AnyObserverDispatcher(dispatcher)
            routeStore = RouteStore(dispatcher: AnyObservableDispatcher(dispatcher))
        #endif
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoginDisplayType() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let loginDisplayTypeExpectation = expectation(description: "loginDisplayType is .root")
        
        let disposeBag = DisposeBag()
        routeStore.login.skip(1)
            .subscribe(onNext: {
                XCTAssertEqual($0, LoginDisplayType.root)
                loginDisplayTypeExpectation.fulfill()
            })
            .addDisposableTo(disposeBag)
        routeDispatcher.login.onNext(.root)
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testSearchDisplayType() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        guard let url = URL(string: "https://github.com") else {
            XCTFail()
            return
        }
        
        let searchDisplayTypeExpectation = expectation(description: "searchDisplayType is .webView")
        
        let disposeBag = DisposeBag()
        routeStore.search.skip(1)
            .subscribe(onNext: {
                let url: URL?
                if case .webView(let value)? = $0 {
                    url = value
                } else {
                    url = nil
                }
                XCTAssertNotNil(url)
                XCTAssertEqual(url?.absoluteString, "https://github.com")
                searchDisplayTypeExpectation.fulfill()
            })
            .addDisposableTo(disposeBag)
        routeDispatcher.search.onNext(.webView(url))
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
