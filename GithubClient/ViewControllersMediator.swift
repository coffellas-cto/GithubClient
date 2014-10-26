//
//  ViewControllersMediator.swift
//  GithubClient
//
//  Created by Alex G on 21.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit

class ViewControllersMediator: NSObject, UISplitViewControllerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    // MARK: Private properties
    private var isIPad = false
    private var splitVC: UISplitViewController!
    private var containerVC: UIViewController!
    private var navC: UINavigationController!
    private var menuVC: MenuViewController!
    lazy private var webVC = WebViewController()
    lazy private var reposVC: ReposViewController! = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("REPOS_VC") as ReposViewController
    lazy private var usersVC: UsersViewController! = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("USERS_VC") as UsersViewController
    lazy private var currentUserVC: UserViewController! = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("USER_VC") as UserViewController
    //MARK: Public properties
    var containerViewController: UIViewController! {
        get {
            return containerVC
        }
    }
    
    // MARK: Notifications
    func menuTapped() {
        if !isIPad {
            splitVC.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryOverlay
        }
    }
    
    func showRepos() {
        showVC(reposVC)
    }
    
    func showUsers() {
        showVC(usersVC)
    }
    
    func showProfile() {
        if (currentUserVC.user == nil) && !currentUserVC.currentUser {
            currentUserVC.currentUser = true
        }
        
        showVC(currentUserVC)
    }
    
    func showWebView(notification: NSNotification) {
        if let fromVC = notification.userInfo?[kNotificationGithubClientFromVCKey] as? UIViewController {
            if let toVCString = notification.userInfo?[kNotificationGithubClientToVCKey] as? String {
                if toVCString == kNotificationGithubClientToVCValueWebView {
                    if let URLString = notification.userInfo?[kNotificationGithubClientURLToOpenKey] as? String {
                        webVC.URLString = URLString
                        fromVC.navigationController?.pushViewController(webVC, animated: true)
                    }
                }
            }
        }
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
        navC = UINavigationController(rootViewController: VCToShow)
        navC.delegate = self
        splitVC.viewControllers = [menuVC, navC]
        if !isIPad {
            splitVC.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryHidden
        }
    }
    
    // MARK: Navigation Controller Delegate
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if (fromVC.isKindOfClass(UsersViewController) && toVC.isKindOfClass(UserViewController)) || (fromVC.isKindOfClass(UserViewController) && toVC.isKindOfClass(UsersViewController)) {
            let animationController = AnimationController()
            switch operation {
            case .Push:
                animationController.type = .Push
            case .Pop:
                animationController.type = .Pop
            default:
                return nil
            }
            
            return animationController
        }
        
        return nil
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
        notCenter.addObserver(self, selector: "showWebView:", name: kNotificationGithubClientShowWebView, object: nil)
        
        isIPad = UIDevice.currentDevice().userInterfaceIdiom == .Pad
        
        // Setup main View Controllers
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        menuVC = storyboard.instantiateViewControllerWithIdentifier("MENU_VC") as MenuViewController
        
        // Set up Split ViewController
        splitVC = UISplitViewController()
        showProfile()
        splitVC.delegate = self
        
        if !isIPad {
            splitVC.preferredPrimaryColumnWidthFraction = 0.8
            splitVC.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryOverlay
        }
        else {
            splitVC.preferredPrimaryColumnWidthFraction = 0.25
            splitVC.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        }
        
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