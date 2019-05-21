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

class DashBoardViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var googleButton: GIDSignInButton!
    
    func customizeGoogleButton() {
        googleButton.style = GIDSignInButtonStyle.wide
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance()?.signInSilently()
        setGoogleButton()
        NotificationCenter.default.addObserver(self, selector: #selector(googleUserDidSignIn(_:)), name: .googleSignedIn, object: nil)
        customizeGoogleButton()
    }
    
    @objc func googleUserDidSignIn(_ notification:Notification) {
        userDidSignIn()
    }

    @IBAction func e_mailAuth(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "EmailSignUp", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "e-mail SignUp"  ) as! EmailSignUpViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func userDidSignIn() {
        let storyboard = UIStoryboard(name: "Entered", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "entered"  ) as! EnteredViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func setGoogleButton() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(googleAuth))
        self.googleButton.addGestureRecognizer(tap)
    }
    
  @objc  func googleAuth() {
        GIDSignIn.sharedInstance().signIn()
    }
}
