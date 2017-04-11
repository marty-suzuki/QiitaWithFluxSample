//
//  SearchStore.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/03.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import RxSwift

final class SearchStore {
    static let shared = SearchStore()
    
    let items: Property<[Item]>
    private let _items = Variable<[Item]>([])
    
    let error: Property<Error?>
    private let _error = Variable<Error?>(nil)
    
    let lastItemsRequest: Property<ItemsRequest?>
    private let _lastItemsRequest = Variable<ItemsRequest?>(nil)
    
    private let disposeBag = DisposeBag()
    
    init(searchDispatcher: AnyObservableDispatcher<SearchDispatcher> = .init(.shared)) {
        self.items = Property(_items)
        self.error = Property(_error)
        self.lastItemsRequest = Property(_lastItemsRequest)
        
        searchDispatcher.items
            .bindTo(_items)
            .addDisposableTo(disposeBag)
        searchDispatcher.error
            .bindTo(_error)
            .addDisposableTo(disposeBag)
        searchDispatcher.lastItemsRequest
            .bindTo(_lastItemsRequest)
            .addDisposableTo(disposeBag)
    }
}
