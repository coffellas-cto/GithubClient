//
//  UserViewController.swift
//  GithubClient
//
//  Created by Alex G on 23.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var table: UITableView!
    
    // MARK: Public Methods
    var user: User!
    
    // MARK: UITableView Delegates Methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("USER_VIEW_CELL", forIndexPath: indexPath) as UserViewCell
        if user == nil {
            return cell
        }
        
        cell.nameLabel.text = user.name
        cell.bioLabel.text = user.bio
        cell.loginLabel.text = user.login
        cell.setReposNumber(user.publicRepos)
        UIHelperGithubClient.setAvatarForUser(user, containerView: cell, imageView: cell.avatarImageView, activityIndicator: cell.avatarActivityIndicator, currentTag: cell.tag)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    // MARK: UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.estimatedRowHeight = 100
        table.rowHeight = UITableViewAutomaticDimension
        table.registerNib(UINib(nibName: "UserViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "USER_VIEW_CELL")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if user == nil {
            return
        }
        
        self.title = user.login + "'s info"
        GithubNetworking.controller.performRequestWithURLString(user.apiUrl, acceptJSONResponse: true) { (data, errorString) -> Void in
            self.user = User.userFromJSONData(data)
            self.table.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
