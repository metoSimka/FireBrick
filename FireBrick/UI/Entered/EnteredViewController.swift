//
//  EnteredViewController.swift
//  FireBrick
//
//  Created by metoSimka on 20/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class EnteredViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Home"  ) as! DashBoardViewController
        self.present(vc, animated: true, completion: nil)
    }

}
