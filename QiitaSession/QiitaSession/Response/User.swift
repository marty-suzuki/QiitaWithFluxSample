//
//  User.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/03.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Himotoki

public struct User: Decodable {
    public let `description`: String?
    public let facebookId: String?
    public let followeesCount: Int
    public let followersCount: Int
    public let githubLoginName: String?
    public let id: String
    public let itemsCount: Int
    public let linkedinId: String?
    public let location: String?
    public let name: String?
    public let organization: String?
    public let permanentId: Int
    public let profileImageUrl: String
    public let twitterScreenName: String?
    public let websiteUrl: String?
    
    public static func decode(_ e: Extractor) throws -> User {
        return try User(
            description: e <|? "description",
            facebookId: e <|? "facebook_id",
            followeesCount: e <| "followees_count",
            followersCount: e <| "followers_count",
            githubLoginName: e <|? "github_login_name",
            id: e <| "id",
            itemsCount: e <| "items_count",
            linkedinId: e <|? "linkedin_id",
            location: e <|? "location",
            name: e <|? "name",
            organization: e <|? "organization",
            permanentId: e <| "permanent_id",
            profileImageUrl: e <| "profile_image_url",
            twitterScreenName: e <|? "twitter_screen_name",
            websiteUrl: e <|? "website_url"
        )
    }
}
