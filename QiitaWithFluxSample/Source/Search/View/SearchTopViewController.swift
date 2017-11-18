//
//  SearchTopViewController.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/02.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchTopViewController: UIViewController, Storyboardable {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorContainerView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var contentViewBottomConstant: NSLayoutConstraint!
    
    let searchBar = UISearchBar(frame: .zero)
    
    private(set) lazy var viewModel: SearchTopViewModel = {
        return .init(selectedIndexPath: self.selectedIndexPath,
                     searchText: self.searchBar.rx.text.orEmpty,
                     deleteButtonTap: self.deleteButton.rx.tap,
                     reachedBottom: self.reachedBottom)
    }()
    private(set) lazy var dataSource: SearchTopDataSource = .init(viewModel: self.viewModel)
    
    private let selectedIndexPath = PublishSubject<IndexPath>()
    private let reachedBottom = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.configure(with: tableView)
        searchBar.scopeBarBackgroundImage = UIImage()
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar

        // observe UI
        searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { [weak self] in
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        tableView.rx.reachedBottom
            .bind(to: reachedBottom)
            .disposed(by: disposeBag)

        // observe dataSource
        dataSource.selectedIndexPath
            .bind(to: selectedIndexPath)
            .disposed(by: disposeBag)
        
        // observe viewModel
        viewModel.noResult
            .bind(to: noResultsLabel.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.reloadData
            .bind(to: reloadData)
            .disposed(by: disposeBag)
        viewModel.isFirstLoading
            .map { !$0 }
            .bind(to: isLoadingHidden)
            .disposed(by: disposeBag)
        viewModel.keyboardWillShow
            .bind(to: keyboardWillShow)
            .disposed(by: disposeBag)
        viewModel.keyboardWillHide
            .bind(to: keyboardWillHide)
            .disposed(by: disposeBag)
    }
    
    private var reloadData: AnyObserver<Void> {
        return Binder(self) { me, _ in
            me.tableView.reloadData()
        }.asObserver()
    }
    
    private var isLoadingHidden: AnyObserver<Bool> {
        return Binder(self) { me, isHidden in
            me.indicatorContainerView.isHidden = isHidden
            if isHidden {
                me.indicatorView.stopAnimating()
            } else {
                me.indicatorView.startAnimating()
            }
        }.asObserver()
    }
    
    private var keyboardWillShow: AnyObserver<UIKeyboardInfo> {
        return Binder(self) { me, info in
            me.contentViewBottomConstant.constant = info.frame.size.height
            UIView.animate(withDuration: info.animationDuration,
                           delay: 0,
                           options: info.animationCurve,
                           animations: { me.view.layoutIfNeeded() },
                           completion: nil)
        }.asObserver()
    }
    
    private var keyboardWillHide: AnyObserver<UIKeyboardInfo> {
        return Binder(self) { me, info in
            me.contentViewBottomConstant.constant = 0
            UIView.animate(withDuration: info.animationDuration,
                           delay: 0,
                           options: info.animationCurve,
                           animations: { me.view.layoutIfNeeded() },
                           completion: nil)
        }.asObserver()
    }
}
