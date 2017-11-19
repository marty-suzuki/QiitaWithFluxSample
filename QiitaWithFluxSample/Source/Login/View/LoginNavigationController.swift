//
//  LoginNavigationController.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/12.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit

final class LoginNavigationController: UINavigationController {
    convenience init() {
        self.init(rootViewController: LoginTopViewController.instantiate())
    }
}
