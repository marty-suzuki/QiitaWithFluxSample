//
//  LoginViewController.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/11.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit
import RxSwift
import WebKit

class LoginViewController: UIViewController, Storyboardable {
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    let webView: WKWebView = WKWebView(frame: .zero)
    
    private let viewModel = LoginViewModel()
    private(set) lazy var dataSource: LoginViewDataSource = .init(viewModel: self.viewModel)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        observeViewModel()
        configureWebView()
    }
    
    private func configureWebView() {
        webView.navigationDelegate = dataSource
        view.addSubview(webView, toEdges: .zero)
        view.bringSubview(toFront: webView)
        webView.load(URLRequest(url: viewModel.authorizeUrl))
    }

    private func observeViewModel() {
        viewModel.isLoading.asObservable()
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.loadigView(isHidden: $0)
            })
            .addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func loadigView(isHidden: Bool) {
        loadingView.isHidden = isHidden
        if isHidden {
            indicator.stopAnimating()
        } else {
            indicator.startAnimating()
        }
    }
}
