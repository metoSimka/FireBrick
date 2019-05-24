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

class SplashScreenViewController: UIViewController, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableNotifications()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance()?.signInSilently()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disableNotifications()
    }
    
    @objc func googleUserDidSignIn(_ notification:Notification) {
        let storyboard = UIStoryboard(name: "WorkspaceViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "workspace"  ) as! WorkspaceViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func googleErrorAuth(_ notification:Notification) {
        let storyboard = UIStoryboard(name: "AuthViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "auth"  ) as! AuthViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func enableNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(googleUserDidSignIn(_:)), name: .googleSignedIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(googleErrorAuth(_:)), name: .googleError, object: nil)
    }
    
    func disableNotifications() {
        NotificationCenter.default.removeObserver(self, name: .googleSignedIn, object: nil)
        NotificationCenter.default.removeObserver(self, name: .googleError, object: nil)
    }
}
