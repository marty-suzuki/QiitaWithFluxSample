//
//  SearchTopDataSource.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/16.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit
import RxSwift

final class SearchTopDataSource: NSObject {
    let viewModel: SearchTopViewModel
    
    let selectedIndexPath: Observable<IndexPath>
    fileprivate let _selectedIndexPath = PublishSubject<IndexPath>()
    
    fileprivate var canShowLoadingView: Bool {
        return viewModel.hasNext.value && !viewModel.items.value.isEmpty && viewModel.lastItemsRequest.value != nil
    }
    
    init(viewModel: SearchTopViewModel) {
        self.viewModel = viewModel
        self.selectedIndexPath = _selectedIndexPath
    }
    
    func configure(with tableView: UITableView) {
        tableView.register(SearchTopViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
}

extension SearchTopDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(SearchTopViewCell.self, for: indexPath)
        let item = viewModel.items.value[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if canShowLoadingView {
            let view = LoadingView(indicatorStyle: .gray)
            view.isHidden = false
            return view
        }
        return nil
    }
}

extension SearchTopDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        _selectedIndexPath.onNext(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if canShowLoadingView {
            return 44
        }
        return .leastNormalMagnitude
    }
}
