//
//  QiitaRequestProxy.swift
//  QiitaSession
//
//  Created by 鈴木大貴 on 2017/11/18.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import APIKit

struct QiitaRequestProxy<T: QiitaRequest>: Request {
    // APIKit.Request difinitions
    typealias Response = T.Response

    let baseURL: URL
    var method: HTTPMethod {
        return request.method
    }
    var path: String {
        return request.path
    }
    var parameters: Any? {
        return request.parameters
    }
    var queryParameters: [String : Any]? {
        return request.queryParameters
    }
    var bodyParameters: BodyParameters? {
        return request.bodyParameters
    }
    var headerFields: [String : String] {
        var headerFields = request.headerFields
        if let token = token, !token.isEmpty {
            headerFields["Authorization"] = "Bearer \(token)"
        }
        return headerFields
    }
    var dataParser: DataParser {
        return request.dataParser
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> T.Response {
        return try request.response(from: object, urlResponse: urlResponse)
    }

    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        return try request.intercept(object: object, urlResponse: urlResponse)
    }

    // Proxy Properties
    let request: T
    let token: String?

    init(request: T, token: String?, baseURL: String) throws {
        self.request = request
        self.token = token
        let baseURLString = baseURL + request.apiVersion.rawValue
        self.baseURL = try URL(string: baseURLString)
            ?? { throw QiitaSession.Error.createBaseURLFailed(baseURLString) }()
    }
}
