//
//  Item.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/02.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Foundation

public struct Item: Codable {
    public let renderedBody: String
    public let body: String
    public let coediting: Bool
    public let createdAt: String
    public let id: String
    public let `private`: Bool
    public let tags: [Tag]
    public let title: String
    public let updatedAt: String
    public let url: URL
    public let user: User

    private enum CodingKeys: String, CodingKey {
        case renderedBody = "rendered_body"
        case body
        case coediting
        case createdAt = "created_at"
        case id
        case `private`
        case tags
        case title
        case updatedAt = "updated_at"
        case url
        case user
    }
}

extension Item: TestableCompatible {}

extension Testable where Base == Item.Type {
    public func make(renderedBody: String, body: String, coediting: Bool, createdAt: String, id: String, `private`: Bool, tags: [Tag], title: String, updatedAt: String, url: URL, user: User) -> Item {
        return Item(renderedBody: renderedBody, body: body, coediting: coediting, createdAt: createdAt, id: id, private: `private`, tags: tags, title: title, updatedAt: updatedAt, url: url, user: user)
    }
}
