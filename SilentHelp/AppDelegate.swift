//
//  AppDelegate.swift
//  SilentHelp
//
//  Created by MINA FUJISAWA on 2017/10/03.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var backgroundTaskID : UIBackgroundTaskIdentifier = 0


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey("AIzaSyCR4jZptNUzESoaW-f1nASs1ja3aihVdi0")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        self.backgroundTaskID = application.beginBackgroundTask(){
            [weak self] in
            application.endBackgroundTask((self?.backgroundTaskID)!)
            self?.backgroundTaskID = UIBackgroundTaskInvalid
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        application.endBackgroundTask(self.backgroundTaskID)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

