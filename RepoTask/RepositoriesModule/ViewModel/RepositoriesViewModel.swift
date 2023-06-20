//
//  RepositoriesViewModel.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-19.
//

import Foundation
import Combine

protocol RepositoriesViewModelProtocol {
    var errorPublisher: Published<ErrorMessage?>.Publisher {get}
    var reposSuccessPublisher: Published<Bool?>.Publisher {get}
    var repoUdatePublisher: Published<Bool?>.Publisher {get}
    
    var shouldLoadMore: Bool {set get}
    var repositories: Repositories {set get}
    var repositoriesDictionary: [Int: RepositoryInfo] {set get}

    func getRepos()
    func repoName(index: Int) -> String
    func repoImage(index: Int) -> String
    func repoOwner(index: Int) -> String
    func repoId(index: Int) -> Int
    func loadMoreRepos()
}

class RepositoriesViewModel: RepositoriesViewModelProtocol {
    var shouldLoadMore: Bool = true
    var repositoriesDictionary: [Int : RepositoryInfo] = [:]
    @Published private var error: ErrorMessage? = nil
    var errorPublisher: Published<ErrorMessage?>.Publisher {$error}
    
    @Published private var reposDataSuccess: Bool? = nil
    var reposSuccessPublisher: Published<Bool?>.Publisher {$reposDataSuccess}
    
    @Published private var repositoriesUpdated: Bool? = nil
    var repoUdatePublisher: Published<Bool?>.Publisher {$repositoriesUpdated}
    
    @Published var data: Repositories = []
     
     func fetchData() {
         // Simulate async data fetch
         DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
             self.data.append(Repository(id: 2, nodeID: "2222", name: "moc", fullName: "mock/moo", repoPrivate: false, owner: Owner(login: "moo", id: 2, nodeID: "12312", avatarURL: "", gravatarID: "", url: "", htmlURL: "", type: .user, siteAdmin: false), htmlURL: "", description: "asdas", fork: false, url: "", forksURL: ""))
         }
     }
    
    private var repo: RepoRepositoryProtocol!
    private var cancellabels = Set<AnyCancellable>()

    var repositories: Repositories = []
    private var mainRepositories: Repositories = []
    
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
                self?.mainRepositories = data
                self?.loadMoreRepos()
                self?.reposDataSuccess = true
            })
            .store(in: &cancellabels)
    }

    func repoId(index: Int) -> Int {
        guard repositories.count > 0 else {
            return 0
        }
        return repositories[index].id
    }
    
    func repoName(index: Int) -> String {
        guard repositories.count > 0 else {
            return ""
        }
        return repositories[index].name
    }
    
    func repoOwner(index: Int) -> String {
        guard repositories.count > 0 else {
            return ""
        }
        return repositories[index].owner.login
    }
    
    func repoImage(index: Int) -> String {
            guard repositories.count > 0 else {
                return ""
            }
        return repositories[index].owner.avatarURL
    }
   
    func loadMoreRepos() {
        if !mainRepositories.isEmpty {
            let subRepoData = Array(mainRepositories.prefix(10))
            repositories.append(contentsOf: subRepoData)
            self.mainRepositories = self.mainRepositories.subtracting(subRepoData)
        } else {
            shouldLoadMore = false
        }
        self.repositoriesUpdated = true
    }
}
