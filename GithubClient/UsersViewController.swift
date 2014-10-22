//
//  UsersViewController.swift
//  GithubClient
//
//  Created by Alex G on 22.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit

class UsersViewController: BaseViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Private Properties
    private var headerView: UsersCollectionHeaderView!
    
    // MARK: Outlets
    @IBOutlet var collection: UICollectionView!
    
    // MARK: UICollectionView Delegates Methods
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if headerView == nil {
            headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "USERS_COLLECTION_HEADER", forIndexPath: indexPath) as UsersCollectionHeaderView
            headerView.searchBar.delegate = self
        }
        
        return headerView
    }
    
    // MARK: UISearchBarDelegate Methods
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
