//
//  ItemsRequest.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/02.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import APIKit

public struct ItemsRequest: QiitaRequest {
    public typealias Response = ElementsResponse<Item>

    public let method: HTTPMethod = .get
    public let path: String = "/items"
    public var queryParameters: [String : Any]? {
        return [
            "page" : page,
            "per_page" : perPage,
            "query" : query
        ]
    }
    
    public let page: Int
    public let perPage: Int
    public let query: String
    
    public init(page: Int, perPage: Int, query: String) {
        self.page = page
        self.perPage = perPage
        self.query = query
    }
    
    public func response(from data: Data, urlResponse: HTTPURLResponse) throws -> Response {
        let decoder = JSONDecoder()
        let items = try decoder.decode([Item].self, from: data)
        guard let totalCountStr = urlResponse.allHeaderFields["Total-Count"] as? String,
              let totalCount = Int(totalCountStr) else {
                throw QiitaSession.Error.typeMismatch("Int", actual: urlResponse.allHeaderFields["Total-Count"])
        }
        return ElementsResponse(totalCount: totalCount, elements: items)
    }
}
