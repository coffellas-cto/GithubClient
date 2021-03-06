//
//  MenuViewController.swift
//  GithubClient
//
//  Created by Alex G on 20.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    // MARK: UITableView Delegates Methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MENU_CELL") as UITableViewCell
        cell.textLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        var title: String!
        switch indexPath.row {
        case 0:
            title = "Search Repos"
        case 1:
            title = "Search Users"
        case 2:
            title = "Profile"
        default:
            title = ""
        }
        cell.textLabel.text = title
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var notificationName: String!
        switch indexPath.row {
        case 0:
            notificationName = kNotificationGithubClientShowRepos
        case 1:
            notificationName = kNotificationGithubClientShowUsers
        case 2:
            notificationName = kNotificationGithubClientShowProfile
        default:
            notificationName = ""
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(notificationName, object: nil)
    }
    
    // MARK: UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
