//
//  AddViewController.swift
//  SilentHelp
//
//  Created by MINA FUJISAWA on 2017/10/08.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import GooglePlaces

class AddViewController: UIViewController {
    let placeListKey:String = placeListViewController().placeListKey
    var prediction : GMSAutocompletePrediction?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let prediction = prediction else { return }
//        nameTextField.text = prediction.attributedPrimaryText
//        addressLabel.text = prediction.attributedFullText
    }
}

//For Paulo : ↓They are code that had written in SearchViewController.

////Save to the UserDefaults
//let newPlace = Place(comment: place.name, address: place.formattedAddress!, lat: place.coordinate.latitude, lon: place.coordinate.longitude)
//let listVC = placeListViewController()
//listVC.placeList?.append(newPlace)
//let defaults = UserDefaults.standard
//defaults.set(NSKeyedArchiver.archivedData(withRootObject: listVC.placeList!), forKey: placeListKey)

