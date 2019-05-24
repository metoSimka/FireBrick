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

class SingleButtonAlertMessageViewController: UIViewController {

    var delegate: SingleButtonAlertMessageViewDelegate?
    var headTitle: String?
    var messageTitle: String?
    var buttonTitle: String?
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAlertView(title: headTitle, message: messageTitle, buttonTitle: buttonTitle)
    }
    
    @IBAction func tapButton(_ sender: UIButton) {
        self.delegate?.didTapButton(button: sender)
        SwiftEntryKit.dismiss()
    }
    
    func setAlertView(title: String?, message: String?, buttonTitle: String?) {
        if title != nil {
            headerLabel.text = title
        }
        if message != nil {
            messageLabel.text = message
        }
        if buttonTitle != nil {
            button.setTitle(buttonTitle, for: .normal)
        }
    }
}
