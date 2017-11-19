//
//  SearchNavigationController.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/15.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit

final class SearchNavigationController: UINavigationController {
    convenience init() {
        self.init(rootViewController: SearchTopViewController.instantiate())
    }
}
