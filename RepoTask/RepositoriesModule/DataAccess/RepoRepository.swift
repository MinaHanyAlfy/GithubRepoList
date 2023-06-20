//
//  RepoRepository.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-18.
//

import Foundation
import Combine

protocol RepoRepositoryProtocol {
    func getRepos() -> AnyPublisher<Repositories, ErrorMessage>
}

class RepoRepository: RepoRepositoryProtocol {
    private var cancellabels = Set<AnyCancellable>()
    
    func getRepos() -> AnyPublisher<Repositories, ErrorMessage> {
        let subject = PassthroughSubject<Repositories, ErrorMessage>()
        let configurationRequest = API.fetchRepos
        let publisher = subject.eraseToAnyPublisher()

            CombineRequestManager.beginRequest(request: configurationRequest, model: Repositories.self)
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        subject.send(completion: .failure(error))
                    }
                },receiveValue: { repos in
                    subject.send(repos)
                })
                .store(in: &cancellabels)
            return publisher
    }
}
