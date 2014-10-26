//
//  ReposViewController.swift
//  GithubClient
//
//  Created by Alex G on 21.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit

class ReposViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Outlets
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Private Properties
    private var isSearching = false
    private var dataSourceArray = [NSNumber]()
    
    // MARK: UITableView Delegate Methods

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("REPO_CELL") as RepoCell
        
        let repo = CoreDataManager.manager.fetchObjectsWithEntityClass(Repo.classForCoder(), predicateFormat: "id == %@", dataSourceArray[indexPath.row])?.first as Repo!
        if repo == nil {
            return cell
        }
        
        cell.nameLabel.text = repo.name
        cell.starsCountLabel.text = "\(repo.stargazersCount)"
        cell.languageLabel.text = repo.language
        cell.languageView.alpha = repo.language == nil ? 0 : 1
        cell.descriptionLabel.text = repo.descriptionString
        cell.privateLabel.text = repo.isPrivate ? "Private" : "Public"
        
        // Tag trick (surpasses the loading of image if cell is not on screen)
        cell.tag++
        let currentTag = cell.tag
        
        if let user = repo.user {
            UIHelperGithubClient.setAvatarForUser(user, containerView: cell, imageView: cell.avatarImageView, activityIndicator: cell.activityIndicator, currentTag: currentTag)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let repo = CoreDataManager.manager.fetchObjectsWithEntityClass(Repo.classForCoder(), predicateFormat: "id == %@", dataSourceArray[indexPath.row])?.first as Repo!
        if repo == nil {
            return
        }
        
        if let URLString = repo.htmlUrl {
            var userInfo = [NSObject : AnyObject]()
            userInfo[kNotificationGithubClientFromVCKey] = self
            userInfo[kNotificationGithubClientToVCKey] = kNotificationGithubClientToVCValueWebView
            userInfo[kNotificationGithubClientURLToOpenKey] = URLString
            NSNotificationCenter.defaultCenter().postNotificationName(kNotificationGithubClientShowWebView, object: nil, userInfo: userInfo)
        }
    }
    
    // MARK: UISearchBarDelegate Methods
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        activityIndicator.startAnimating()
        searchBar.resignFirstResponder()
        if isSearching {
            return
        }
        
        isSearching = true
        GithubNetworking.controller.searchForReposContaining(queryString: searchBar.text) { (responseDic, errorString) -> Void in
            if errorString != nil {
                UIAlertView(title: "Error", message: errorString, delegate: nil, cancelButtonTitle: "OK")
            }
            else {
                if let repos = responseDic!["items"] as? NSArray {
                    self.dataSourceArray = [NSNumber]()
                    for repo in repos {
                        if let repo = repo as? NSDictionary {
                            Repo.repoFromNSDictionary(repo)
                            if let id = repo["id"] as? NSNumber {
                                self.dataSourceArray.append(id)
                            }
                        }
                    }
                    
                    CoreDataManager.manager.saveContext()
                    self.table.reloadData()
                }
            }
            
            self.activityIndicator.stopAnimating()
            self.isSearching = false
        }
    }
    
    // MARK: UIViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Repos"
        
        searchBar.delegate = self
        
        table.delegate = self
        table.dataSource = self
        table.registerNib(UINib(nibName: "RepoCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "REPO_CELL")
        table.estimatedRowHeight = 100
        table.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
