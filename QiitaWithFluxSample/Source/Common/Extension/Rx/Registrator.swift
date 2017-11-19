//
//  Registrator.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/11/20.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Foundation

protocol RegisterCompatible {
    var registrator: Registrator<Self> { get }
}

extension RegisterCompatible {
    var registrator: Registrator<Self> {
        return Registrator(self)
    }
}

struct Registrator<Base: RegisterCompatible> {
    let base: Base
    
    fileprivate init(_ dispatcher: Base) {
        self.base = dispatcher
    }
}
