//
//  SplashScreenViewController.swift
//  FireBrick
//
//  Created by metoSimka on 23/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class SplashScreenViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableNotifications()
        GIDSignIn.sharedInstance()?.signInSilently()
    }
    
    // MARK: - Private methods
    
    @objc
    private func googleUserDidSignIn(_ notification:Notification) {
        let storyboard = UIStoryboard(name: Constants.controllers.workspaceViewController, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.controllers.workspaceViewController) as? WorkspaceViewController else {
            return
        }
        disableNotifications()
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc
    private func googleErrorAuth(_ notification:Notification) {
        let storyboard = UIStoryboard(name: Constants.controllers.authViewController, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.controllers.authViewController) as? AuthViewController else {
            return
        }
        disableNotifications()
        self.present(vc, animated: true, completion: nil)
    }
    
    private func enableNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(googleUserDidSignIn(_:)), name: .googleSignedIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(googleErrorAuth(_:)), name: .googleError, object: nil)
    }
    
    private func disableNotifications() {
        NotificationCenter.default.removeObserver(self, name: .googleSignedIn, object: nil)
        NotificationCenter.default.removeObserver(self, name: .googleError, object: nil)
    }
}
