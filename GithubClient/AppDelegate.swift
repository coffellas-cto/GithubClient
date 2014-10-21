//
//  AppDelegate.swift
//  GithubClient
//
//  Created by Alex G on 20.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow!
    var splitVC: UISplitViewController!
    var menuVC: MenuViewController!
    var detailsVC: DetailsViewController!
    var detailsNavVC: UINavigationController!
    
    // MARK: Notifications
    func menuTapped() {
        splitVC.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryOverlay
    }

    // MARK: UIApplication Life Cycle
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuTapped", name: "githubClientNotificationShowMenu", object: nil)
        
        // Setup main View Controllers
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        menuVC = storyboard.instantiateViewControllerWithIdentifier("MENU_VC") as MenuViewController
        detailsVC = storyboard.instantiateViewControllerWithIdentifier("DETAILS_VC") as DetailsViewController
        detailsNavVC = UINavigationController(rootViewController: detailsVC)
        
        // Set up Split ViewController
        splitVC = UISplitViewController()
        splitVC.delegate = self
        splitVC.viewControllers = [menuVC, detailsVC]
        splitVC.preferredDisplayMode = UISplitViewControllerDisplayMode.PrimaryOverlay
        splitVC.preferredPrimaryColumnWidthFraction = 0.8
        splitVC.setOverrideTraitCollection(UITraitCollection(horizontalSizeClass: UIUserInterfaceSizeClass.Regular), forChildViewController: menuVC)
        splitVC.setOverrideTraitCollection(UITraitCollection(horizontalSizeClass: UIUserInterfaceSizeClass.Regular), forChildViewController: detailsVC)
        
        // Set up container VirewController that uses Split ViewController
        let containerViewController: UIViewController = UIViewController()
        containerViewController.addChildViewController(splitVC)
        containerViewController.view.addSubview(splitVC.view)
        splitVC.didMoveToParentViewController(containerViewController)
        containerViewController.setOverrideTraitCollection(UITraitCollection(horizontalSizeClass: UIUserInterfaceSizeClass.Regular), forChildViewController: splitVC)
        
        // Set up Window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.rootViewController = containerViewController
        window.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
        CoreDataManager.manager.saveContext()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

