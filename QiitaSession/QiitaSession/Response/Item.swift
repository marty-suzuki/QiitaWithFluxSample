//
//  Item.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/02.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Himotoki

public struct Item: Himotoki.Decodable {
    public let renderedBody: String
    public let body: String
    public let coediting: Bool
    public let createdAt: String
    public let id: String
    public let `private`: Bool
    public let tags: [Tag]
    public let title: String
    public let updatedAt: String
    public let url: String
    public let user: User
    
    public static func decode(_ e: Extractor) throws -> Item {
        return try Item(
            renderedBody: e <| "rendered_body",
            body: e <| "body",
            coediting: e <| "coediting",
            createdAt: e <| "created_at",
            id: e <| "id",
            private: e <| "private",
            tags: e.array("tags"),
            title: e <| "title",
            updatedAt: e <| "updated_at",
            url: e <| "url",
            user: e <| "user"
        )
    }
}
