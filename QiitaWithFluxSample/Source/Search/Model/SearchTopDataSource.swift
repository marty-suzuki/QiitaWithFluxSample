//
//  SearchTopDataSource.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/16.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit

class SearchTopDataSource: NSObject {
    let viewModel: SearchTopViewModel
    
    init(viewModel: SearchTopViewModel) {
        self.viewModel = viewModel
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
}

extension SearchTopDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.showItem(rowAt: indexPath)
    }
}
