//
//  UserViewCell.swift
//  GithubClient
//
//  Created by Alex G on 23.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit

class UserViewCell: UITableViewCell {

    @IBOutlet weak var reposLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    // MARK: Private Properties
    
    // MARK: Public Methods
    func setReposNumber(number: NSNumber?) {
        if let number = number {
            reposLabel.text = "Repos: \(number)"
        }
        
    }
    // MARK: Private Methods
    private func resetViews() {
        avatarImageView.image = nil
        nameLabel.text = nil
        reposLabel.text = nil
        bioLabel.text = nil
        loginLabel.text = nil
    }
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        resetViews()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetViews()
    }

}
