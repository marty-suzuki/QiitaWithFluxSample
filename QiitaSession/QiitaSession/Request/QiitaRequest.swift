//
//  QiitaRequest.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/02.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import APIKit

public enum QiitaApiVersion: String {
    case v2 = "/v2"
}

public protocol QiitaRequest: Request {
    var apiVersion: QiitaApiVersion { get }
    func response(from data: Data, urlResponse: HTTPURLResponse) throws -> Response
}

final class DecodableDataParser: DataParser {
    var contentType: String? {
        return "application/json"
    }

    func parse(data: Data) throws -> Any {
        return data
    }
}

extension QiitaRequest {
    public var baseURL: URL {
        fatalError("must use QiitaRequestProxy")
    }

    public var dataParser: DataParser {
        return DecodableDataParser()
    }
    
    public var apiVersion: QiitaApiVersion {
        return .v2
    }

    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        let data = try (object as? Data) ?? { throw QiitaSession.Error.isNotData(object) }()
        return try response(from: data, urlResponse: urlResponse)
    }
}

extension QiitaRequest where Response: Decodable {
    public func response(from data: Data, urlResponse: HTTPURLResponse) throws -> Response {
        return try JSONDecoder().decode(Response.self, from: data)
    }
}
