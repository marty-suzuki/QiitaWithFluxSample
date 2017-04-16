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
    @IBOutlet weak var tableView: UITableView!
    
    let searchBar = UISearchBar(frame: .zero)
    
    let viewModel = SearchTopViewModel()
    private(set) lazy var dataSource: SearchTopDataSource = .init(viewModel: self.viewModel)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureSearchBar()
        observeViewModel()
        
        dataSource.configure(with: tableView)
    }
    
    private func configureSearchBar() {
        searchBar.scopeBarBackgroundImage = UIImage()
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
        
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(0.3, scheduler: ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.search(query: text)
            })
            .addDisposableTo(disposeBag)
    }
    
    private func observeViewModel() {
        viewModel.items.changed
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
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
