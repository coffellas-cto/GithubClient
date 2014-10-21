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
        
        // Set up Window
        var window = UIWindow(frame: UIScreen.mainScreen().bounds)
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

