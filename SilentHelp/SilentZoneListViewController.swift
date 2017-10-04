//
//  SilentZoneListViewController.swift
//  SilentHelp
//
//  Created by MINA FUJISAWA on 2017/10/04.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit

class SilentZoneListViewController: UITableViewController {
    
    var silentZoneList : [SilentZone]?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "All Silent Zones"
        
        //FOR DEMO
        let demoSilentZone = SilentZone(name: "Somewhere", address: "450 Granville St, Vancouver, BC")
        let demoSilentZone2 = SilentZone(name: "Somewhere2", address: "450 Granville St, Vancouver, BC")
        silentZoneList?.append(demoSilentZone)
        silentZoneList?.append(demoSilentZone2)
       
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! SilentZoneCell
        
//        cell.nameLabel?.text = silentZoneList[indexPath.row].name
//        cell.addressLabel?.text = silentZoneList[indexPath.row].address

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
        if segue.identifier == "goToEdit" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let list = silentZoneList {
                    let silentZone = list[indexPath.row]
                    let editViewController = segue.destination as! EditTableViewController
                    editViewController.silentZone = silentZone
                }
            }
        }
    }
}
