//
//  Item.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/02.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Himotoki

struct Item: Decodable {
    let renderedBody: String
    let body: String
    let coediting: Bool
    let createdAt: String
    let id: String
    let `private`: Bool
    let tags: [Tag]
    let title: String
    let updatedAt: String
    let url: String
    let user: User
    
    static func decode(_ e: Extractor) throws -> Item {
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
