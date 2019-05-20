//
//  GoogleSignUpViewController.swift
//  FireBrick
//
//  Created by metoSimka on 20/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class GoogleSignUpViewController: UIViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    
    @IBAction func ff(_ sender: GIDSignInButton) {
                GIDSignIn.sharedInstance().signIn()
    }
}
