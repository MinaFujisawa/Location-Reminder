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
    let placeListKey: String = "placeListUserDefaultKey"


    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        currentLocation = CLLocation()

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! placeCell

        if let list = placeList {
            cell.whereLabel?.text = list[indexPath.row].placeName
            cell.commentLabel?.text = list[indexPath.row].comment
        }
        return cell
    }

    //MARK: Delete row
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        placeList!.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)

        let defaults = UserDefaults.standard
        if let list = placeList {
            defaults.set(NSKeyedArchiver.archivedData(withRootObject: list), forKey: placeListKey)
        }

        setNotification(placeList: placeList)
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
                    editViewController.test = indexPath.row
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
                content.body = place.comment

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

