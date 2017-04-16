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
    
    let lastItemsRequest: Property<ItemsRequest?>
    private let _lastItemsRequest = Variable<ItemsRequest?>(nil)
    
    let items: Property<[Item]>
    private let _items = Variable<[Item]>([])
    
    let error: Property<Error?>
    private let _error = Variable<Error?>(nil)
    
    private let perPage: Int = 50
    private let searchAction: Action<ItemsRequest, ElementsResponse<Item>>
    private let disposeBag = DisposeBag()
    
    init(session: QiitaSession = .shared,
         routeAction: RouteAction = .shared) {
        self.session = session
        self.routeAction = routeAction
        
        self.lastItemsRequest = Property(_lastItemsRequest)
        self.items = Property(_items)
        self.error = Property(_error)
        
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
            nextQuery = query
            nextPage = 1
            _items.value.removeAll()
        } else if let lastItemsRequest = lastItemsRequest.value {
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
}
