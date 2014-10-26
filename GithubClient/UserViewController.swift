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
    
    // MARK: Public Properties
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
        case 2:
            cell.textLabel.text = "Edit bio"
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
            retVal += 2
        }
        
        return retVal
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var URLString: String? = nil
        
        switch indexPath.row {
        case 1:
            if let URLString = user.htmlUrl {
                var userInfo = [NSObject : AnyObject]()
                userInfo[kNotificationGithubClientFromVCKey] = self
                userInfo[kNotificationGithubClientToVCKey] = kNotificationGithubClientToVCValueWebView
                userInfo[kNotificationGithubClientURLToOpenKey] = URLString
                NSNotificationCenter.defaultCenter().postNotificationName(kNotificationGithubClientShowWebView, object: nil, userInfo: userInfo)
            }
        case 2:
            var alertController = UIAlertController(title: "Change bio", message: nil, preferredStyle: .Alert)
            alertController.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.text = self.user.bio
            })
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                GithubNetworking.controller.updateUserBio((alertController.textFields?.first as UITextField).text, completion: { (responseDic, errorString) -> Void in
                    if errorString != nil {
                        UIAlertView(title: "Error", message: errorString, delegate: nil, cancelButtonTitle: "OK").show()
                        return
                    }
                    
                    UIAlertView(title: "Success", message: "Your bio is updated", delegate: nil, cancelButtonTitle: "OK").show()
                    
                    self.user.bio = responseDic!["bio"] as? String
                    self.table.reloadData()
                })
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        default:
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
                    let g: AnyObject? = responseDic!["bio"]
                    println("aaa: \(g)")
                    self.user = User.userFromNSDictionary(responseDic!)
                    println("aaa: \(self.user.bio)")
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
