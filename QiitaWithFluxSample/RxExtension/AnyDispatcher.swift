//
//  AnyDispatcher
//  RxAnyDispatcher
//
//  Created by marty-suzuki on 2017/04/01.
//  Copyright © 2017 marty-suzuki. All rights reserved.
//

import RxSwift

public protocol Dispatchable {
    /*
     * typealias StateType = State
     *
     * // Needs to implement `State` enum at each Dispatcher.
     * eunm State {
     *     case isEnabled(Bool)
     *     case isHidden(Bool)
     * }
     */
    associatedtype StateType
    
    static var shared: Self { get }
    
    var observerState: AnyObserver<StateType> { get }
    var observableState: Observable<StateType> { get }
   
    /*
     * // Needs to implement `init()` like this at each Dispatcher.
     * init() {
     *     (self.observerState, self.observableState) = type(of: self).properties()
     * }
     */
    init()
}

public extension Dispatchable {
    static func properties() -> (observer: AnyObserver<StateType>, observable: Observable<StateType>) {
        let state = PublishSubject<StateType>()
        return (state.asObserver(), state.asObservable().shareReplayLatestWhileConnected())
    }
}

// A state observer `Dispatcher`.
public final class AnyObserverDispatcher<DispatcherType: Dispatchable> {
    let state: AnyObserver<DispatcherType.StateType>
    
    init(_ dispatcher: DispatcherType = .shared) {
        self.state = dispatcher.observerState
    }
}

// A state observable `Dispatcher`.
public final class AnyObservableDispatcher<DispatcherType: Dispatchable> {
    let state: Observable<DispatcherType.StateType>
    
    init(_ dispatcher: DispatcherType = .shared) {
        self.state = dispatcher.observableState
    }
}
