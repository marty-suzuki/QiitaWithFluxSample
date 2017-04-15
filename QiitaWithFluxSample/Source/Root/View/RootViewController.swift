//
//  RootViewController.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/02.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit
import RxSwift

class RootViewController: UIViewController {

    private (set) var currentViewController: UIViewController? {
        willSet {
            guard let currentViewController = currentViewController else { return }
            currentViewController.willMove(toParentViewController: nil)
            currentViewController.view.removeFromSuperview()
            currentViewController.removeFromParentViewController()
        }
        didSet {
            guard let currentViewController = currentViewController else { return }
            addChildViewController(currentViewController)
            view.addSubview(currentViewController.view, toEdges: .zero)
            currentViewController.didMove(toParentViewController: self)
        }
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        observeRoute()
        
        RouteAction.shared.show(loginDisplayType: .root)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func observeRoute() {
        RouteStore.shared.login
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [unowned self] displayType in
                let loginNC: LoginNavigationController
                if let nc = self.currentViewController as? LoginNavigationController {
                    loginNC = nc
                } else {
                    loginNC = LoginNavigationController()
                    self.currentViewController = loginNC
                }
                switch displayType {
                case .root:
                    if loginNC.topViewController is LoginViewController {
                        return
                    }
                    loginNC.popToRootViewController(animated: true)
                case .webView:
                    if loginNC.topViewController is LoginViewController {
                        return
                    }
                    loginNC.pushViewController(LoginViewController.instantiate(), animated: true)
                }
            })
            .addDisposableTo(disposeBag)
    }
}

