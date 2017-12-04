//
//  ReusableViewProtocol.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/12/05.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit

protocol ReusableViewRegisterType {}
enum RegisterNib: ReusableViewRegisterType {}

protocol ReusableViewProtocol {
    associatedtype RegisterType: ReusableViewRegisterType
    static var identifier: String { get }
    static var nib: UINib? { get }
}

extension ReusableViewProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

extension ReusableViewProtocol where RegisterType == RegisterNib {
    static var nib: UINib? {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static func makeFromNib() -> Self {
        return nib!.instantiate(withOwner: nil, options: nil).first as! Self
    }
}
