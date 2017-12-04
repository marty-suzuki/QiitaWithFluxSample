//
//  UITableView.ReusableViewProtocol.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/16.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit

extension UITableView {
    typealias ReusableCell = ReusableViewProtocol & UITableViewCell
    
    func register<T: ReusableCell>(_ type: T.Type) {
        register(T.nib, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeueReusableCell<T: ReusableCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
}
