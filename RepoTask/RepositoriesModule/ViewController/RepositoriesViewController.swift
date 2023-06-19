//
//  RepositoriesViewController.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-18.
//

import UIKit
import Combine

class RepositoriesViewController: UIViewController {
    
    var viewModel: RepositoriesViewModelProtocol!
    private var cancellabels = Set<AnyCancellable>()

    private let tableView :UITableView = {
        let tableView = UITableView()
        tableView.registerCell(tableViewCell: RepoTableViewCell.self)
        tableView.allowsSelection = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RepositoriesViewModel()
        setupTableView()
        loadDate()
        bindRepos()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func loadDate() {
        viewModel.getRepos()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.estimatedRowHeight = 106
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func showError(error: ErorrMessage) {
        let alert = UIAlertController(title: "Error fetching data", message: "Please, Check network, back and try to add again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Thanks", style: .cancel))
        self.present(alert, animated: true)
    }
    
    private func fetchSuccess() {
        self.tableView.reloadData()
    }
}

//MARK: - For Binding Data -
extension RepositoriesViewController {
    func bindRepos() {
        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] error in
                if let error = error {
                    self?.showError(error: error)
                }
            })
            .store(in: &cancellabels)
        
        viewModel.reposSuccessPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] fetched in
                if fetched ?? false {
                    self?.fetchSuccess()
                    print("You can proceed now")
                }
            })
            .store(in: &cancellabels)
    }
}

//MARK: - UITableViewDataSource -
extension RepositoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(tableViewCell: RepoTableViewCell.self , forIndexPath: indexPath)
        let index = indexPath.row
        let repo = viewModel.repos[index]
        cell.cellConfig(name: repo.name, ownerName: repo.owner.login, imageStr: repo.owner.avatarURL, repoLink: repo.owner.url)
        return cell

    }
    
}

//MARK: - UITableViewDelegate -
extension RepositoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Open Repository Details
    }
}
