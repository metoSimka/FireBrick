//
//  DashBoardViewController.swift
//  FireBrick
//
//  Created by metoSimka on 16/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class AuthViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var googleSignInView: GIDSignInButton!
    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var emailAuth: UIView!
    @IBOutlet weak var googleAuth: UIView!
    @IBOutlet weak var googleHiddenButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        viewsToButtonsConversions()
    }

    func enableNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(googleUserDidSignIn(_:)), name: .googleSignedIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(googleErrorAuth(_:)), name: .googleError, object: nil)
    }
    
    func disableNotifications() {
        NotificationCenter.default.removeObserver(self, name: .googleSignedIn, object: nil)
        NotificationCenter.default.removeObserver(self, name: .googleError, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableNotifications()
    }
    
    @objc func googleUserDidSignIn(_ notification:Notification) {
        guard let userData = notification.userInfo else {
            return
        }
        guard let user = userData["user"] as? GIDGoogleUser else {
            return
        }
        guard let authentication = user.authentication else {
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            guard error == nil else {
                self.showErrorMsg(errorTxt: error?.localizedDescription)
                return
            }
            self.userDidSignIn()
        }
    }
    
    @objc func googleErrorAuth(_ notification:Notification) {
        stopGoogleLoader()
        guard let data = notification.userInfo else {
            return
        }
        guard let error = data["error"] as? NSError else {
            showErrorMsg(errorTxt: "Uknown authentication error")
            return
        }
        guard error.code != Constants.errorCodes.googleUserCancel else {
            return
        }
        showErrorMsg(errorTxt: error.localizedDescription)
    }
    
    @objc func emailButtonTap(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "EmailAuthViewController", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "e-mail auth"  ) as? EmailAuthViewController else {
            return
        }
        disableNotifications()
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func googleButtonTap(_ sender: UITapGestureRecognizer) {
        startGoogleLoader()
        googleSignInView.sendActions(for: .touchUpInside)
    }
    
    func startGoogleLoader() {
        UIView.animate(withDuration: Constants.forAnimation.normal) {
            self.spinnerView.alpha = 1
            self.disableButtons()
        }
    }
    
    func stopGoogleLoader() {
        UIView.animate(withDuration: Constants.forAnimation.fast) {
            self.spinnerView.alpha = 0
            self.enableButtons()
        }
    }
    
    func isUserLogged() -> Bool {
        guard let _ = GIDSignIn.sharedInstance()?.currentUser else {
            return false
        }
        return true
    }
    
    func enableButtons() {
        googleAuth.isUserInteractionEnabled = true
        googleAuth.alpha = 1
        emailAuth.isUserInteractionEnabled = true
        emailAuth.alpha = 1
    }
    
    func disableButtons() {
        googleAuth.isUserInteractionEnabled = false
        googleAuth.alpha = 0.5
        emailAuth.isUserInteractionEnabled = false
        emailAuth.alpha = 0.5
    }
    
    func userDidSignIn() {
        let storyboard = UIStoryboard(name: "WorkspaceViewController", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "workspace"  ) as? WorkspaceViewController else {
            return
        }
        disableNotifications()
        self.present(vc, animated: true, completion: nil)
    }
    
    func  viewsToButtonsConversions() {
        let emailTap = UITapGestureRecognizer(target: self, action: #selector(emailButtonTap))
        self.emailAuth.addGestureRecognizer(emailTap)
        
        let googleTap = UITapGestureRecognizer(target: self, action: #selector(googleButtonTap))
        self.googleAuth.addGestureRecognizer(googleTap)
    }
    
    func showErrorMsg(errorTxt: String?) {
        let alertController = UIAlertController(title: "Error", message: errorTxt, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isErrorAboutCancled(errMsg: String) -> Bool {
        guard errMsg == "The user canceled the sign-in flow." else {
            return false
        }
        return true
    }
}

