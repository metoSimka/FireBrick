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
    
    // MARK: - Public variables
    
    var availableTechnologyNames: [String] = []
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var docTextField: UITextField!

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        docTextField.delegate = self
        updataButtonState()
    }
    
    // MARK: - IBActions
    
    @IBAction func cancel(_ sender: UIButton) {
        SwiftEntryKit.dismiss()
    }
    
    @IBAction func add(_ sender: UIButton) {
        documentationTextFieldNillGuard()
        writeData()
    }
    
    // MARK: - Private methods
    
    private func writeData() {
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
    
    private func isNameValid() -> Bool {
        guard isNameContainsAtLeastOneWord() && isNameNotEmpty() && isNameOriginal() else {
            return false
        }
        return true
    }
    
    private func isNameContainsAtLeastOneWord() -> Bool {
        let letters = NSCharacterSet.letters
        
        guard let nameText = nameTextField.text else {
            return false
        }
        let range = nameText.rangeOfCharacter(from: letters)
        guard range != nil else {
            return false
        }
        return true
    }
    
    private func isNameNotEmpty() -> Bool {
        guard let nameTextCount = nameTextField.text?.count else {
            return false
        }
        guard nameTextCount != 0 else {
            return false
        }
        return true
    }
    
    private func isNameOriginal() -> Bool {
        guard let nameText = nameTextField.text else {
            return false
        }
        guard !availableTechnologyNames.contains(nameText) else {
            return false
        }
        print(availableTechnologyNames)
        print(nameText)
        return true
    }
    
    private func documentationTextFieldNillGuard() {
        if docTextField.text == nil {
            docTextField.text = ""
        }
    }
    
    private func updataButtonState() {
        if isNameValid() {
            addButton.alpha = 1
            addButton.isEnabled = true
        } else {
            addButton.alpha = 0.5
            addButton.isEnabled = false
        }
    }
    
    private func showErrorMessage(errorText: String) {
        let alertController = UIAlertController(title: "Error", message: errorText, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Protocol Conformance

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
