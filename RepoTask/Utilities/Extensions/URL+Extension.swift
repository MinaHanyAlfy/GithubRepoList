//
//  URL+Extension.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-20.
//

import Foundation

//MARK: - API Call To Get More Repository Info -
extension URL {
    /// To Get More Repository Info
    /// - Parameter completion: Closure For API Responding
    func cacheUserRepoData(completion: @escaping ( Result<RepositoryInfo, ErrorMessage> )-> Void) {
        let task = URLSession.shared.dataTask(with: self) {
            (data, response, error) in
            // Early exit on error
            if error != nil {
                completion((.failure(.InvalidData)))
            }
            guard let data = data else {
                completion((.failure(.InvalidData)))
                return
            }
            guard let response =  response  as? HTTPURLResponse ,response.statusCode == 200 else{
                completion((.failure(.InvalidResponse)))
                return
            }
            let decoder = JSONDecoder()
            do
            {
                let results = try decoder.decode(RepositoryInfo.self, from: data)
                print(results)
                completion((.success(results)))
                
            }catch {
                print(error)
                completion((.failure(.InvalidData)))
            }
        }
        // Start the call
        task.resume()
    }
}



