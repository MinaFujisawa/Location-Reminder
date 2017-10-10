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
    var fetcher: GMSAutocompleteFetcher?
    var currentLocation: CLLocation?
    var locationManager: CLLocationManager?
    @IBOutlet var tableView: UITableView!

    let searchController = UISearchController(searchResultsController: nil)
    var resultList = [GMSAutocompletePrediction]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Location Manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
        currentLocation = CLLocation()

        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false

        tableView.tableHeaderView = searchController.searchBar

        searchController.isActive = true
        searchController.searchBar.delegate = self
        searchController.delegate = self

        // MARK:UI of navi bar
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.barTintColor = UIColor.white

        // Prevent overlaps
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false

        // Add border
        let searchBar = searchController.searchBar
        let frame = CGRect(x: 0, y: searchBar.frame.size.height - 1, width: view.frame.size.width, height: 1)
        let border = UIView(frame: frame)
        border.backgroundColor = UIColor.lightGray
        searchBar.addSubview(border)

        // Change color of the cancel button
        let cancelButtonAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes, for: UIControlState.normal)

        // Remove border under the status bar
        searchController.searchBar.backgroundImage = UIImage()
    }



    // MARK: navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    //MARK:segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToAdd" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let prediction = resultList[indexPath.row]
                let addViewController = segue.destination as! AddViewController
                addViewController.prediction = prediction
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
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
        if isFiltering() {
            let resultsStr = resultList[indexPath.row]
            cell.placeName.attributedText = resultsStr.attributedPrimaryText
            cell.address.attributedText = resultsStr.attributedFullText
        }
        return cell
    }

    func textFieldDidChange(textField: UITextField) {
        fetcher?.sourceTextHasChanged(textField.text!)
    }

    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

extension SearchViewController: GMSAutocompleteFetcherDelegate {
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        resultList = predictions
        tableView.reloadData()
    }
    func didFailAutocompleteWithError(_ error: Error) {
//        resultText?.text = error.localizedDescription
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        fetcher?.sourceTextHasChanged(searchController.searchBar.text!)
        tableView.reloadData()
    }
}
extension SearchViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        //Focus the searchbar automatically
        self.searchController.searchBar.becomeFirstResponder()
    }
}
extension SearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
        locationManager?.stopUpdatingHeading()
        locationManager?.delegate = nil

        // Set bounds to the current location
        print("current location from search \(String(describing: currentLocation))")
        var bounds = GMSCoordinateBounds()
        if let center = currentLocation?.coordinate {
            let neBoundsCorner = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
            let swBoundsCorner = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
            bounds = GMSCoordinateBounds(coordinate: neBoundsCorner,
                                         coordinate: swBoundsCorner)
        }

        // Set up the autocomplete filter
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment

        // Create the fetcher
        fetcher = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
        fetcher?.delegate = self
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
//            self.locationManager?.startUpdatingLocation()
        }
    }
}
extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
    }
}

