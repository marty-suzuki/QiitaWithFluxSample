//
//  User.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/03.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Himotoki

struct User: Decodable {
    let `description`: String?
    let facebookId: String?
    let followeesCount: Int
    let followersCount: Int
    let githubLoginName: String?
    let id: String
    let itemsCount: Int
    let linkedinId: String?
    let location: String?
    let name: String?
    let organization: String?
    let permanentId: Int
    let profileImageUrl: String
    let twitterScreenName: String?
    let websiteUrl: String?
    
    static func decode(_ e: Extractor) throws -> User {
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
