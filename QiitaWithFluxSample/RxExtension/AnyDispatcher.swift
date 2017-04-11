//
//  AnyDispatcher
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/12.
//  Copyright © 2017 marty-suzuki. All rights reserved.
//

import RxSwift

protocol DispatcherType {
    static var shared: Self { get }
}

final class AnyObserverDispatcher<Dispatcher: DispatcherType> {
    let dispatcher: Dispatcher
    init(_ dispatcher: Dispatcher = .shared) {
        self.dispatcher = dispatcher
    }
}

final class AnyObservableDispatcher<Dispatcher: DispatcherType> {
    let dispatcher: Dispatcher
    init(_ dispatcher: Dispatcher = .shared) {
        self.dispatcher = dispatcher
    }
}
