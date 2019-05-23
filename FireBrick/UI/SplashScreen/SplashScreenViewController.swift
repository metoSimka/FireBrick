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
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance()?.signIn()
        NotificationCenter.default.addObserver(self, selector: #selector(googleUserDidSignIn(_:)), name: .googleSignedIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(googleErrorAuth(_:)), name: .googleError, object: nil)
    }
    
//    func autoLogin() {
//        //        GIDSignIn.sharedInstance()?.signInSilently()
//        GIDSignIn.sharedInstance()?.signIn()
//        guard let _ = GIDSignIn.sharedInstance()?.currentUser else {
//            return
//        }
//    }
//
//    @objc func googleUserDidSignIn(_ notification:Notification) {
//        guard let userData = notification.userInfo else {
//            return
//        }
//        guard let user = userData["user"] as? GIDGoogleUser else {
//            return
//        }
//
//        guard let authentication = user.authentication else {
//            return
//        }
//
//        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                       accessToken: authentication.accessToken)
//
//        Auth.auth().signIn(with: credential) { (authResult, error) in
//            guard error == nil else {
//                self.showErrorMsg(errorTxt: error?.localizedDescription)
//                return
//            }
//            self.userDidSignIn()
//        }
//    }
//
//    @objc func googleErrorAuth(_ notification:Notification) {
//        stopGoogleLoader()
//        guard let data = notification.userInfo else {
//            return
//        }
//        guard let error = data["error"] as? NSError else {
//            showErrorMsg(errorTxt: "Uknown authentication error")
//            return
//        }
//        guard error.code != Constants.errorCodes.googleUserCancel else {
//            return
//        }
//        showErrorMsg(errorTxt: error.localizedDescription)
//    }
//
//    func user
//
//    func userDidSignIn() {
//        let storyboard = UIStoryboard(name: "Entered", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "entered"  ) as! WorkspaceViewController
//        self.present(vc, animated: true, completion: nil)
//    }
}
