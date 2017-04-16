//
//  SearchTopViewModel.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/16.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import RxSwift
import Action

final class SearchTopViewModel {
    private let session: QiitaSession
    private let routeAction: RouteAction
    private let applicationAction: ApplicationAction
    
    let lastItemsRequest: Property<ItemsRequest?>
    private let _lastItemsRequest = Variable<ItemsRequest?>(nil)
    
    let items: Property<[Item]>
    private let _items = Variable<[Item]>([])
    
    let totalCount: Property<Int>
    private let _totalCount = Variable<Int>(0)
    
    let error: Property<Error?>
    private let _error = Variable<Error?>(nil)
    
    let hasNext: Property<Bool>
    private let _hasNext = Variable<Bool>(true)
    
    let searchAction: Action<ItemsRequest, ElementsResponse<Item>>
    private let perPage: Int = 20
    private let disposeBag = DisposeBag()
    
    init(session: QiitaSession = .shared,
         routeAction: RouteAction = .shared,
         applicationAction: ApplicationAction = .shared) {
        self.session = session
        self.routeAction = routeAction
        self.applicationAction = applicationAction
        
        self.lastItemsRequest = Property(_lastItemsRequest)
        self.items = Property(_items)
        self.error = Property(_error)
        self.totalCount = Property(_totalCount)
        self.hasNext = Property(_hasNext)
        
        self.searchAction = Action { [weak session] request in
            guard let session = session else { return .empty() }
            return session.send(request)
        }
        
        observeAction()
    }
    
    private func observeAction() {
        searchAction.elements.asObservable()
            .subscribe(
                onNext: { [weak self] response in
                    guard let me = self else { return }
                    me._items.value.append(contentsOf: response.elements)
                    me._totalCount.value = response.totalCount
                    me._hasNext.value = (me._items.value.count < me._totalCount.value) && !response.elements.isEmpty
                },
                onError: { [weak self] error in
                    guard let me = self else { return }
                    me._error.value = error
                }
            )
            .addDisposableTo(disposeBag)
    }
    
    func search(query: String? = nil) {
        let nextQuery: String
        let nextPage: Int
        if let query = query {
            _lastItemsRequest.value = nil
            _items.value.removeAll()
            _hasNext.value = true
            if query.isEmpty {
                return
            }
            nextQuery = query
            nextPage = 1
        } else if hasNext.value, let lastItemsRequest = lastItemsRequest.value {
            nextQuery = lastItemsRequest.query
            nextPage = lastItemsRequest.page + 1
        } else {
            return
        }
        let request = ItemsRequest(page: nextPage, perPage: perPage, query: nextQuery)
        _lastItemsRequest.value = request
        searchAction.execute(request)
    }
    
    func showItem(rowAt indexPath: IndexPath) {
        let item = items.value[indexPath.row]
        guard let url = URL(string: item.url) else { return }
        routeAction.show(searchDisplayType: .webView(url))
    }
    
    func removeAccessToken() {
        applicationAction.removeAccessToken()
    }
}
