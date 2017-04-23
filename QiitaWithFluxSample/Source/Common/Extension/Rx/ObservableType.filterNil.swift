//
//  ObservableType.filterNil.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/24.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import RxSwift

protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    var value: Wrapped? { return self }
}

extension ObservableType where E: OptionalType {
    func filterNil() -> Observable<E.Wrapped> {
        return filter { $0.value != nil }.map { $0.value! }
    }
}
