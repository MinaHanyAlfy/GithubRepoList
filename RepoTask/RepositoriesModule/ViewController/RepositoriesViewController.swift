//
//  RepositoriesViewController.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-18.
//

import UIKit
import Combine
import UIScrollView_InfiniteScroll
import SVProgressHUD
import DZNEmptyDataSet

class RepositoriesViewController: UIViewController {
    
    var viewModel: RepositoriesViewModelProtocol!
    private var cancellabels = Set<AnyCancellable>()
    
    var repoDetailsViewController: RepositoryDetailsViewController?
    private let tableView :UITableView = {
        let tableView = UITableView()
        tableView.registerCell(tableViewCell: RepoTableViewCell.self)
        tableView.allowsSelection = true
        return tableView
    }()
    
    private let searchController : UISearchController = {
        let searchResultViewController = SearchResultViewController()
        let controller = UISearchController(searchResultsController: searchResultViewController)
        controller.searchBar.placeholder = "Search for Repository.."
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RepositoriesViewModel()
        setupTableView()
        loadData()
        searchController.searchResultsUpdater = self
        setupNavigation()
        bindRepos()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setupNavigation() {
        navigationItem.title = "Repositories"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.estimatedRowHeight = 106
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        addInfiniteLoading()
    }
    
    private func addInfiniteLoading() {
        tableView.addInfiniteScroll { [weak self] (tableView) in
            self?.viewModel.loadMoreRepos()
        }
        
        tableView.setShouldShowInfiniteScrollHandler { [weak self] (tableView) -> Bool in
            return self?.viewModel.shouldLoadMore ?? false
        }
    }
    
    private func loadData() {
        SVProgressHUD.show()
        viewModel.getRepos()
    }
    
    private func showError(error: ErrorMessage) {
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: "Error fetching data", message: "Please, Check network, back and try to add again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Thanks", style: .cancel))
        self.present(alert, animated: true)
    }
    
    private func fetchSuccess() {
        self.tableView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    private func updateRepoSuccess() {
        self.tableView.reloadData()
        SVProgressHUD.dismiss()
        tableView.finishInfiniteScroll()
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
                }
            })
            .store(in: &cancellabels)
        
        viewModel.repoUdatePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] updated in
                if updated ?? false {
                    self?.updateRepoSuccess()
                }
            })
            .store(in: &cancellabels)
    }
}

//MARK: - UITableViewDataSource -
extension RepositoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(tableViewCell: RepoTableViewCell.self , forIndexPath: indexPath)
        let index = indexPath.row
        let repo = viewModel.repositories[index]
        cell.cellConfig(name: repo.name, ownerName: repo.owner.login, imageStr: repo.owner.avatarURL, repoLink: repo.owner.url,repositoryInfo: viewModel.repositoriesDictionary[repo.owner.id])
        cell.delegate = self
        
        return cell

    }
    
}

//MARK: - UITableViewDelegate -
extension RepositoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let index = indexPath.row
        let repo = viewModel.repositories[index]
         repoDetailsViewController = RepositoryDetailsViewController.ViewController(repo: repo)
        self.navigationController?.pushViewController(repoDetailsViewController!, animated: true)
    }
}

//MARK: - UISearchResultsUpdating
extension RepositoriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text?.lowercased(),
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 2,
              let resultsController = searchController.searchResultsController as? SearchResultViewController else {
                  return
              }
        let repos = viewModel.repositories
        let reposDictionary = viewModel.repositoriesDictionary
        resultsController.delegate = self
        resultsController.repositoryDictionary = reposDictionary
        resultsController.repositories = repos.filter{$0.fullName.contains(query)}
    }
}

//MARK: - DZNEmptyDataSetSource -
extension RepositoriesViewController: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(systemName: "bell.fill")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let quote = "There's no repositories"
        let attributedQuote = NSMutableAttributedString(string: quote)
        return attributedQuote
    }
}

//MARK: - SearchResultSelectedProtocol -
extension RepositoriesViewController: SearchResultSelectedProtocol {
    func didSelectedCell(repo: Repository) {
        repoDetailsViewController = RepositoryDetailsViewController.ViewController(repo: repo)
        self.navigationController?.pushViewController(repoDetailsViewController!, animated: true)
    }
}

//MARK: - RepoTableViewCellProtocol -
extension RepositoriesViewController: RepoTableViewCellProtocol {
    /// To Update Dictionary to cache repositories info
    /// - Parameter repositoryInfo: repositoryInfo that have more details for repository
    func updateRepositoriesData(repositoryInfo: RepositoryInfo) {
        viewModel.repositoriesDictionary[repositoryInfo.id] = repositoryInfo
    }
}


