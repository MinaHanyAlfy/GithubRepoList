//
//  CombineRequestManager.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-18.
//

import Foundation
import Combine

fileprivate let requestTimeOut: Double = 60

class CombineRequestManager {
    /// Network Request Manager Using Combine
    /// - Parameters:
    ///   - request: EndPoint Request That have (baseURL-method'POST-GET-PUT-DELETE'-urlSubFolder-queryItems)
    ///   - model: Model is Generic Type To Response Specific & Generic Object (String-JSON-Int-....)
    /// - Returns: Object Or ErrorMessage
    class func beginRequest<T: Decodable>(request: EndPoint, model: T.Type) -> AnyPublisher<T,ErrorMessage> {
        
        guard let url = request.urlComponents.url else {return Fail(error: ErrorMessage.InvalidRequest)
                .eraseToAnyPublisher()
        }
        
        let urlRequest = URLRequest(url: url,cachePolicy: .reloadRevalidatingCacheData,timeoutInterval: requestTimeOut)
        
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) in
                guard let httpURLResponse = response as? HTTPURLResponse else {
                    throw ErrorMessage.InvalidResponse
                }
                
                guard 200...300 ~= httpURLResponse.statusCode else {
                    print("Status Code: ",httpURLResponse.statusCode)
                    throw ErrorMessage.InvalidData
                }
                
                let dataString = String(data: data, encoding: .utf8) ?? ""
                print("\n ________ API \(request) Response ______\n ")
                print("__________ \n \(dataString) \n ___________")
                return data
            }
            .decode(type: model.self, decoder: JSONDecoder())
            .mapError({ error -> ErrorMessage in
                print("\n ________ API \(request) Error ______ ")
                return error as? ErrorMessage ?? .InvalidResponse
            })
            .eraseToAnyPublisher()
    }
    
}
