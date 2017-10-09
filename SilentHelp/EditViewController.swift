//
//  EditViewController.swift
//  SilentHelp
//
//  Created by MINA FUJISAWA on 2017/10/04.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    let placeListKey: String = PlaceListViewController().placeListKey
    
    var place: Place?
    var list: [Place]?
    var rowIndex: Int?
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var addressName : String?
    
    @IBAction func removeButton(_ sender: Any) {
        let listVC = PlaceListViewController()
        if let index = rowIndex {
            listVC.placeList?.remove(at: index)
            let defaults = UserDefaults.standard
            defaults.set(NSKeyedArchiver.archivedData(withRootObject: listVC.placeList!), forKey: self.placeListKey)
            // Back to List page
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "placeList") as! PlaceListViewController
            self.navigationController?.pushViewController(destVC, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageTextField.delegate = self
        
        messageTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let place = place else { return }
        messageTextField.text = place.message
        placeNameLabel.text = place.placeName
        addressLabel.text = place.fullAddress
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let place = place else { return }
        if let message = messageTextField.text {
            place.message = message
        }
    }
}

extension EditViewController: UITextFieldDelegate {
    //Close keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
}
