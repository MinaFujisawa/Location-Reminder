//
//  placeListViewController.swift
//  SilentHelp
//
//  Created by MINA FUJISAWA on 2017/10/04.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import GooglePlaces
import UserNotifications

class PlaceListViewController: UITableViewController {

    var placeList: [Place]? = PlaceSet.getPlaceSetData()
    var locationManager: CLLocationManager?
    public var currentLocation: CLLocation?
    let placeListKey = "placeListUserDefaultKey"
    let cellIdentifier = "ListCell"


    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        currentLocation = CLLocation()
        
        self.navigationItem.hidesBackButton = true
//        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        setNotification(placeList: placeList)
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = placeList {
            return list.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! placeCell

        if let list = placeList {
            cell.whereLabel?.text = list[indexPath.row].placeName
            cell.messageLabel?.text = list[indexPath.row].message
        }
        return cell
    }

    //MARK: Delete row
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // MARK: Actionsheet
        let placeName = placeList?[indexPath.row].placeName
        let alert: UIAlertController = UIAlertController(title: placeName! + "will be deleted", message: nil, preferredStyle:  UIAlertControllerStyle.actionSheet)
        
        // Delete action
        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler:{
            (action: UIAlertAction!) -> Void in
            print("Delete!")
            self.placeList!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            let defaults = UserDefaults.standard
            if let list = self.placeList {
                defaults.set(NSKeyedArchiver.archivedData(withRootObject: list), forKey: self.placeListKey)
            }
            
            self.setNotification(placeList: self.placeList)
        })
        
        // Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("cancelAction")
        })
        
        // Show
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }

    //MARK:segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToEdit" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let list = placeList {
                    let place = list[indexPath.row]
                    let editViewController = segue.destination as! EditViewController
                    editViewController.place = place
                    editViewController.list = placeList
                    editViewController.rowIndex = indexPath.row
                }
            }
        }
        if segue.identifier == "GoToSearch" {
            let searchViewController = segue.destination as! SearchViewController
            searchViewController.currentLocation = self.currentLocation
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // unwind segue: EditTableViewController -> SilentZoneListViewController
    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        _ = sender.source as? EditViewController
    }
}

extension PlaceListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let currentLocation = locations.first
//        print("current location \(currentLocation)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
        }
    }
}

extension PlaceListViewController: UNUserNotificationCenterDelegate {
    func setNotification(placeList: [Place]?) {
        // MARK: Notification
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in if granted { print("granted") }
        }

        if let list = placeList {
            let radius: CLLocationDistance = 500.0
            let notificationId = "locationNotification"

            for (index, place) in list.enumerated() {
                print ("set \(list[index].coordinate)")
                let region = CLCircularRegion(center: place.coordinate, radius: radius,
                                              identifier: notificationId + String(index))
                region.notifyOnEntry = true

                //set content
                let content = UNMutableNotificationContent()
                content.title = "Near " + place.placeName
                content.body = place.message

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
        completionHandler([.alert, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

}

