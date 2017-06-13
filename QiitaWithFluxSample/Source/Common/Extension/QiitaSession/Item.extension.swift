//
//  Item.extension.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/02.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Himotoki
import QiitaSession

extension Item {
    var createdDateString: String {
        guard let date = Date(ISO8601String: createdAt) else {
            return "----/--/--"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: date)
    }
    var newLineExcludedBody: String {
        return String(body.characters.filter { !" \n\t\r".characters.contains($0) })
    }
}

