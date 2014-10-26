//
//  UserCell.swift
//  GithubClient
//
//  Created by Alex G on 22.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    func initViews() {
        avatarImageView.image = nil
        nameLabel.text = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initViews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initViews()
        avatarImageView.layer.cornerRadius = 8
    }
    
}
