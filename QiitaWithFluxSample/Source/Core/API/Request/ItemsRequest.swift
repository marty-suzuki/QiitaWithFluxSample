//
//  ItemsRequest.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/02.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import APIKit
import Himotoki

struct ItemsRequest: QiitaRequest {
    let page: Int
    let perPage: Int
    let query: String
    
    let method: HTTPMethod = .get
    let path: String = "/items"
    
    var queryParameters: [String : Any]? {
        return [
            "page" : page,
            "per_page" : perPage,
            "query" : query
        ]
    }
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> ElementsResponse<Item> {
        let items: [Item] = try decodeArray(object)
        guard let totalCountStr = urlResponse.allHeaderFields["Total-Count"] as? String,
              let totalCount = Int(totalCountStr) else {
            throw typeMismatch("Int", actual: urlResponse.allHeaderFields["Total-Count"])
        }
        return ElementsResponse(totalCount: totalCount, elements: items)
    }
}
