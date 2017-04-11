//
//  Storyboardable.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/12.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit

protocol Storyboardable: NSObjectProtocol {
}

extension Storyboardable {
    static func instantiate() -> Self {
        return UIStoryboard(name: className, bundle: nil)
                .instantiateViewController(withIdentifier: className) as! Self
    }
}
