//
//  Nibable.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/16.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit

protocol Nibable: NSObjectProtocol {
    static var nib: UINib { get }
    static var reuseIdentifier: String { get }
}

extension Nibable {
    static var nib: UINib {
        return UINib(nibName: className, bundle: nil)
    }
    static var reuseIdentifier: String {
        return className
    }
}
