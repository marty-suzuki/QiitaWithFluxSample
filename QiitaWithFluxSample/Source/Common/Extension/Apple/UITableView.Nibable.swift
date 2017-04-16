//
//  UITableView.Nibable.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/16.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit

extension UITableView {
    func register<T: Nibable>(_ type: T.Type) where T: UITableViewCell {
        register(type.nib, forCellReuseIdentifier: type.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: Nibable>(_ type: T.Type, for indexPath: IndexPath) -> T where T: UITableViewCell {
        return dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as! T
    }
}
