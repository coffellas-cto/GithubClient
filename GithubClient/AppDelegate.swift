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
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow!
    
    // MARK: Private Methods
    private func customizeAppearance() {
        UINavigationBar.appearance().barTintColor = UIColor(red: 226/255, green: 234/255, blue: 237/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor(red: 116/255, green: 134/255, blue: 140/255, alpha: 1)
        let font = UIFont(name: "", size: 12)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 9/255, green: 39/255, blue: 51/255, alpha: 1), NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 116/255, green: 134/255, blue: 140/255, alpha: 1), NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 16)!], forState: .Normal)        
    }
    
    // MARK: UIApplication Life Cycle
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {        
        
        // Set up authentication
        if let accessToken = NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as? String {
            GithubNetworking.controller.setAccessToken(accessToken)
        }
        else {
            dispatch_after(100, dispatch_get_main_queue()) { () -> Void in
                GithubNetworking.controller.requestOAuthAccess()
            }
        }
        
        customizeAppearance()
        
        // Set up Window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.rootViewController = ViewControllersMediator.mediator.containerViewController
        window.makeKeyAndVisible()
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        GithubNetworking.controller.processOAuthCallbackURL(url)
        return false
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
}

