//
//  Storyboardable.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/12.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit

protocol Storyboardable {}

extension Storyboardable where Self: UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
    
    static func instantiate() -> Self {
        return UIStoryboard(name: identifier, bundle: nil)
                .instantiateViewController(withIdentifier: identifier) as! Self
    }
}
