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
    private let request = OauthAuthorizeRequest(scope: [.read, .write])
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.navigationDelegate = self
        view.addSubview(webView, toEdges: .zero)
        view.bringSubview(toFront: webView)
        
        let url: URL
        do {
            url = try request.createURL()
        } catch let e {
            fatalError("\(e)")
        }
        webView.load(URLRequest(url: url))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        if url.absoluteString.hasPrefix(Config.shared.redirectUrl) {
            guard
                let URLComponents = URLComponents(string: url.absoluteString),
                let items = URLComponents.queryItems,
                let codeItem = items.filter({ $0.name == "code"}).first,
                let code = codeItem.value
            else {
                fatalError("can not find \"code\" from URL query")
            }
            Observable.combineLatest(
                    ApplicationStore.shared.accessToken.asObservable()
                        .shareReplayLatestWhileConnected(),
                    ApplicationStore.shared.accessTokenError
                )
                .observeOn(ConcurrentMainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    self?.loadigView(isHidden: true)
                })
                .addDisposableTo(disposeBag)
            DispatchQueue.main.async { [weak self] in
                self?.loadigView(isHidden: false)
            }
            ApplicationAction.shared.requestAccessToken(withCode: code)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
