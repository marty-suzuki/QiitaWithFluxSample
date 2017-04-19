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
    let loadingView = LoadingView(indicatorStyle: .whiteLarge)
    let webView: WKWebView = WKWebView(frame: .zero)
    
    private let viewModel = LoginViewModel()
    private(set) lazy var dataSource: LoginViewDataSource = .init(viewModel: self.viewModel)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureWebView()
        configureLoadingView()
        observeViewModel()
    }
    
    private func configureWebView() {
        webView.navigationDelegate = dataSource
        view.addSubview(webView, toEdges: .zero)
        view.bringSubview(toFront: webView)
        webView.load(URLRequest(url: viewModel.authorizeUrl))
    }
    
    private func configureLoadingView() {
        view.addSubview(loadingView, toEdges: .zero)
        loadingView.isHidden = true
    }

    private func observeViewModel() {
        viewModel.isLoading.changed
            .observeOn(ConcurrentMainScheduler.instance)
            .bind(to: loadingView.rx.isHiddenAndAnimating)
            .addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
