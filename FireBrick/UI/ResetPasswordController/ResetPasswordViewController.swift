//
//  ResetPasswordViewController.swift
//  FireBrick
//
//  Created by metoSimka on 21/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import SwiftEntryKit

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func sendPassword(_ sender: UIButton) {
          dismiss(animated: true, completion: nil)
    }
    
    @IBAction func close(_ sender: UIButton) {
        SwiftEntryKit.dismiss()
    }
}
