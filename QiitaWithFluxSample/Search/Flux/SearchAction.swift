//
//  SearchAction.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/03.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import RxSwift

final class SearchAction {
    static let shared = SearchAction()
    
    private let searchDispatcher: AnyObserverDispatcher<SearchDispatcher>
    private let searchStore: SearchStore
    private let session: QiitaSession
    private let disposeBag = DisposeBag()
    
    private let perPage: Int = 50
    
    init(
        searchDispatcher: AnyObserverDispatcher<SearchDispatcher> = .init(.shared),
        searchStore: SearchStore = .shared,
        session: QiitaSession = .shared
    ) {
        self.searchDispatcher = searchDispatcher
        self.searchStore = searchStore
        self.session = session
    }
    
    func search(query: String? = nil) {
        let nextQuery: String
        let nextPage: Int
        if let query = query {
            nextQuery = query
            nextPage = 1
        } else if let lastItemsRequest = searchStore.lastItemsRequest.value {
            nextQuery = lastItemsRequest.query
            nextPage = lastItemsRequest.page + 1
        } else {
            return
        }
        let request = ItemsRequest(page: nextPage, perPage: perPage, query: nextQuery)
        searchDispatcher.state.onNext(.lastItemsRequest(request))
        session.send(request)
            .subscribe(
                onNext: { [unowned self] result in
                    self.searchDispatcher.state.onNext(.items(result.items))
                },
                onError: { [unowned self] error in
                    self.searchDispatcher.state.onNext(.error(error))
                }
            )
            .addDisposableTo(disposeBag)
    }
}
