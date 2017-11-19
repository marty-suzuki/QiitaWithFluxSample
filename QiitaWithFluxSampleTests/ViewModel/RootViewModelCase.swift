//
//  RootViewModelCase.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/19.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import XCTest
import RxSwift
@testable import QiitaWithFluxSample

class RootViewModelCase: XCTestCase {
    var applicationDispatcher: ApplicationDispatcher!
    var applicationStore: ApplicationStore!
    
    var routeObservableDispatcher: RouteDispatcher!
    var routeObserverDispatcher: RouteDispatcher!
    var routeStore: RouteStore!
    var routeAction: RouteAction!
    
    var rootViewModel: RootViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let routeParentDispatcher = RouteDispatcher.testable.make()
        routeObservableDispatcher = routeParentDispatcher
        routeStore = RouteStore(dispatcher: routeObservableDispatcher)
        routeObserverDispatcher = routeParentDispatcher
        routeAction = RouteAction(dispatcher: routeObserverDispatcher)

        let applicationParentDispatcher = ApplicationDispatcher.testable.make()
        applicationDispatcher = applicationParentDispatcher
        applicationStore = ApplicationStore(dispatcher: applicationParentDispatcher)
        rootViewModel = RootViewModel(applicationStore: applicationStore,
                                      routeAction: routeAction,
                                      routeStore: routeStore)
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
        rootViewModel.login.skip(1)
            .subscribe(onNext: {
                XCTAssertEqual($0, LoginDisplayType.root)
                loginDisplayTypeExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        routeObserverDispatcher.dispatch.login.onNext(.root)
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testLoginDisplayTypeWhenAccessTokenSet() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let loginDisplayTypeExpectation = expectation(description: "loginDisplayType is .root")
        
        let disposeBag = DisposeBag()
        routeObservableDispatcher.register.login
            .subscribe(onNext: {
                XCTAssertEqual($0, LoginDisplayType.root)
                loginDisplayTypeExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        applicationDispatcher.dispatch.accessToken.onNext(nil)
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testSearchDisplayType() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let searchDisplayTypeExpectation = expectation(description: "searchDisplayType is .root")
        
        let disposeBag = DisposeBag()
        rootViewModel.search.skip(1)
            .subscribe(onNext: {
                let isSearchRoot: Bool
                if case .root? = $0 {
                    isSearchRoot = true
                } else {
                    isSearchRoot = false
                }
                XCTAssertTrue(isSearchRoot)
                searchDisplayTypeExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        routeObserverDispatcher.dispatch.search.onNext(.root)
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testSearchDisplayTypeWhenAccessTokenSet() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let searchDisplayTypeExpectation = expectation(description: "searchDisplayType is .root")
        
        let disposeBag = DisposeBag()
        routeObservableDispatcher.register.search
            .subscribe(onNext: {
                let isSearchRoot: Bool
                if case .root = $0 {
                    isSearchRoot = true
                } else {
                    isSearchRoot = false
                }
                XCTAssertTrue(isSearchRoot)
                searchDisplayTypeExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        applicationDispatcher.dispatch.accessToken.onNext("accessToken")
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
