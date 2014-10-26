//
//  UserViewController.swift
//  GithubClient
//
//  Created by Alex G on 23.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit

class UserViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Public Properties
    var selectedImageView: UIImageView? {
        get {
            if let cell = table.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? UserViewCell {
                return cell.avatarImageView
            }
            
            return nil
        }
    }
    var selectedImageViewOrigin: CGPoint {
        get {
            if let cell = table.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? UserViewCell {
                var retVal = table.convertPoint(cell.frame.origin, toView: self.view)
                retVal.x += 8
                retVal.y += 8
                return retVal
            }
            
            return CGPointZero
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var table: UITableView!
    
    // MARK: Public Methods
    var user: User!
    var currentUser = false
    
    // MARK: UITableView Delegates Methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NormalCell") as UITableViewCell
        cell.accessoryType = .DisclosureIndicator
        cell.textLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        switch indexPath.row {
        case 1:
            cell.textLabel.text = currentUser ? "Show your page" : "Show \(user.login)'s page"
        default:
            cell.textLabel.text = "Create new repo"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var retVal = 1
        if user != nil {
            retVal += user.htmlUrl != nil ? 1 : 0
        }
        
        if currentUser {
            retVal++
        }
        
        return retVal
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var URLString: String? = nil
        if indexPath.row == 1 {
            if let URLString = user.htmlUrl {
                var userInfo = [NSObject : AnyObject]()
                userInfo[kNotificationGithubClientFromVCKey] = self
                userInfo[kNotificationGithubClientToVCKey] = kNotificationGithubClientToVCValueWebView
                userInfo[kNotificationGithubClientURLToOpenKey] = URLString
                NSNotificationCenter.defaultCenter().postNotificationName(kNotificationGithubClientShowWebView, object: nil, userInfo: userInfo)
            }
        } else if indexPath.row == 2 {
            let newRepoVC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("NEW_REPO_VC") as NewRepoViewController
            self.navigationController?.pushViewController(newRepoVC, animated: true)
        }
    }

    // MARK: UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.estimatedRowHeight = 100
        table.rowHeight = UITableViewAutomaticDimension
        table.registerNib(UINib(nibName: "UserViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "USER_VIEW_CELL")
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "NormalCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        if !currentUser {
            self.navigationItem.leftBarButtonItem = nil
        }
        
        super.viewWillAppear(animated)
        
        if user == nil {
            if currentUser {
                GithubNetworking.controller.getCurrentUser({ (responseDic, errorString) -> Void in
                    if errorString != nil {
                        UIAlertView(title: "Error", message: errorString, delegate: nil, cancelButtonTitle: "OK").show()
                        return
                    }
                    
                    self.user = User.userFromNSDictionary(responseDic!)
                    self.table.reloadData()
                })
            }
            return
        }
        
        self.title = currentUser ? "Your info" : user.login + "'s info"
        GithubNetworking.controller.performRequestWithURLString(user.apiUrl, acceptJSONResponse: true, completion: { (data, errorString) -> Void in
            self.user = User.userFromJSONData(data)
            self.table.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
