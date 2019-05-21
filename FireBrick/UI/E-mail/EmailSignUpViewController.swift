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
    
    @IBOutlet weak var warningPasswordTextField: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var constraintPasswordWarning: NSLayoutConstraint!
    @IBOutlet weak var constraintEmailWarning: NSLayoutConstraint!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var imageWarningPassword: UIImageView!
    @IBOutlet weak var imageWarningEmail: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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

    @IBAction func ShowHidePassword(_ sender: UIButton) {
        if eyeButton.isSelected {
            eyeButton.isSelected = false
            passwordTextField.isSecureTextEntry = true
        } else {
            eyeButton.isSelected = true
            passwordTextField.isSecureTextEntry = false
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
    
    func showWarningPassword() {
        UIView.animate(withDuration: Constants.forAnimation.normal) {
        self.constraintPasswordWarning.constant = Constants.forConstraints.showValue
            self.view.layoutIfNeeded()
        self.imageWarningPassword.alpha = 1
            self.warningPasswordTextField.alpha = 1
        }
    }
    func hideWarningPassword() {
        UIView.animate(withDuration: Constants.forAnimation.normal) {
            self.constraintPasswordWarning.constant = Constants.forConstraints.hideValue
            self.view.layoutIfNeeded()
            self.imageWarningPassword.alpha = 0
            self.warningPasswordTextField.alpha = 0
        }
    }
    
    func showWarningEmail() {
        UIView.animate(withDuration: Constants.forAnimation.normal) {
            self.constraintEmailWarning.constant = Constants.forConstraints.showValue
            self.view.layoutIfNeeded()
            self.imageWarningEmail.alpha = 1
        }
    }
    
    func hideWarningEmail() {
        UIView.animate(withDuration: Constants.forAnimation.normal) {
            self.constraintEmailWarning.constant = Constants.forConstraints.hideValue
            self.view.layoutIfNeeded()
            self.imageWarningEmail.alpha = 0
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        print("work")
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
    
    func isValidEmail() -> Bool {
        guard let txt = emailTextField.text else {
            return false
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: txt)
    }
    
    func isValidPassword() -> Bool {
        guard let txt = passwordTextField.text else {
            return false
        }
        let count = txt.count
        guard count >= 6 else {
            return false
        }
        return true
    }
}

extension EmailSignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
            if isValidEmail() {
                hideWarningEmail()
            } else {
                showWarningEmail()
            }
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            if isValidPassword() {
                hideWarningPassword()
            } else {
                showWarningPassword()
            }
        }
        return true
    }
}

extension Notification.Name {
    static let e_mailSignedIn = Notification.Name("e-mailSignedIn")
    static let errorSignIn = Notification.Name("errorSignIn")
}

extension UIViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/3
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
