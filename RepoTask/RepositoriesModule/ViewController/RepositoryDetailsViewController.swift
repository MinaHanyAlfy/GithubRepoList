//
//  RepositoryDetailsViewController.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-19.
//

import UIKit

class RepositoryDetailsViewController: UIViewController {
    private let imageHeight: CGFloat = 128
    
    @IBOutlet weak var privateSwitch: UISwitch!
    @IBOutlet weak var publicSwitch: UISwitch!
    @IBOutlet weak var desriptionTextView: UITextView!
    @IBOutlet weak var repoImageVIew: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var repoNameLabel: UILabel!
    
    private var repository: Repository?
    
    static func ViewController(repo: Repository) -> RepositoryDetailsViewController {
        let sb = UIStoryboard(name: "Main", bundle: .main)
        let vc = sb.instantiateViewController(identifier: "RepositoryDetailsViewController", creator: { coder -> RepositoryDetailsViewController? in
            RepositoryDetailsViewController(coder: coder, repositroy: repo)
        })
            return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let repository = repository else {
            return
        }
        repoNameLabel.text = repository.name
        ownerNameLabel.text = repository.owner.login
        desriptionTextView.text = repository.description ?? "There's No Description"
        repoImageVIew.loadImageUsingCacheWithURLString(repository.owner.avatarURL, placeHolder: UIImage(named: "noImageContent+"))
        if repository.repoPrivate {
            privateSwitch.isOn = true
            publicSwitch.isOn = false
        } else {
            privateSwitch.isOn = false
            publicSwitch.isOn = true
        }
        
    }
    
    init?(coder: NSCoder, repositroy: Repository) {
        self.repository = repositroy
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}
