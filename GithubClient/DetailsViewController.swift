//
//  DetailsViewController.swift
//  GithubClient
//
//  Created by Alex G on 20.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBAction func menuTapped(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "githubClientNotificationShowMenu", object: nil))
    }

    // MARK: UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
