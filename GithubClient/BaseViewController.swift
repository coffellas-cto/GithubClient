//
//  DetailsViewController.swift
//  GithubClient
//
//  Created by Alex G on 20.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    func menuTapped(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: kNotificationGithubClientShowMenu, object: nil))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .Plain, target: self, action: "menuTapped:")
    }
}
