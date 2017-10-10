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
    
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var addressName : String?
    
    @IBAction func removeButton(_ sender: Any) {
        let listVC = PlaceListViewController()
        // MARK: Actionsheet
        let alert: UIAlertController = UIAlertController(title: place!.placeName + " will be deleted", message: nil, preferredStyle:  UIAlertControllerStyle.actionSheet)
        
        // Delete action
        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler:{
            (action: UIAlertAction!) -> Void in
            if let index = self.rowIndex {
                listVC.placeList?.remove(at: index)
                let defaults = UserDefaults.standard
                defaults.set(NSKeyedArchiver.archivedData(withRootObject: listVC.placeList!), forKey: self.placeListKey)
                // Back to List page
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "placeList") as! PlaceListViewController
                self.navigationController?.pushViewController(destVC, animated: true)
            }
        })
        
        // Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("cancelAction")
        })
        
        // Show
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageTextField.delegate = self
        
        messageTextField.becomeFirstResponder()
        
        // UI for Remove button
        removeButton.backgroundColor = .clear
        removeButton.layer.cornerRadius = 5
        removeButton.layer.borderWidth = 1
        removeButton.layer.borderColor = UIColor.red.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let place = place else { return }
        messageTextField.text = place.message
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
