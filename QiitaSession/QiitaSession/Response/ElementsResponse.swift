//
//  ItemsResponse.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/03.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Foundation

public struct ElementsResponse<T> {
    public let totalCount: Int
    public let elements: [T]
}

extension ElementsResponse {
    public static func testable_make(totalCount: Int, elements: [T]) -> ElementsResponse<T> {
        return ElementsResponse<T>(totalCount: totalCount, elements: elements)
    }
}
