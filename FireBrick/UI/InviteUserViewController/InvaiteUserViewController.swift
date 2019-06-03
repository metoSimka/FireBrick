//
//  InvaiteUserViewController.swift
//  FireBrick
//
//  Created by metoSimka on 31/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit

class InvaiteUserViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
    }
    
    
    @IBAction func addNewTechnology(_ sender: UIButton) {
    }
    
    @IBAction func addTechnology(_ sender: UIButton) {
    }
    
    private  func isValidEmail() -> Bool {
        guard let txt = emailTextField.text else {
            return false
        }
        let emailTest = NSPredicate(format:"SELF MATCHES %@", Constants.commonStrings.eMailFormat)
        return emailTest.evaluate(with: txt)
    }
}

extension InvaiteUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isValidEmail() {
            return true
        } else {
            return true
        }
    }
}
