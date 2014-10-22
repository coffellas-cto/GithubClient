//
//  ReposViewController.swift
//  GithubClient
//
//  Created by Alex G on 21.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit

class ReposViewController: BaseViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

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
        let repo = CoreDataManager.manager.fetchObjectsWithEntityClass(Repo.classForCoder(), predicateFormat: "id == %@", dataSourceArray[indexPath.row])?.first as Repo
        cell.nameLabel.text = "A very long string A very long string A very long string A very long string"//repo.name
        cell.starsCountLabel.text = "\(repo.stargazersCount)"
        cell.languageLabel.text = repo.language
        cell.descriptionLabel.text = repo.descriptionString
        cell.privateLabel.text = repo.isPrivate ? "Private" : "Public"
        cell.avatarImageView.image = nil
        
        // Tag trick (surpasses the loading of image if cell is not on screen)
        cell.tag++
        let currentTag = cell.tag
        
        if let user = repo.user {
            var mustDownload = true
            if let avatarLocalPath = user.avatarLocalPath {
                if let image = UIImage(contentsOfFile: avatarLocalPath) {
                    cell.avatarImageView.image = image
                    mustDownload = false
                }
                else {
                    user.avatarLocalPath = nil
                }
            }
            
            if mustDownload {
                if let avatarUrl = repo.user?.avatarUrl {
                    cell.activityIndicator.startAnimating()
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
                                if cell.tag == currentTag {
                                    UIView.transitionWithView(cell.avatarImageView, duration: 0.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                                        cell.avatarImageView.image = image
                                    }, completion: nil)
                                }
                            }
                        }
                        
                        cell.activityIndicator.stopAnimating()
                    })
                }
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
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
