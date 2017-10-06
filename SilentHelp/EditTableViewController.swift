//
//  EditViewController.swift
//  SilentHelp
//
//  Created by MINA FUJISAWA on 2017/10/04.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit

class EditTableViewController: UIViewController, UITextFieldDelegate {
    var silentZone: Place?
    var list: [Place]?
    var test: Int?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var addressName : String?
    
    // need to access the index of the Place and reload tableview
    // after removing item from the silentZoneList array
    @IBAction func removeButton(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let listVC = storyBoard.instantiateViewController(withIdentifier: "SilentZoneList") as! SilentZoneListViewController
        print(listVC.silentZoneList?.count ?? 0)
        if let test = test {
            listVC.silentZoneList?.remove(at: test)
            print("removed at \(test)")
        } else {
            print("can't get index")
        }
//
//        list?.remove(at: 0 )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        
        nameTextField.text = addressName
    
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let silentZone = silentZone else { return }
        nameTextField.text = silentZone.name
        addressLabel.text = silentZone.address
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard let silentZone = silentZone else { return }
        if let name = nameTextField.text {
            silentZone.name = name
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
