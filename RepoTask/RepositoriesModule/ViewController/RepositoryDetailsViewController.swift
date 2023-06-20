//
//  RepositoryDetailsViewController.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-19.
//

import UIKit

class RepositoryDetailsViewController: UIViewController {
    private let imageHeight: CGFloat = 80
    
    @IBOutlet weak var repoCreationTitleLabel: UILabel!
    @IBOutlet weak var privateSwitch: UISwitch!
    @IBOutlet weak var publicSwitch: UISwitch!
    @IBOutlet weak var desriptionTextView: UITextView!
    @IBOutlet weak var repoImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoCreationDateLabel: UILabel!
    
    private var repository: Repository?
    private var repositoryInfo: RepositoryInfo?
    var date = Date()
    static func ViewController(repo: Repository, repoInfo: RepositoryInfo?) -> RepositoryDetailsViewController {
        let sb = UIStoryboard(name: "Main", bundle: .main)
        let vc = sb.instantiateViewController(identifier: "RepositoryDetailsViewController", creator: { coder -> RepositoryDetailsViewController? in
            RepositoryDetailsViewController(coder: coder, repositroy: repo, repositoryInfo: repoInfo)
        })
            return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        guard let repository = repository else {
            return
        }
        repoNameLabel.text = repository.name
        ownerNameLabel.text = repository.owner.login
        desriptionTextView.text = repository.description ?? "There's No Description"
        repoImageView.loadImageUsingCacheWithURLString(repository.owner.avatarURL, placeHolder: UIImage(named: "noImageContent+"))
        if repository.repoPrivate {
            privateSwitch.isOn = true
            publicSwitch.isOn = false
        } else {
            privateSwitch.isOn = false
            publicSwitch.isOn = true
        }
       
        if let repositoryInfo = repositoryInfo  {
            date = repositoryInfo.createdAt?.getDateValue ?? Date()
            repoCreationDateLabel.text = date.formatDateSinceCreationDate()
        } else {
            repoCreationDateLabel.isHidden = true
            repoCreationTitleLabel.isHidden = true
            
        }
    }
    
    private func viewSetup() {
        repoImageView.clipsToBounds = true
        repoImageView.layer.cornerRadius = imageHeight / 2
    }
    
    init?(coder: NSCoder, repositroy: Repository, repositoryInfo: RepositoryInfo?) {
        self.repositoryInfo = repositoryInfo
        self.repository = repositroy
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
