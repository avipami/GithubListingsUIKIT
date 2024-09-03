//
//  RepoListingModel.swift
//  GithubListingsUIKit
//
//  Created by Vincent Palma on 2024-08-07.
//

import Foundation

struct Items: Codable {
    let items: [Repository]
}

struct Repository: Codable {
    let id: Int
    let repoName: String
    let owner: Owner
    let url: String
    let createdAt: String
    let updatedAt: String
    let language: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case repoName = "name"
        case owner
        case url = "html_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case language
    }
}

struct Owner: Codable {
    let ownerName: String
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case ownerName = "login"
        case avatarURL = "avatar_url"
    }
}
