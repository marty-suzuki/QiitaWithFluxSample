//
//  ItemsResponse.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/03.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Himotoki

struct ElementsResponse<T> {
    let totalCount: Int
    let elements: [T]
}
