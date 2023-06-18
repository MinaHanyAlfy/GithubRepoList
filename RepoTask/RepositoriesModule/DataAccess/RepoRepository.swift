//
//  RepoRepository.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-18.
//

import Foundation
import Combine

protocol ProductsRepositoryProtocol {
    func getProducts() -> AnyPublisher<Repo, ErorrMessage>
}

class ProductsRepository: ProductsRepositoryProtocol {
    private var cancellabels = Set<AnyCancellable>()
    
    func getProducts() -> AnyPublisher<Repo, ErorrMessage> {
        let subject = PassthroughSubject<Repo, ErorrMessage>()
        let configurationRequest = API.fetchRepos
        
        CombineRequestManager.beginRequest(request: configurationRequest, model: Repo.self)
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
