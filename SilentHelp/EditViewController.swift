//
//  EditViewController.swift
//  SilentHelp
//
//  Created by MINA FUJISAWA on 2017/10/04.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITextFieldDelegate {
    var place: Place?
    var list: [Place]?
    var test: Int?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
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
        self.nameTextField.delegate = self
        
        nameTextField.text = addressName
    
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let place = place else { return }
        nameTextField.text = place.comment
        addressLabel.text = place.fullAddress
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard let place = place else { return }
        if let name = nameTextField.text {
            place.comment = name
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Close keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(nameTextField: UITextField) {
        addressName = nameTextField.text
    }
}
