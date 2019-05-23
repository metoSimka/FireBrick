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
    
    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var emailAuth: UIView!
    @IBOutlet weak var googleAuth: UIView!
    @IBOutlet weak var googleHiddenButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        viewsToButtonsConversions()
        NotificationCenter.default.addObserver(self, selector: #selector(googleUserDidSignIn(_:)), name: .googleSignedIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(googleErrorAuth(_:)), name: .googleError, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isUserLogged() {
            userDidSignIn()
        }
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
        let storyboard = UIStoryboard(name: "EmailAuth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "e-mail auth"  ) as! EmailAuthViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func googleButtonTap(_ sender: UITapGestureRecognizer) {
        startGoogleLoader()
        googleHiddenButton.sendActions(for: .touchUpInside)
    }
    
    func startGoogleLoader() {
        UIView.animate(withDuration: Constants.forAnimation.normal) {
            self.spinnerView.alpha = Constants.magicNumbers.fullAlpha
            self.disableButtons()
        }
    }
    
    func stopGoogleLoader() {
        UIView.animate(withDuration: Constants.forAnimation.normal) {
            self.spinnerView.alpha = Constants.magicNumbers.zeroAlpha
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
        googleAuth.alpha = Constants.magicNumbers.fullAlpha
        emailAuth.isUserInteractionEnabled = true
        emailAuth.alpha = Constants.magicNumbers.fullAlpha
    }
    
    func disableButtons() {
        googleAuth.isUserInteractionEnabled = false
        googleAuth.alpha = Constants.magicNumbers.halfAlpha
        emailAuth.isUserInteractionEnabled = false
        emailAuth.alpha = Constants.magicNumbers.halfAlpha
    }
    
    func userDidSignIn() {
        let storyboard = UIStoryboard(name: "Entered", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "entered"  ) as! WorkspaceViewController
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

