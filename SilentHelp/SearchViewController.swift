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
    let silentZoneListkey:String = "silentZoneListUserDefaultKey"
    
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
        print("Place attributions: \(place.attributions)")
        
        //back to the list page
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let listVC = storyBoard.instantiateViewController(withIdentifier: "SilentZoneList") as! SilentZoneListViewController
        let newPlace = Place(name: place.name, address: place.formattedAddress!)
        var newSilentZoneList : [Place]
        if let list = listVC.silentZoneList{
            newSilentZoneList = list
        } else {
            newSilentZoneList = []
        }
        listVC.silentZoneList?.append(newPlace)
        newSilentZoneList.append(newPlace)
        print("new place \(newPlace.name)")
        let defaults = UserDefaults.standard
        defaults.set(NSKeyedArchiver.archivedData(withRootObject: newSilentZoneList), forKey: silentZoneListkey)
        self.present(listVC, animated: true, completion: nil)
        //TODO: want to use this
//        self.navigationController?.pushViewController(listVC, animated: true)
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
