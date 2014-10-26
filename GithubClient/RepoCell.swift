//
//  RepoCell.swift
//  GithubClient
//
//  Created by Alex G on 21.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {
    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var privateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var languageView: UIView!
    
    func initViews() {
        avatarImageView.image = nil
        nameLabel.text = nil
        starsCountLabel.text = nil
        languageLabel.text = nil
        descriptionLabel.text = nil
        privateLabel.text = nil
        languageView.alpha = 0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initViews()
        languageView.layer.cornerRadius = 3
        avatarImageView.layer.cornerRadius = 8
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initViews()
    }

}
