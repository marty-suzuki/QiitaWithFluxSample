//
//  Testable.swift
//  QiitaSession
//
//  Created by 鈴木大貴 on 2017/11/19.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Foundation

public protocol TestableCompatible {
    static var testable: Testable<Self.Type> { get }
    var testable: Testable<Self> { get }
}

extension TestableCompatible {
    public static var testable: Testable<Self.Type> {
        return Testable(base: self)
    }

    public var testable: Testable<Self> {
        return Testable(base: self)
    }
}

public struct Testable<Base> {
    let base: Base
}
