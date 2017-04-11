//
//  SearchDispatcher.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/03.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import RxSwift

final class SearchDispatcher: DispatcherType {
    static let shared = SearchDispatcher()
    
    fileprivate let items = PublishSubject<[Item]>()
    fileprivate let error = PublishSubject<Error>()
    fileprivate let lastItemsRequest = PublishSubject<ItemsRequest>()
    
    private init() {}
}

extension AnyObservableDispatcher where Dispatcher: SearchDispatcher {
    var items: Observable<[Item]> {
        return dispatcher.items.asObservable()
    }
    var error: Observable<Error> {
        return dispatcher.error.asObservable()
    }
    var lastItemsRequest: Observable<ItemsRequest> {
        return dispatcher.lastItemsRequest.asObservable()
    }
}

extension AnyObserverDispatcher where Dispatcher: SearchDispatcher {
    var items: AnyObserver<[Item]> {
        return dispatcher.items.asObserver()
    }
    var error: AnyObserver<Error> {
        return dispatcher.error.asObserver()
    }
    var lastItemsRequest: AnyObserver<ItemsRequest> {
        return dispatcher.lastItemsRequest.asObserver()
    }
}
