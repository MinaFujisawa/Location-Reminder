//
//  AppDelegate.swift
//  SilentHelp
//
//  Created by MINA FUJISAWA on 2017/10/03.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import GooglePlaces
import UserNotifications
import NotificationCenter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var backgroundTaskID: UIBackgroundTaskIdentifier = 0


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey("AIzaSyCR4jZptNUzESoaW-f1nASs1ja3aihVdi0")
        
//        // MARK: Notification
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in if granted {print("granted")}
//        }
//
//        if let list = SilentZoneListViewController().silentZoneList {
//            let radius: CLLocationDistance = 500.0
//            let notificationId = "locationNotification"
//
//            for (index, place) in list.enumerated() {
//                print ("set \(list[index].coordinate)")
//                let region = CLCircularRegion(center: place.coordinate, radius: radius,
//                                              identifier: notificationId + String(index))
//                region.notifyOnEntry = true
//
//                //set content
//                let content = UNMutableNotificationContent()
//                content.title = "My Notification Management Demo"
//                content.subtitle = "Timed Notification"
//                content.body = "Notification pressed"
//
//                //set trigger
//                let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
//
//                let request = UNNotificationRequest(identifier: "locationNotification", content: content, trigger: trigger)
//
//                //Schedule the request
//                let center = UNUserNotificationCenter.current()
//                center.add(request)
//                center.delegate = self
//            }
//        }
//
        return true
    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert,.sound])
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        completionHandler()
//    }
}

