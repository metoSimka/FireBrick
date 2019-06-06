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
        
        let dataToSave: [String: Any] = [Constants.fireStoreFields.technology.name: name,
                                         Constants.fireStoreFields.technology.documentation: doc]
        
        Firestore.firestore().collection(Constants.mainFireStoreCollections.technology).addDocument(data: dataToSave, completion: { (error) in
            guard error == nil else {
                guard let errorText = error?.localizedDescription else {
                    return
                }
                self.showErrorMessage(errorText: errorText)
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
    
    private func showErrorMessage(errorText: String) {
        let alertController = UIAlertController(title: "Error", message: errorText, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
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

