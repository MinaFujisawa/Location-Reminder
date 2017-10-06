//
//  SilentZoneListViewController.swift
//  SilentHelp
//
//  Created by MINA FUJISAWA on 2017/10/04.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import CoreLocation

class SilentZoneListViewController: UITableViewController {
    


//    var silentZoneList : [Place]? = DemoSet.getDemoData()
    var silentZoneList : [Place]?
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        //MARK: Get data from userDedault
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "silentZoneListUserDefaultKey") != nil{
            silentZoneList = NSKeyedUnarchiver.unarchiveObject(with: defaults.object(forKey: "silentZoneListUserDefaultKey") as! Data) as! [Place]
        } else {
            silentZoneList = [Place]()
        }
        
        navigationItem.title = "All Silent Zones"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    }
    
    //MARK:segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToEdit" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let list = silentZoneList {
                    let silentZone = list[indexPath.row]
                    let editViewController = segue.destination as! EditTableViewController
                    editViewController.silentZone = silentZone
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
extension SilentZoneListViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        locationManager.startUpdatingLocation()
    }
}
