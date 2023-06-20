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
    private var repos : Repositories = []
    private var noMoreData: Bool = false
    
    func getRepos() -> AnyPublisher<Repositories, ErrorMessage> {
        let subject = PassthroughSubject<Repositories, ErrorMessage>()
        let configurationRequest = API.fetchRepos
        let publisher = subject.eraseToAnyPublisher()
     
        if repos.count == 0 {
            CombineRequestManager.beginRequest(request: configurationRequest, model: Repositories.self)
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        subject.send(completion: .failure(error))
                    }
                },receiveValue: { repos in
                    self.repos = repos
                    let subRepoData = Array(repos.prefix(10))
                    self.repos = self.repos.subtracting(subRepoData)
                    subject.send(subRepoData)
                    
                    if self.repos.count == 0 {
                        self.noMoreData = true
                    }
                })
                .store(in: &cancellabels)
            return publisher
            
        } else {
//            let subRepoData = Array(repos.prefix(10)) as? Repositories
//            repos = repos.subtracting(subRepoData ?? [])
//            subject
//                .send(subRepoData ?? [])
            return publisher
        }

        
    }
}
