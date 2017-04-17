//
//  LoginTopViewController.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/12.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginTopViewController: UIViewController, Storyboardable {

    @IBOutlet weak var loginButton: UIButton!
    
    private(set) lazy var viewModel: LoginTopViewModel = .init(loginButtonTap: self.loginButton.rx.tap)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = viewModel
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
