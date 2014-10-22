//
//  ViewControllersMediator.swift
//  GithubClient
//
//  Created by Alex G on 21.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit

class ViewControllersMediator: NSObject, UISplitViewControllerDelegate {
    
    // MARK: Private properties
    private var splitVC: UISplitViewController!
    private var containerVC: UIViewController!
    private var menuVC: MenuViewController!
    lazy private var reposVC: ReposViewController! = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("REPOS_VC") as ReposViewController
    lazy private var usersVC: UsersViewController! = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("USERS_VC") as UsersViewController
    //MARK: Public properties
    var containerViewController: UIViewController! {
        get {
            return containerVC
        }
    }
    
    // MARK: Notifications
    func menuTapped() {
        splitVC.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryOverlay
    }
    
    func showRepos() {
        showVC(reposVC)
    }
    
    func showUsers() {
        showVC(usersVC)
    }
    
    func showProfile() {
    }
    
    // MARK: Class Properties
    class var mediator: ViewControllersMediator {
        struct Struct {
            static var token: dispatch_once_t = 0
            static var instance: ViewControllersMediator! = nil
        }
        dispatch_once(&Struct.token, { () -> Void in
            Struct.instance = ViewControllersMediator()
        })
        return Struct.instance
    }
    
    // MARK: Private Methods
    private func showVC(VCToShow: UIViewController) {
        splitVC.viewControllers = [menuVC, UINavigationController(rootViewController: VCToShow)]
        splitVC.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryHidden
    }
    // MARK: Life Cycle
    
    override init() {
        super.init()
        // Set up notifications
        let notCenter = NSNotificationCenter.defaultCenter()
        notCenter.addObserver(self, selector: "menuTapped", name: kNotificationGithubClientShowMenu, object: nil)
        notCenter.addObserver(self, selector: "showRepos", name: kNotificationGithubClientShowRepos, object: nil)
        notCenter.addObserver(self, selector: "showUsers", name: kNotificationGithubClientShowUsers, object: nil)
        notCenter.addObserver(self, selector: "showProfile", name: kNotificationGithubClientShowProfile, object: nil)
        
        // Setup main View Controllers
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        menuVC = storyboard.instantiateViewControllerWithIdentifier("MENU_VC") as MenuViewController
        
        // Set up Split ViewController
        splitVC = UISplitViewController()
        showUsers()
        splitVC.delegate = self
        splitVC.preferredPrimaryColumnWidthFraction = 0.8
        splitVC.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryOverlay
        
        // Set up container VirewController that uses Split ViewController
        containerVC = UIViewController()
        containerVC.addChildViewController(splitVC)
        containerVC.view.addSubview(splitVC.view)
        splitVC.didMoveToParentViewController(containerVC)
        containerVC.setOverrideTraitCollection(UITraitCollection(horizontalSizeClass: UIUserInterfaceSizeClass.Regular), forChildViewController: splitVC)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}