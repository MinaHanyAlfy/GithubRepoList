//
//  API.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-18.
//

import Foundation

enum API{
    case fetchRepos
}

extension API: EndPoint {
    
    var baseURL: String {
        return "https://api.github.com"
    }
    var urlSubFolder: String {
        return "/repositories"
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
            
        default:
            return [URLQueryItem(name: "", value: nil)]
        }
        
    }
    
    var method: HTTPMethod {
        switch self {
        default :
            return  .get
        }
    }
    
    var body: [String: Any]? {
        switch self{
        default:
            return nil
        }
    }
}
