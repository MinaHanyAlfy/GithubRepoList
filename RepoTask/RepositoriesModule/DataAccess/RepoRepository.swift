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
    private var repos : Repositories = []
    private var noMoreData: Bool = false
    func getRepos() -> AnyPublisher<Repositories, ErorrMessage> {
        let subject = PassthroughSubject<Repositories, ErorrMessage>()
        let configurationRequest = API.fetchRepos
        
        if repos.count == 0 && noMoreData == false {
            CombineRequestManager.beginRequest(request: configurationRequest, model: Repositories.self)
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        subject.send(completion: .failure(error))
                    }
                },receiveValue: { repos in
                    self.repos = repos
                    let subRepoDate = Array(repos.prefix(10))
                    self.repos = self.repos.subtracting(subRepoDate)
                    subject.send(subRepoDate)
                    if self.repos.count == 0 {
                        self.noMoreData = true
                    }
                })
                .store(in: &cancellabels)
            return subject.eraseToAnyPublisher()
        } else {
//            AnyPublisher.
            let subRepoDate = Array(repos.prefix(10))
            repos = repos.subtracting(subRepoDate)
            subject.send(subRepoDate)
            if self.repos.count == 0 {
                self.noMoreData = true
            }
            return subject.eraseToAnyPublisher()
        }
    }
}
