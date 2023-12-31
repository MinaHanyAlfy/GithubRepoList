//
//  RepositoryInfo.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-20.
//

import Foundation

// MARK: - RepositoryInfo
struct RepositoryInfo: Codable {
    let login: String?
    let id: Int
    let nodeID, name, company: String?
    let blog: String?
    let location, twitterUsername: String?
    let publicRepos, publicGists, followers, following: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case name, company, blog, location
        case twitterUsername = "twitter_username"
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case followers, following
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
