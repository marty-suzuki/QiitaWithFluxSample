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
    @IBOutlet weak var indicatorContainerView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    let searchBar = UISearchBar(frame: .zero)
    
    let viewModel = SearchTopViewModel()
    private(set) lazy var dataSource: SearchTopDataSource = .init(viewModel: self.viewModel)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataSource.configure(with: tableView)
        
        configureSearchBar()
        observeViewModel()
        observeUI()
    }
    
    private func configureSearchBar() {
        searchBar.scopeBarBackgroundImage = UIImage()
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
    }
    
    private func observeUI() {
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(0.3, scheduler: ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.search(query: text)
            })
            .addDisposableTo(disposeBag)
        
        tableView.rx.reachedBottom
            .subscribe(onNext: { [weak self] in
                self?.viewModel.search()
            })
            .addDisposableTo(disposeBag)
        
        deleteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.removeAccessToken()
            })
            .addDisposableTo(disposeBag)
        
        searchBar.rx.cancelButtonClicked
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.searchBar.resignFirstResponder()
            })
            .addDisposableTo(disposeBag)
    }
    
    private func observeViewModel() {
        let itemsObservable = viewModel.items.changed.shareReplayLatestWhileConnected()
        Observable.combineLatest(
                itemsObservable,
                viewModel.searchAction.executing
            ) { $0 }
            .map { !$0.0.isEmpty || $0.1 }
            .bindTo(noResultsLabel.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        let hasNextObservable = viewModel.hasNext.changed.shareReplayLatestWhileConnected()
        Observable.combineLatest(
                itemsObservable,
                hasNextObservable
            ) { $0 }
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .addDisposableTo(disposeBag)
        
        Observable.combineLatest(
                itemsObservable,
                hasNextObservable,
                viewModel.lastItemsRequest.changed.shareReplayLatestWhileConnected()
            ) { $0 }
            .observeOn(ConcurrentMainScheduler.instance)
            .map { !($0.0.isEmpty && $0.1 && $0.2 != nil) }
            .subscribe(onNext: { [weak self] isHidden in
                self?.indicatorContainerView.isHidden = isHidden
                if isHidden {
                    self?.indicatorView.stopAnimating()
                } else {
                    self?.indicatorView.startAnimating()
                }
            })
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
