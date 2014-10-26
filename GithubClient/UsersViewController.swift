//
//  UsersViewController.swift
//  GithubClient
//
//  Created by Alex G on 22.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit

class UsersViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Public Properties
    var selectedImageView: UIImageView?
    var selectedImageViewOrigin = CGPointZero
    
    // MARK: Private Properties
    private var headerView: UsersCollectionHeaderView!
    private var isSearching = false
    private var dataSourceArray = [NSNumber]()
    
    // MARK: Outlets
    @IBOutlet var collection: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: UICollectionView Delegates Methods
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCell
        
        let user = CoreDataManager.manager.fetchObjectsWithEntityClass(User.classForCoder(), predicateFormat: "id == %@", dataSourceArray[indexPath.row])?.first as User!
        if user == nil {
            return cell
        }
        
        cell.nameLabel.text = user.login
        
        // Tag trick (surpasses the loading of image if cell is not on screen)
        cell.tag++
        let currentTag = cell.tag
        UIHelperGithubClient.setAvatarForUser(user, containerView: cell, imageView: cell.avatarImageView, activityIndicator: cell.activityIndicator, currentTag: currentTag)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if headerView == nil {
            headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "USERS_COLLECTION_HEADER", forIndexPath: indexPath) as UsersCollectionHeaderView
            headerView.searchBar.delegate = self
        }
        
        return headerView
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let user = CoreDataManager.manager.fetchObjectsWithEntityClass(User.classForCoder(), predicateFormat: "id == %@", dataSourceArray[indexPath.row])?.first as User!
        if user == nil {
            return
        }
        
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as UserCell? {
            selectedImageView = cell.avatarImageView
            selectedImageViewOrigin = collectionView.convertPoint(cell.frame.origin, toView: self.view)
            
            let userVC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("USER_VC") as UserViewController
            userVC.user = user
            self.navigationController?.pushViewController(userVC, animated: true)
        }
    }
    
    // MARK: UISearchBarDelegate Methods
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        activityIndicator.startAnimating()
        searchBar.resignFirstResponder()
        if isSearching {
            return
        }
        
        isSearching = true
        GithubNetworking.controller.searchForUsersContaining(queryString: searchBar.text) { (responseDic, errorString) -> Void in
            if errorString != nil {
                UIAlertView(title: "Error", message: errorString, delegate: nil, cancelButtonTitle: "OK")
            }
            else {
                if let users = responseDic!["items"] as? NSArray {
                    self.dataSourceArray = [NSNumber]()
                    for user in users {
                        if let user = user as? NSDictionary {
                            User.userFromNSDictionary(user)
                            if let id = user["id"] as? NSNumber {
                                self.dataSourceArray.append(id)
                            }
                        }
                    }
                    
                    CoreDataManager.manager.saveContext()
                    self.collection.reloadData()
                }
            }
            
            self.activityIndicator.stopAnimating()
            self.isSearching = false
        }
    }
    
    // MARK: UIViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users"
        
        collection.delegate = self
        collection.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
