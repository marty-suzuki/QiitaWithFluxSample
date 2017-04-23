//
//  SearchTopViewModelCase.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/23.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import Action

private class SearchMockSession: SessionType {
    var response: ElementsResponse<Item>!
    var error: Error?
    
    func send<T : QiitaRequest>(_ request: T) -> Observable<T.Response> {
        if let error = error {
            return Observable.error(error)
        }
        return Observable.just(response as! T.Response)
    }
}

class SearchTopViewModelCase: XCTestCase {
    var applicationAction: ApplicationAction!
    var routeAction: RouteAction!
    var searchTopViewModel: SearchTopViewModel!
    
    fileprivate var mockSession: SearchMockSession!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        #if TEST
            routeAction = RouteAction(dispatcher: AnyObserverDispatcher(RouteDispatcher()))
            mockSession = SearchMockSession()
            let config = Config(baseUrl: "https://github.com",
                                redirectUrl: "https://github.com",
                                clientId: "clientId",
                                clientSecret: "secret")
            applicationAction = ApplicationAction(dispatcher: AnyObserverDispatcher(ApplicationDispatcher()),
                                                  routeAction: routeAction,
                                                  session: mockSession,
                                                  config: config)

            searchTopViewModel = SearchTopViewModel(session: mockSession,
                                                    routeAction: routeAction,
                                                    applicationAction: applicationAction)
        #endif
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSearchRequestWhenSuccess() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let user = User(description: nil, facebookId: nil, followeesCount: 10, followersCount: 10, githubLoginName: nil, id: "x12345", itemsCount: 1, linkedinId: nil, location: nil, name: nil, organization: nil, permanentId: 12345, profileImageUrl: "https://hoge.com", twitterScreenName: nil, websiteUrl: nil)
        let item = Item(renderedBody: "renderedBody", body: "body", coediting: false, createdAt: "", id: "x12345", private: false, tags: [], title: "title", updatedAt: "", url: "", user: user)
        mockSession.response = ElementsResponse<Item>(totalCount: 10, elements: [item])
        
        XCTAssertNil(searchTopViewModel.lastItemsRequest.value)
        searchTopViewModel.search(query: "hoge")
        XCTAssertEqual(searchTopViewModel.totalCount.value, 10)
        XCTAssertFalse(searchTopViewModel.items.value.isEmpty)
        XCTAssertEqual(searchTopViewModel.lastItemsRequest.value?.query, "hoge")
        XCTAssertEqual(searchTopViewModel.items.value.first?.id, "x12345")
    }
    
    func testSearchRequestWhenFailure() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        mockSession.error = NSError(domain: "test", code: -9999, userInfo: nil)
        
        XCTAssertNil(searchTopViewModel.lastItemsRequest.value)
        searchTopViewModel.search(query: "error_test")
        XCTAssertEqual(((searchTopViewModel.error.value as? ActionError)?.innerError as NSError?)?.domain, "test")
    }
}

private extension ActionError {
    var innerError: Error? {
        switch self {
        case .underlyingError(let error):
            return error
        case .notEnabled:
            return nil
        }
    }
}
