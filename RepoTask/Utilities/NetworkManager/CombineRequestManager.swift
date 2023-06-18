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
    
    class func beginRequest<T: Decodable>(request: EndPoint, model: T.Type) -> AnyPublisher<T,ErorrMessage> {
        
        guard let url = request.urlComponents.url else {return Fail(error: ErorrMessage.InvalidRequest)
                .eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url,cachePolicy: .reloadRevalidatingCacheData,timeoutInterval: requestTimeOut)
        
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) in
                guard let httpURLResponse = response as? HTTPURLResponse else {
                    throw ErorrMessage.InvalidResponse
                }
                
                guard 200...300 ~= httpURLResponse.statusCode else {
                    print("Status Code: ",httpURLResponse.statusCode)
                    throw ErorrMessage.InvalidData
                }
                
                let dataString = String(data: data, encoding: .utf8) ?? ""
                print("\n ________ API \(request) Response ______\n ")
                print("__________ \n \(dataString) \n ___________")
                return data
            }
            .decode(type: model.self, decoder: JSONDecoder())
            .mapError({ error -> ErorrMessage in
                print("\n ________ API \(request) Error ______ ")
                return error as? ErorrMessage ?? .InvalidResponse
            })
            .eraseToAnyPublisher()
    }
    
}
