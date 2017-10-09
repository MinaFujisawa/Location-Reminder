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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var resultText: UITextView!
    //    var textField: UITextField?
//    var resultText: UITextView?
    var fetcher: GMSAutocompleteFetcher?
    var currentLocation : CLLocation?
    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
        currentLocation = CLLocation()

        view.backgroundColor = .white
        edgesForExtendedLayout = []


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

        textField?.addTarget(self, action: #selector(textFieldDidChange(textField:)),
                             for: .editingChanged)
        resultText?.text = "No Results"
        resultText?.isEditable = false

    }

    @objc func textFieldDidChange(textField: UITextField) {
        fetcher?.sourceTextHasChanged(textField.text!)
    }
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchCell
        
        // セルに表示する値を設定する
        cell.address.text = "address"
        cell.placeName.text = "placeName"
        
        return cell
    }
    
    /// セルが選択された時に呼ばれるデリゲートメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
    }
}


extension SearchViewController: GMSAutocompleteFetcherDelegate {
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        let resultsStr = NSMutableAttributedString()
        for prediction in predictions {
            resultsStr.append(prediction.attributedPrimaryText)
            resultsStr.append(NSAttributedString(string: "\n"))
        }
        resultText?.attributedText = resultsStr
    }
    func didFailAutocompleteWithError(_ error: Error) {
        resultText?.text = error.localizedDescription
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
