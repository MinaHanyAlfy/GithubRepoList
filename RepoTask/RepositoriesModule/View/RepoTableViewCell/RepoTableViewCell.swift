//
//  RepoTableViewCell.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-18.
//

import UIKit

protocol RepoTableViewCellProtocol: AnyObject {
    func updateRepositoriesData(repositoryInfo: RepositoryInfo)
}

class RepoTableViewCell: UITableViewCell {
    
    let imageHeight: CGFloat = 48
    var delegate: RepoTableViewCellProtocol?
    private var date: Date = Date()
    @IBOutlet weak var repoImageView: UIImageView!
    @IBOutlet weak var repoOwnerLabel: UILabel!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoCreationDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellView()
    }
    
    private func setupCellView() {
        repoImageView.clipsToBounds = true
        repoImageView.layer.cornerRadius = imageHeight / 2.0
    }
    
    func cellConfig(name: String, ownerName: String, imageStr: String, repoLink: String, repositoryInfo: RepositoryInfo? ) {
        repoNameLabel.text = name
        repoOwnerLabel.text = ownerName
        
        //MARK:  - To Download and Cache Image -
        repoImageView.loadImageUsingCacheWithURLString(imageStr, placeHolder: UIImage(named: "noImageContent+"))
        
        //MARK: - To Get More Repository Info -
        if repositoryInfo != nil {
            date = repositoryInfo?.createdAt?.getDateValue ?? Date()
            self.repoCreationDateLabel.text = date.formatDateSinceCreationDate()
            

        } else {
            if let repoUrl = URL(string: repoLink) {
                repoUrl.cacheUserRepoData { result in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let repo):
                        self.delegate?.updateRepositoriesData(repositoryInfo: repo)
                        DispatchQueue.main.async {
                            self.date = repo.createdAt?.getDateValue ?? Date()
                            self.repoCreationDateLabel.text = self.date.formatDateSinceCreationDate()
                        }
                    }
                }
                
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        repoImageView.image = UIImage(named: "noImageContent+")
        repoNameLabel.text = ""
        repoOwnerLabel.text = ""
        repoCreationDateLabel.text = ""
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}

