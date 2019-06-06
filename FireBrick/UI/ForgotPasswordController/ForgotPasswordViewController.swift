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
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var warningTitle: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    
    @IBAction func sendPassword(_ sender: UIButton) {
        SwiftEntryKit.dismiss()
    }
    
    @IBAction func close(_ sender: UIButton) {
        SwiftEntryKit.dismiss()
    }
}
