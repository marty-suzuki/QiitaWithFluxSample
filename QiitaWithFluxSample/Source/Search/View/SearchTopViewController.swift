//
//  SearchTopViewController.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/02.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit
import RxSwift

class SearchTopViewController: UIViewController, Storyboardable {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SearchAction.shared.search(query: "marty-suzuki")
        
        SearchStore.shared.items.changed
            .subscribe(onNext: {
                print("items =", $0)
            })
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapDelToken(_ sender: Any) {
        ApplicationAction.shared.removeAccessToken()
    }
}
