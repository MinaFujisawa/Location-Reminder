//
//  SearchViewController.swift
//  SilentHelp
//
//  Created by MINA FUJISAWA on 2017/10/05.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchViewController: UIViewController {
    let silentZoneListkey:String = SilentZoneListViewController().silentZoneListkey
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
    }
}

// Handle the user's selection.
extension SearchViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        
        
        //Add new place
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let listVC = storyBoard.instantiateViewController(withIdentifier: "SilentZoneList") as! SilentZoneListViewController
        let newPlace = Place(name: place.name, address: place.formattedAddress!, lat: place.coordinate.latitude, lon: place.coordinate.longitude)
        var newSilentZoneList : [Place]
        if let list = listVC.silentZoneList{
            newSilentZoneList = list
        } else {
            newSilentZoneList = []
        }
        listVC.silentZoneList?.append(newPlace)
        newSilentZoneList.append(newPlace)
        let defaults = UserDefaults.standard
        defaults.set(NSKeyedArchiver.archivedData(withRootObject: newSilentZoneList), forKey: silentZoneListkey)

        //Back to list page
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "SilentZoneList") as! SilentZoneListViewController
        
        self.present(UINavigationController(rootViewController: destVC), animated: true, completion: {() -> Void in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}
