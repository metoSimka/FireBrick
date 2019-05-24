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
    
    var delegate: SingleButtonAlertMessageViewDelegate?
    var headerTitle = "Alert"
    var messageTitle = "Uknown Error"
    var buttonTitle = "OK"
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = headerTitle
        messageLabel.text = messageTitle
        button.setTitle(buttonTitle, for: .normal)
    }
    
    @IBAction func tapButton(_ sender: UIButton) {
        self.delegate?.didTapButton(button: sender)
        SwiftEntryKit.dismiss()
    }
}
