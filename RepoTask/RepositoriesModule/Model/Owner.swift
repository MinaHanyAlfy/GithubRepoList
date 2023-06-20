//
//  Owner.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-18.
//

import Foundation

// MARK: - Owner
struct Owner: Codable {
    let login: String
    let id: Int
    let nodeID: String
    let avatarURL: String
    let gravatarID: String
    let url, htmlURL: String
    let type: TypeEnum
    let siteAdmin: Bool

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case type
        case siteAdmin = "site_admin"
    }
}

enum TypeEnum: String, Codable {
    case organization = "Organization"
    case user = "User"
}
