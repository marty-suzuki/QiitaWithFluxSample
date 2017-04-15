//
//  Property.swift
//  RxProperty
//
//  Created by Yasuhiro Inami on 2017-03-11.
//  Copyright © 2017 Yasuhiro Inami. All rights reserved.
//

import RxSwift
import RxCocoa

/// A get-only `Variable` that is equivalent to ReactiveSwift's `Property`.
///
/// - SeeAlso: https://github.com/ReactiveCocoa/ReactiveSwift/blob/1.1.0/Sources/Property.swift
/// - SeeAlso: https://github.com/ReactiveX/RxSwift/pull/1118 (unmerged)
/// - Note: To avoid this instance being captured accidentally, this class doesn't conform to `ObservableConvertibleType`.
public final class Property<Element> {

    public typealias E = Element

    private let _variable: Variable<E>
    private let _disposeBag: DisposeBag?

    /// Gets current value.
    public var value: E {
        get {
            return _variable.value
        }
    }

    /// Initializes with initial value.
    public init(_ value: E) {
        _variable = Variable(value)
        _disposeBag = nil
    }

    /// Initializes with `Variable` and captures it.
    public init(capturing variable: Variable<E>) {
        _variable = variable
        _disposeBag = nil
    }

    /// Initializes with `Variable` but not capturing it.
    public convenience init(_ variable: Variable<E>) {
        self.init(unsafeObservable: variable.asObservable())
    }

    /// Initializes with `Observable` that must send at least one value synchronously.
    ///
    /// - Warning:
    /// If `unsafeObservable` fails sending at least one value synchronously,
    /// a fatal error would be raised.
    ///
    /// - Warning:
    /// If `unsafeObservable` sends multiple values synchronously,
    /// the last value will be treated as initial value of `Property`.
    public init(unsafeObservable: Observable<E>) {
        let disposeBag = DisposeBag()
        _disposeBag = disposeBag

        let observable = unsafeObservable.shareReplayLatestWhileConnected()
        var initial: E? = nil

        observable
            .subscribe(onNext: { initial = $0 })
            .addDisposableTo(disposeBag)

        guard let initial_ = initial else {
            fatalError("An unsafeObservable promised to send at least one value. Received none.")
        }

        _variable = Variable(initial_)

        observable
            .bindTo(_variable)
            .addDisposableTo(disposeBag)
    }

    /// Observable that synchronously sends current element and then changed elements.
    /// This is same as `ReactiveSwift.Property<T>.producer`.
    public func asObservable() -> Observable<E> {
        return _variable.asObservable()
    }

    /// Observable that only sends changed elements, ignoring current element.
    /// This is same as `ReactiveSwift.Property<T>.signal`.
    public var changed: Observable<E> {
        return asObservable().skip(1)
    }

}
