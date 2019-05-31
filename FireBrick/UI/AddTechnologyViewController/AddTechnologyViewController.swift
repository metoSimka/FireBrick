//
//  AddTechnologyViewController.swift
//  FireBrick
//
//  Created by metoSimka on 27/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import SwiftEntryKit
import Firebase
import FirebaseFirestore

class AddTechnologyViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var docTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        docTextField.delegate = self
        updataButtonState()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        SwiftEntryKit.dismiss()
    }
    
    @IBAction func add(_ sender: UIButton) {
        writeData()
    }
    
    func writeData() {
        guard let name = nameTextField.text else {
            return
        }
        guard let doc = docTextField.text else {
            return
        }
        guard name.count > 0 && doc.count > 0 else {
            return
        }
        
        let dataToSave: [String: Any] = ["Name": name, "Documentation": doc]
        Firestore.firestore().collection("Technology").addDocument(data: dataToSave, completion: { (error) in
            guard error == nil else {
                print("there must be ALERT!")
                return
            }
                SwiftEntryKit.dismiss()
        })
    }
    
    func isFildsAreEmpty() -> Bool {
        if nameTextField.text?.count ?? 0 == 0 || docTextField.text?.count ?? 0 == 0 {
            return true
        }
        return false
    }
    
    func updataButtonState() {
        if isFildsAreEmpty() {
            addButton.alpha = 0.5
            addButton.isEnabled = false
        } else {
            addButton.alpha = 1
            addButton.isEnabled = true
        }
    }
}

extension AddTechnologyViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            docTextField.becomeFirstResponder()
        } else if textField == docTextField {
            docTextField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            updataButtonState()
    }
}

