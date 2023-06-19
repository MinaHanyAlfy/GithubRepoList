//
//  RepositoriesViewModel.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-19.
//

import Foundation
import Combine

protocol RepositoriesViewModelProtocol {
    var errorPublisher: Published<ErorrMessage?>.Publisher {get}
    var reposSuccessPublisher: Published<Bool?>.Publisher {get}
    
    var repos: Repositories {set get}
    func getRepos()
    
//    func getReposCount() -> Int
//    func getReposDataSourceCount() -> Int
//    func getRepo(index: Int) -> Repo
    func repoName(index: Int) -> String
    func repoImage(index: Int) -> String
    func repoOwner(index: Int) -> String
    func repoId(index: Int) -> Int
//    func repoCreatedDate(index: Int) -> String
}

class RepositoriesViewModel: RepositoriesViewModelProtocol {
    
    @Published private var error: ErorrMessage? = nil
    var errorPublisher: Published<ErorrMessage?>.Publisher {$error}
    
    @Published private var reposDataSuccess: Bool? = nil
    var reposSuccessPublisher: Published<Bool?>.Publisher {$reposDataSuccess}
    
    
    private var repo: RepoRepositoryProtocol!
    private var cancellabels = Set<AnyCancellable>()
    
    var repos: Repositories = []
    
    init(repo: RepoRepository = RepoRepository()) {
        self.repo = repo
    }
    
    
    func getRepos() {
        repo.getRepos()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.error = error
                }
            }, receiveValue: { [weak self] data in
                self?.repos = data
                self?.reposDataSuccess = true
            })
            .store(in: &cancellabels)
    }
    
//    func getReposDataSourceCount() -> Int
//    func getRepo(index: Int) -> Repo
    func repoId(index: Int) -> Int {
        guard repos.count > 0 else {
            return 0
        }
        return repos[index].id
    }
    
    func repoName(index: Int) -> String {
        guard repos.count > 0 else {
            return ""
        }
        return repos[index].name
    }
    
    func repoOwner(index: Int) -> String {
        guard repos.count > 0 else {
            return ""
        }
        return repos[index].owner.login
    }
    
    func repoImage(index: Int) -> String {
            guard repos.count > 0 else {
                return ""
            }
        return repos[index].owner.avatarURL
    }
   
//    func repoCreatedDate(index: Int) -> String {
//        guard repos.count > 0 else {
//            return ""
//        }
//    return repos[index].
//    }
}
