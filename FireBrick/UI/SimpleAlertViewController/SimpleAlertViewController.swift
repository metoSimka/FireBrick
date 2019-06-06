//
//  AlertMessageViewController.swift
//  FireBrick
//
//  Created by metoSimka on 23/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import SwiftEntryKit

protocol SingleButtonAlertMessageViewDelegate {
    func didTapButton(button: UIButton)
}

class SimpleAlertViewController: UIViewController {
    
    // MARK: - Public variables
    
    var delegate: SingleButtonAlertMessageViewDelegate?
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    
    // MARK: - Private variables
    
    var headerTitle = "Alert"
    var messageTitle = "Uknown Error"
    var buttonTitle = "OK"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = headerTitle
        messageLabel.text = messageTitle
        button.setTitle(buttonTitle, for: .normal)
    }
    
    // MARK: - IBActions
    
    @IBAction func tapButton(_ sender: UIButton) {
        self.delegate?.didTapButton(button: sender)
        SwiftEntryKit.dismiss()
    }
}
