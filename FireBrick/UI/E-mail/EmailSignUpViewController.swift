//
//  EmailSignUpViewController.swift
//  FireBrick
//
//  Created by metoSimka on 16/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class EmailSignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true) {
        }
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        if emailTextField.text == "" {
            invalidEnteredLogin()
        } else {
            guard let email = emailTextField.text else {
                return
            }
            guard let password = passwordTextField.text else {
                return
            }
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if error == nil {
                    self.successfulData(authResult: authResult, error: error)
                } else {
                    self.errorSignIn(error: error)
                }
            }
        }
    }

    
    @IBAction func login(_ sender: UIButton) {
        if emailTextField.text == "" {
            invalidEnteredLogin()
        } else {
            guard let email = emailTextField.text else {
                return
            }
            guard let password = passwordTextField.text else {
                return
            }
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error == nil {
                    self.successfulData(authResult: user, error: error)
                } else {
                    guard let error = error else {
                        return
                    }
                    self.errorSignIn(error: error)
                }
            }
        }
    }
    
    func invalidEnteredLogin() {
        let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func userDidSignIn() {
        let storyboard = UIStoryboard(name: "Entered", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "entered") as! EnteredViewController
        self.present(vc, animated: true, completion: nil)
    }
    

    
    func errorSignIn(error: Error?) {
        guard let error = error else {
            return
        }
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func successfulData(authResult: AuthDataResult? ,error: Error?) {
        if error == nil {
            guard let authResult = authResult else {
                return
            }
            print("You have successfully signed up")
            let userData:[String: AuthDataResult] = ["user": authResult]
            NotificationCenter.default.post(name: .e_mailSignedIn, object: nil, userInfo: userData)
            self.userDidSignIn()
        }
    }
}

extension EmailSignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}

extension Notification.Name {
    static let e_mailSignedIn = Notification.Name("e-mailSignedIn")
    static let errorSignIn = Notification.Name("errorSignIn")
}
