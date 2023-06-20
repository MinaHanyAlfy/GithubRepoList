//
//  EndPoint.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-18.
//

import Foundation
enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

protocol EndPoint{
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var urlSubFolder: String { get }
    var queryItems: [URLQueryItem] { get }
}
extension EndPoint {
    var urlComponents: URLComponents {
        var components = URLComponents(string: baseURL)!
        components.path = urlSubFolder
        components.queryItems = queryItems
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        var request =  URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
}
