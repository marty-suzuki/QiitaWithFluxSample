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
import QiitaSession
@testable import QiitaWithFluxSample

private class SearchMockSession: QiitaSessionType {
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
    var selectedIndexPath: PublishSubject<IndexPath>!
    var searchText: PublishSubject<String>!
    var deleteButtonTap: PublishSubject<Void>!
    var reachedBottom: PublishSubject<Void>!
    fileprivate var mockSession: SearchMockSession!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        routeAction = RouteAction(dispatcher: RouteDispatcher.testable.make().dispatcher)
        mockSession = SearchMockSession()
        let config = Config(baseUrl: "https://github.com",
                            redirectUrl: "https://github.com",
                            clientId: "clientId",
                            clientSecret: "secret")
        applicationAction = ApplicationAction(dispatcher: ApplicationDispatcher.testable.make().dispatcher,
                                              routeAction: routeAction,
                                              session: mockSession,
                                              config: config)

        selectedIndexPath = PublishSubject<IndexPath>()
        searchText = PublishSubject<String>()
        deleteButtonTap = PublishSubject<Void>()
        reachedBottom = PublishSubject<Void>()
        searchTopViewModel = SearchTopViewModel(session: mockSession,
                                                routeAction: routeAction,
                                                applicationAction: applicationAction,
                                                selectedIndexPath: selectedIndexPath,
                                                searchText: ControlProperty(values: searchText, valueSink: searchText),
                                                deleteButtonTap: ControlEvent(events: deleteButtonTap),
                                                reachedBottom: reachedBottom)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSearchRequestWhenSuccess() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let user = User.testable.make(description: nil, facebookId: nil, followeesCount: 10, followersCount: 10, githubLoginName: nil, id: "x12345", itemsCount: 1, linkedinId: nil, location: nil, name: nil, organization: nil, permanentId: 12345, profileImageUrl: "https://hoge.com", twitterScreenName: nil, websiteUrl: nil)
        let url = URL(string: "https://github.com/")!
        let item = Item.testable.make(renderedBody: "renderedBody", body: "body", coediting: false, createdAt: "", id: "x12345", private: false, tags: [], title: "title", updatedAt: "", url: url, user: user)
        mockSession.response = ElementsResponse<Item>.testable_make(totalCount: 10, elements: [item])
        
        XCTAssertNil(searchTopViewModel.lastItemsRequest.value)
        searchText.onNext("hoge")

        let expectation = self.expectation(description: "success")
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(self.searchTopViewModel.totalCount.value, 10)
            XCTAssertFalse(self.searchTopViewModel.items.value.isEmpty)
            XCTAssertEqual(self.searchTopViewModel.lastItemsRequest.value?.query, "hoge")
            XCTAssertEqual(self.searchTopViewModel.items.value.first?.id, "x12345")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testSearchRequestWhenFailure() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        mockSession.error = NSError(domain: "test", code: -9999, userInfo: nil)
        
        XCTAssertNil(searchTopViewModel.lastItemsRequest.value)
        searchText.onNext("error_test")

        let expectation = self.expectation(description: "failure")
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
            XCTAssertEqual(((self.searchTopViewModel.error.value as? ActionError)?.innerError as NSError?)?.domain, "test")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
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
