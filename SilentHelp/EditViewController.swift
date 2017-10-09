//
//  EditViewController.swift
//  SilentHelp
//
//  Created by MINA FUJISAWA on 2017/10/04.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    var place: Place?
    var list: [Place]?
    var test: Int?
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var addressName : String?
    
    @IBAction func removeButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let listVC = storyBoard.instantiateViewController(withIdentifier: "placeList") as! PlaceListViewController
        if let test = test {
            listVC.placeList?.remove(at: test)
            print("removed at \(test)")
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
        if let name = messageTextField.text {
            place.message = name
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
