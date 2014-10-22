//
//  UIHelper.swift
//  GithubClient
//
//  Created by Alex G on 22.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit

class UIHelperGithubClient {
    class func setAvatarForUser(user: User, containerView: UIView, imageView: UIImageView, activityIndicator: UIActivityIndicatorView, currentTag: Int) {
        var mustDownload = true
        if let avatarLocalPath = user.avatarLocalPath {
            if let image = UIImage(contentsOfFile: avatarLocalPath) {
                imageView.image = image
                mustDownload = false
            }
            else {
                user.avatarLocalPath = nil
            }
        }
        
        if mustDownload {
            if let avatarUrl = user.avatarUrl {
                activityIndicator.startAnimating()
                GithubNetworking.controller.downloadResourceWithURLString(avatarUrl, completion: { (localURL, errorString) -> Void in
                    if errorString != nil {
                        println(errorString)
                        return
                    }
                    
                    if (localURL != nil) {
                        user.avatarLocalPath = localURL
                        CoreDataManager.manager.saveContext()
                        if let image = UIImage(contentsOfFile: user.avatarLocalPath!) {
                            // Using tag trick here
                            if containerView.tag == currentTag {
                                UIView.transitionWithView(imageView, duration: 0.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                                    imageView.image = image
                                    }, completion: nil)
                            }
                        }
                    }
                    
                    activityIndicator.stopAnimating()
                })
            }
        }
    }
}