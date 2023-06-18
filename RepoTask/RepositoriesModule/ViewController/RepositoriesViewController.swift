//
//  RepositoriesViewController.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-18.
//

import UIKit

class RepositoriesViewController: UIViewController {
    private let tableView :UITableView = {
        let tableView = UITableView()
        tableView.registerCell(tableViewCell: RepoTableViewCell.self)
        tableView.allowsSelection = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.estimatedRowHeight = 106
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: - UITableViewDataSource -
extension RepositoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(tableViewCell: RepoTableViewCell.self , forIndexPath: indexPath)

        return cell

    }
    
}

//MARK: - UITableViewDelegate -
extension RepositoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Open Repository Details
    }
}
