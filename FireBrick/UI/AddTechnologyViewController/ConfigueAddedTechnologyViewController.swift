//
//  ConfigueAddedTechnologyViewController.swift
//  FireBrick
//
//  Created by metoSimka on 11/06/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import SDWebImage

class ConfigueAddedTechnologyViewController: UIViewController {

    @IBOutlet weak var labelNameTechnology: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var textFieldHours: UITextField!
    @IBOutlet weak var textFieldDateStart: UITextField!
    @IBOutlet weak var textFieldDateEnd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func openNavigation(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func check(_ sender: UIButton) {
    }
    
    @IBAction func openRedactor(_ sender: UIButton) {
    }
    
    @IBAction func apply(_ sender: UIButton) {
    }
}

extension ConfigueAddedTechnologyViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        return true
    }
}
