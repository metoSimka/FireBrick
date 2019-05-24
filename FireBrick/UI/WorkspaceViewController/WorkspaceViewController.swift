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

class WorkspaceViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        
        let storyboard = UIStoryboard(name: "AuthViewController", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "AuthViewController"  ) as? AuthViewController else {
            return
        }
        self.present(vc, animated: true, completion: nil)
    }
}
