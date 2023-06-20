//
//  SearchResultViewController.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-19.
//

import UIKit
import DZNEmptyDataSet

protocol SearchResultSelectedProtocol {
    func didSelectedCell(repo: Repository)
}

class SearchResultViewController: UIViewController {
    var delegate: SearchResultSelectedProtocol?
    var repositories: Repositories = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var repositoryDictionary: [Int: RepositoryInfo] = [:]
    
    private let tableView :UITableView = {
        let tableView = UITableView()
        tableView.registerCell(tableViewCell: RepoTableViewCell.self)
        tableView.allowsSelection = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.emptyDataSetSource = self
        view.addSubview(tableView)
    }
}

//MARK: - UITableViewDataSource
extension SearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(tableViewCell: RepoTableViewCell.self, forIndexPath: indexPath)
        let repository = repositories[indexPath.row]
        cell.cellConfig(name: repository.name, ownerName: repository.owner.login, imageStr: repository.owner.avatarURL, repoLink: repository.owner.url, repositoryInfo: repositoryDictionary[repository.owner.id])
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate
extension SearchResultViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let index = indexPath.row
        let repo = repositories[index]
        self.delegate?.didSelectedCell(repo: repo)
    }
}

//MARK: - DZNEmptyDataSetSource -
extension SearchResultViewController: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(systemName: "bell.fill")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let quote = "There's no repo with your search key words."
        let attributedQuote = NSMutableAttributedString(string: quote)
        return attributedQuote
    }
}
