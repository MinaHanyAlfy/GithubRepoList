//
//  RepoRepository.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-18.
//

import Foundation
import Combine

protocol RepoRepositoryProtocol {
    func getRepos() -> AnyPublisher<Repositories, ErorrMessage>
}

class RepoRepository: RepoRepositoryProtocol {
    private var cancellabels = Set<AnyCancellable>()
    
    func getRepos() -> AnyPublisher<Repositories, ErorrMessage> {
        let subject = PassthroughSubject<Repositories, ErorrMessage>()
        let configurationRequest = API.fetchRepos
        
        CombineRequestManager.beginRequest(request: configurationRequest, model: Repositories.self)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    subject.send(completion: .failure(error))
                }
            },receiveValue: { products in
                subject.send(products)
            })
            .store(in: &cancellabels)
        return subject.eraseToAnyPublisher()
    }
}
