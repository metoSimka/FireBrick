//
//  ForgotPasswordViewController.swift
//  FireBrick
//
//  Created by metoSimka on 21/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import SwiftEntryKit

class ForgotPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func sendPassword(_ sender: UIButton) {
        SwiftEntryKit.dismiss()
    }
    
    @IBAction func close(_ sender: UIButton) {
        SwiftEntryKit.dismiss()
    }
}
