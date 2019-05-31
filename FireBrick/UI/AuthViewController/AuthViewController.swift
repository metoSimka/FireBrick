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

class AuthViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var googleSignInView: GIDSignInButton!
    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var emailAuth: UIView!
    @IBOutlet weak var googleAuth: UIView!
    @IBOutlet weak var googleHiddenButton: GIDSignInButton!
    
    let disableTransparencyAlpha: CGFloat = 0.5
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
    }
    
    // MARK: IBActions
    
    @IBAction func googleTap(_ sender: UIView) {
        startGoogleLoader()
        googleSignInView.sendActions(for: .touchUpInside)
    }
    
    @IBAction func emailTap(_ sender: UIView) {
        let storyboard = UIStoryboard(name: Constants.controllers.emailAuthViewController, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.controllers.emailAuthViewController) as? EmailAuthViewController else {
            return
        }
        unregisterNotifications()
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: Private
    
    @objc
    private func googleUserDidSignIn(_ notification:Notification) {
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
                guard let error = error else {
                    return
                }
                self.showErrorMessage(errorText: error.localizedDescription)
                return
            }
            self.userDidSignIn()
        }
    }
    
    @objc
    private func googleErrorAuth(_ notification:Notification) {
        stopGoogleLoader()
        guard let data = notification.userInfo else {
            return
        }
        guard let error = data["error"] as? NSError else {
            showErrorMessage(errorText: "Uknown authentication error")
            return
        }
        guard error.code != Constants.errorCodes.googleUserCancel else {
            return
        }
        showErrorMessage(errorText: error.localizedDescription)
    }

    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(googleUserDidSignIn(_:)), name: .googleSignedIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(googleErrorAuth(_:)), name: .googleError, object: nil)
    }
    
    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: .googleSignedIn, object: nil)
        NotificationCenter.default.removeObserver(self, name: .googleError, object: nil)
    }
    
    private func startGoogleLoader() {
        UIView.animate(withDuration: Constants.forAnimation.normal) {
            self.spinner.startAnimating()
            self.disableButtons()
        }
    }
    
    private func stopGoogleLoader() {
        UIView.animate(withDuration: Constants.forAnimation.fast) {
            self.spinner.stopAnimating()
            self.enableButtons()
        }
    }
    
    private func enableButtons() {
        googleAuth.isUserInteractionEnabled = true
        googleAuth.alpha = 1
        emailAuth.isUserInteractionEnabled = true
        emailAuth.alpha = 1
    }
    
    private func disableButtons() {
        googleAuth.isUserInteractionEnabled = false
        googleAuth.alpha = 0
        emailAuth.isUserInteractionEnabled = false
        emailAuth.alpha = disableTransparencyAlpha
    }
    
    private func userDidSignIn() {
        let storyboard = UIStoryboard(name: Constants.controllers.workspaceViewController, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.controllers.workspaceViewController) as? WorkspaceViewController else {
            return
        }
        unregisterNotifications()
        self.present(vc, animated: true, completion: nil)
    }
    
    private func showErrorMessage(errorText: String) {
        let alertController = UIAlertController(title: "Error", message: errorText, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: Extensions

extension AuthViewController: GIDSignInUIDelegate {
}

