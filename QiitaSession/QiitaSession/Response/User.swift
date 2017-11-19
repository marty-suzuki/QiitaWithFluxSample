//
//  User.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/03.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import Foundation

public struct User: Codable {
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

    private enum CodingKeys: String, CodingKey {
        case description
        case facebookId = "facebook_id"
        case followeesCount = "followees_count"
        case followersCount = "followers_count"
        case githubLoginName = "github_login_name"
        case id
        case itemsCount = "items_count"
        case linkedinId = "linkedin_id"
        case location
        case name
        case organization
        case permanentId = "permanent_id"
        case profileImageUrl = "profile_image_url"
        case twitterScreenName = "twitter_screen_name"
        case websiteUrl = "website_url"
    }
}

extension User: TestableCompatible {}
extension Testable where Base == User.Type {
    public func make(description: String?, facebookId: String?, followeesCount: Int, followersCount: Int, githubLoginName: String?, id: String, itemsCount: Int, linkedinId: String?, location: String?, name: String?, organization: String?, permanentId: Int, profileImageUrl: String, twitterScreenName: String?, websiteUrl: String?) -> User {
        return User(description: description, facebookId: facebookId, followeesCount: followeesCount, followersCount: followersCount, githubLoginName: githubLoginName, id: id, itemsCount: itemsCount, linkedinId: linkedinId, location: location, name: name, organization: organization, permanentId: permanentId, profileImageUrl: profileImageUrl, twitterScreenName: twitterScreenName, websiteUrl: websiteUrl)
    }
}
