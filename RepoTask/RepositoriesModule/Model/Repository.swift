//
//  Repository.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-18.
//

import Foundation

typealias Repositories = [Repository]

// MARK: - RepoElement
struct Repository: Codable, Equatable {
    let id: Int
    let nodeID, name, fullName: String
    let repoPrivate: Bool
    let owner: Owner
    let htmlURL: String
    let description: String?
    let fork: Bool
    let url, forksURL: String
    

    enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case name
        case fullName = "full_name"
        case repoPrivate = "private"
        case owner
        case htmlURL = "html_url"
        case description, fork, url
        case forksURL = "forks_url"

    }
    
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.id == rhs.id 
    }
}
