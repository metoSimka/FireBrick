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

    @IBOutlet weak var emailAuth: UIView!
    @IBOutlet weak var googleAuth: UIView!
    @IBOutlet weak var googleHiddenButton: GIDSignInButton!

    @objc func emailButtonTap(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "EmailAuth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "e-mail auth"  ) as! EmailAuthViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func googleButtonTap(_ sender: UITapGestureRecognizer) {
        googleHiddenButton.sendActions(for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance()?.signInSilently()
//        setGoogleButton()
        viewsToButtonsConversions()
        NotificationCenter.default.addObserver(self, selector: #selector(googleUserDidSignIn(_:)), name: .googleSignedIn, object: nil)
    }
    
    @objc func googleUserDidSignIn(_ notification:Notification) {
        userDidSignIn()
    }
    
    @IBAction func emailAuth(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "EmailAuth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "e-mail auth"  ) as! EmailAuthViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func userDidSignIn() {
        let storyboard = UIStoryboard(name: "Entered", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "entered"  ) as! EnteredViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func  viewsToButtonsConversions() {
        let emailTap = UITapGestureRecognizer(target: self, action: #selector(emailButtonTap))
        self.emailAuth.addGestureRecognizer(emailTap)
        
        let googleTap = UITapGestureRecognizer(target: self, action: #selector(googleButtonTap))
        self.googleAuth.addGestureRecognizer(googleTap)
    }
}
