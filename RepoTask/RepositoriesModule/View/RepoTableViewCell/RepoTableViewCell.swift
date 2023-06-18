//
//  RepoTableViewCell.swift
//  RepoTask
//
//  Created by John Doe on 2023-06-18.
//

import UIKit

class RepoTableViewCell: UITableViewCell {
    
    let imageHeight: CGFloat = 98
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
