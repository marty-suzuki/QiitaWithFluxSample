//
//  ItemsResponse.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/03.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Himotoki

public struct ElementsResponse<T> {
    public let totalCount: Int
    public let elements: [T]
}
