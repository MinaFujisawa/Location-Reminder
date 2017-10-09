//
//  SearchViewController.swift
//  SilentHelp
//
//  Created by MINA FUJISAWA on 2017/10/05.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var fetcher: GMSAutocompleteFetcher?
    var currentLocation: CLLocation?
    var locationManager: CLLocationManager?
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchFooter: SearchFooter!
    
    let searchController = UISearchController(searchResultsController: nil)
    var resultList = [NSAttributedString]()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
        currentLocation = CLLocation()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        
//        if let splitViewController = splitViewController {
//            let controllers = splitViewController.viewControllers
//            detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? DetailViewController
//        }

        // Set bounds to the current location
        print("current location from search \(currentLocation)")
        var bounds = GMSCoordinateBounds()
        if let center = currentLocation?.coordinate {
            let neBoundsCorner = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
            let swBoundsCorner = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
            bounds = GMSCoordinateBounds(coordinate: neBoundsCorner,
                                         coordinate: swBoundsCorner)
        }

        // Set up the autocomplete filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment

        // Create the fetcher.
        fetcher = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
        fetcher?.delegate = self

//        textField?.addTarget(self, action: #selector(textFieldDidChange(textField:)),
//                             for: .editingChanged)
//        resultText?.text = "No Results"
//        resultText?.isEditable = false

    }

    @objc func textFieldDidChange(textField: UITextField) {
        fetcher?.sourceTextHasChanged(textField.text!)
    }
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return resultList.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        var resultsStr = NSAttributedString()
        if isFiltering() {
            resultsStr = resultList[indexPath.row]
        } else {
//            candy = candies[indexPath.row]
        }
        cell.placeName.attributedText = resultsStr
        return cell
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
//    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
//        filteredCandies = candies.filter({( candy : Candy) -> Bool in
//            return candy.name.lowercased().contains(searchText.lowercased())
//        })
//
//        tableView.reloadData()
//    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

}


extension SearchViewController: GMSAutocompleteFetcherDelegate {
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
//        let resultsStr = NSMutableAttributedString()
        for prediction in predictions {
            resultList.append(prediction.attributedPrimaryText)
        }
        tableView.reloadData()
//        resultText?.attributedText = resultsStr
    }
    func didFailAutocompleteWithError(_ error: Error) {
//        resultText?.text = error.localizedDescription
    }
}

extension SearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        fetcher?.sourceTextHasChanged(searchController.searchBar.text!)
        tableView.reloadData()
    }
}

extension SearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
//        locationManager?.stopUpdatingHeading()


    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            self.locationManager?.startUpdatingLocation()
        }
    }
}
