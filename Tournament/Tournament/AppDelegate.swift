//
//  AppDelegate.swift
//  Tournament
//
//  Created by Eugene Heckert on 8/3/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        // Override point for customization after application launch.
        
        //If you override a Parse class it will need to be registered in this method
        loadSubclasses()
        
        //First check to make sure that plist is in the project
        if let path = NSBundle.mainBundle().pathForResource("keys", ofType: "plist")
        {
            //Then make sure that the plist contains a NSDictionary
            if let keysDict = NSDictionary(contentsOfFile: path) as? Dictionary<String, String>
            {
                //Make sure that values unwrap to string values.
                var applicationIdString:String  = keysDict["parseApplicationId"]!
                var clientKeyString:String  = keysDict["parseClientKey"]!
                
                //Parse Set ApplicationId requires string values for both the ApplicationId and ClientKey
                //These values tie the app to your Parse App
                Parse.setApplicationId(applicationIdString, clientKey:clientKeyString)
            }
            else
            {
                print("ERROR: The keys.plist does not contain a NSDictionary.")
            }
        }
        else
        {
            print("ERROR: There is currently no keys.plist.")
        }
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication)
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func loadSubclasses()
    {
        User.registerSubclass()
    }

}

