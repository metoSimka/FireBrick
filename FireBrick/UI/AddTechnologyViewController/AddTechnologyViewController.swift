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
    
    var docRef: DocumentReference!
    var db: Firestore?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var DocTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        nameTextField.delegate = self
        DocTextField.delegate = self
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
        guard let doc = DocTextField.text else {
            return
        }
        
        let dataToSave: [String: Any] = ["Name": name, "Documentation": doc]
        db!.collection("Technology").addDocument(data: dataToSave, completion: { (error) in
            guard error == nil else {
                print("there must be ALERT!")
                return
            }
                SwiftEntryKit.dismiss()
        })
    }
}

extension AddTechnologyViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return true
    }
}
