//
//  Dispatcher.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/11/20.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Foundation

protocol DispatchCompatible {
    var dispatch: Dispatch<Self> { get }
}

extension DispatchCompatible {
    var dispatch: Dispatch<Self> {
        return Dispatch(dispatcher: self)
    }
}

struct Dispatch<Dispatcher> {
    let dispatcher: Dispatcher
}

protocol RegisterCompatible {
    var register: Register<Self> { get }
}

extension RegisterCompatible {
    var register: Register<Self> {
        return Register(dispatcher: self)
    }
}

struct Register<Dispatcher> {
    let dispatcher: Dispatcher
}
