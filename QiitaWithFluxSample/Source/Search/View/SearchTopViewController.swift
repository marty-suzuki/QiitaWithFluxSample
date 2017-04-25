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
        viewModel.observe(textControlProperty: searchBar.rx.text,
                          deleteButtonTap: deleteButton.rx.tap,
                          reachedBottom: tableView.rx.reachedBottom)
        
        searchBar.rx.cancelButtonClicked
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.searchBar.resignFirstResponder()
            })
            .addDisposableTo(disposeBag)
    }
    
    private func observeViewModel() {
        viewModel.noResult
            .bind(to: noResultsLabel.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        viewModel.reloadData
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .addDisposableTo(disposeBag)
        
        viewModel.isFirstLoading
            .observeOn(ConcurrentMainScheduler.instance)
            .map { !$0 }
            .subscribe(onNext: { [weak self] isHidden in
                self?.indicatorContainerView.isHidden = isHidden
                if isHidden {
                    self?.indicatorView.stopAnimating()
                } else {
                    self?.indicatorView.startAnimating()
                }
            })
            .addDisposableTo(disposeBag)
        
        viewModel.keyboardWillShow
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [weak self] info in
                self?.contentViewBottomConstant.constant = info.frame.size.height
                UIView.animate(withDuration: info.animationDuration,
                               delay: 0,
                               options: info.animationCurve,
                               animations: { self?.view.layoutIfNeeded() },
                               completion: nil)
            })
            .addDisposableTo(disposeBag)
        
        viewModel.keyboardWillHide
            .observeOn(ConcurrentMainScheduler.instance)
            .subscribe(onNext: { [weak self] info in
                self?.contentViewBottomConstant.constant = 0
                UIView.animate(withDuration: info.animationDuration,
                               delay: 0,
                               options: info.animationCurve,
                               animations: { self?.view.layoutIfNeeded() },
                               completion: nil)
            })
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
