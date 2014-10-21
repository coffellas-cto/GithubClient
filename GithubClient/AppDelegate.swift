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
        self.saveContext()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("GithubClient", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("GithubClient.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain:"YOUR_ERROR_DOMAIN", code:9999, userInfo:dict)
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

