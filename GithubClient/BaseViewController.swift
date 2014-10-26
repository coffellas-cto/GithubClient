//
//  DetailsViewController.swift
//  GithubClient
//
//  Created by Alex G on 20.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UISearchBarDelegate {
    func menuTapped(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: kNotificationGithubClientShowMenu, object: nil))
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text.valid {
            return true
        }
        
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.currentDevice().userInterfaceIdiom != .Pad {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: .Plain, target: self, action: "menuTapped:")
        }
    }
}
