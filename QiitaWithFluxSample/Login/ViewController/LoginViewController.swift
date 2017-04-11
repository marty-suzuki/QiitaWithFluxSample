//
//  LoginViewController.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/11.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit
import RxSwift
import SafariServices

class LoginViewController: UIViewController, Storyboardable {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let url = OauthAuthorizeRequest(clientId: Config.clientId, scope: [.read, .write], state: "abcd").createURL()
//        
//        print(url)
//        
//        let viewController = SFSafariViewController(url: url)
//        present(viewController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
