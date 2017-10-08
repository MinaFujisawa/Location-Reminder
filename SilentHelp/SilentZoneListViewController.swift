//
//  SilentZoneListViewController.swift
//  SilentHelp
//
//  Created by MINA FUJISAWA on 2017/10/04.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import GooglePlaces
import UserNotifications

class SilentZoneListViewController: UITableViewController {

//    var silentZoneList : [Place]? = DemoSet.getDemoData()
    var silentZoneList: [Place]? = PlaceSet.getPlaceSetData()
    var locationManager: CLLocationManager?
    public var currentLocation: CLLocation?
    let silentZoneListkey:String = "silentZoneListUserDefaultKey"


    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        currentLocation = CLLocation()

        navigationItem.title = "All Silent Zones"
        
        setNotification(silentZoneList: silentZoneList)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = silentZoneList {
            return list.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! SilentZoneCell

        if let list = silentZoneList {
            cell.nameLabel?.text = list[indexPath.row].name
            cell.addressLabel?.text = list[indexPath.row].address
        }

        return cell
    }

    //MARK: Delete row
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        silentZoneList!.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        let defaults = UserDefaults.standard
        if let list = silentZoneList {
            defaults.set(NSKeyedArchiver.archivedData(withRootObject: list), forKey: silentZoneListkey)
        }
        
        setNotification(silentZoneList: silentZoneList)
    }

    //MARK:segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToEdit" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let list = silentZoneList {
                    let silentZone = list[indexPath.row]
                    let editViewController = segue.destination as! EditTableViewController
                    editViewController.silentZone = silentZone
                    editViewController.list = silentZoneList
                    editViewController.test = indexPath.row
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // unwind segue: EditTableViewController -> SilentZoneListViewController
    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        _ = sender.source as? EditTableViewController
    }
}

extension SilentZoneListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.first
        print("current location \(currentLocation)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            print("OK!")
        }

    }
}

extension SilentZoneListViewController: UNUserNotificationCenterDelegate {
    func setNotification(silentZoneList: [Place]?) {
        // MARK: Notification
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in if granted {print("granted")}
        }
        
        if let list = silentZoneList {
            let radius: CLLocationDistance = 500.0
            let notificationId = "locationNotification"
            
            for (index, place) in list.enumerated() {
                print ("set \(list[index].coordinate)")
                let region = CLCircularRegion(center: place.coordinate, radius: radius,
                                              identifier: notificationId + String(index))
                region.notifyOnEntry = true
                
                //set content
                let content = UNMutableNotificationContent()
                content.title = "My Notification Management Demo"
                content.subtitle = "Timed Notification"
                content.body = "Notification pressed"
                
                //set trigger
                let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
                
                let request = UNNotificationRequest(identifier: "locationNotification", content: content, trigger: trigger)
                
                //Schedule the request
                let center = UNUserNotificationCenter.current()
                center.add(request)
                center.delegate = self
            }
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
        
}

