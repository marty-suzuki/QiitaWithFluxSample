//
//  SearchDispatcher.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/03.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import RxSwift

final class SearchDispatcher: Dispatchable {
    enum State {
        case items([Item])
        case error(Error)
        case lastItemsRequest(ItemsRequest)
    }
    
    static let shared = SearchDispatcher()
    
    let observerState: AnyObserver<State>
    let observableState: Observable<State>
    
    required init() {
        (self.observerState, self.observableState) = SearchDispatcher.properties()
    }
}
