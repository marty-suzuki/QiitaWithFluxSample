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
    @IBOutlet weak var contentViewBottomConstant: NSLayoutConstraint!
    
    let searchBar = UISearchBar(frame: .zero)
    
    let viewModel = SearchTopViewModel()
    private(set) lazy var dataSource: SearchTopDataSource = .init(viewModel: self.viewModel)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        NotificationCenter.default.rx.notification(.UIKeyboardWillShow)
            .map { $0.userInfo }
            .filter { $0 != nil }
            .map { UIKeyboardInfo(info: $0!) }
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [weak self] info in
                guard let info = info else { return }
                self?.contentViewBottomConstant.constant = info.frame.size.height
                UIView.animate(withDuration: info.animationDuration,
                               delay: 0,
                               options: info.animationCurve,
                               animations: { self?.view.layoutIfNeeded() },
                               completion: nil)
            })
            .addDisposableTo(disposeBag)
        
        NotificationCenter.default.rx.notification(.UIKeyboardWillHide)
            .map { $0.userInfo }
            .filter { $0 != nil }
            .map { UIKeyboardInfo(info: $0!) }
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [weak self] info in
                guard let info = info else { return }
                self?.contentViewBottomConstant.constant = 0
                UIView.animate(withDuration: info.animationDuration,
                               delay: 0,
                               options: info.animationCurve,
                               animations: { self?.view.layoutIfNeeded() },
                               completion: nil)
            })
            .addDisposableTo(disposeBag)
    }
    
    private func observeViewModel() {
        let itemsObservable = viewModel.items.changed
        Observable.combineLatest(
                itemsObservable,
                viewModel.searchAction.executing
            ) { $0 }
            .map { !$0.0.isEmpty || $0.1 }
            .bindTo(noResultsLabel.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        let hasNextObservable = viewModel.hasNext.changed
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
                viewModel.lastItemsRequest.changed
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
    }
}
