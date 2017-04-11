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

    let webView: WKWebView = WKWebView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(webView, toEdges: .zero)
        
        let url = OauthAuthorizeRequest(clientId: Config.clientId, scope: [.read, .write], state: "abcd").createURL()
        print("LoginViewController")
        
        
        webView.load(URLRequest(url: url))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
