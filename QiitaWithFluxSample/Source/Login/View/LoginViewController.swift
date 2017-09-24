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
    
    private(set) lazy var viewModel: LoginViewModel = .init(requestAccessTokenWithCode: self.requestAccessTokenWithCode)
    private(set) lazy var dataSource: LoginViewDataSource = .init(viewModel: self.viewModel)
    private let requestAccessTokenWithCode = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = dataSource
        view.addSubview(webView, toEdges: .zero)
        view.bringSubview(toFront: webView)
        webView.load(URLRequest(url: viewModel.authorizeUrl))

        view.addSubview(loadingView, toEdges: .zero)
        loadingView.isHidden = true

        viewModel.isLoading.changed
            .observeOn(ConcurrentMainScheduler.instance)
            .bind(to: loadingView.rx.isHiddenAndAnimating)
            .disposed(by: disposeBag)
        dataSource.requestAccessTokenWithCode
            .bind(to: requestAccessTokenWithCode)
            .disposed(by: disposeBag)
    }
}
