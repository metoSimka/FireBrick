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
import SwiftEntryKit

class EmailAuthViewController: UIViewController {
    
    @IBOutlet weak var spinnerSignUp: UIActivityIndicatorView!
    @IBOutlet weak var warningEmailTextLabel: UILabel!
    @IBOutlet weak var warningPasswordTextLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var constraintPasswordWarning: NSLayoutConstraint!
    @IBOutlet weak var constraintEmailWarning: NSLayoutConstraint!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var imageWarningPassword: UIImageView!
    @IBOutlet weak var imageWarningEmail: UIImageView!
    @IBOutlet weak var spinnerLogin: UIActivityIndicatorView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var LogInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        disableButtons()
    }
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true) {
        }
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        let vc = ForgotPasswordViewController(nibName: "ForgotPasswordViewController", bundle: nil)
        SwiftEntryKit.display(entry: vc, using: EKAttributes.default)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        signUpFunc()
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
        logInFunc()
    }
    
    func signUpFunc() {
        guard emailTextField.text != "" else  {
            showErrorWithMessage()
            return
        }
        startLoadingSignUp()
        guard let email = emailTextField.text else {
            return
        }
        guard let password = passwordTextField.text else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard error == nil else {
                guard let error = error else {
                    return
                }
                self.errorSignIn(error: error)
                self.stopLoading()
                return
            }
            self.successfulData(authResult: authResult, error: error)
            self.stopLoading()
        }
    }
    
    func startLoadingLogin() {
        spinnerLogin.startAnimating()
        disableButtons()
        LogInButton.setTitle("", for: .normal)
        LogInButton.alpha = Constants.magicNumbers.fullAlpha
    }
    
    func startLoadingSignUp() {
        spinnerSignUp.startAnimating()
        disableButtons()
        signUpButton.setTitle("", for: .normal)
        signUpButton.alpha = Constants.magicNumbers.fullAlpha
    }
    
    func stopLoading() {
        spinnerLogin.stopAnimating()
        spinnerSignUp.stopAnimating()
        enableButtons()
        LogInButton.setTitle(Constants.strings.LogInButton, for: .normal)
        signUpButton.setTitle(Constants.strings.signUpButton, for: .normal)
    }
    
    func logInFunc() {
        guard emailTextField.text != "" else  {
            showErrorWithMessage()
            return
        }
        startLoadingLogin()
        guard let email = emailTextField.text else {
            return
        }
        guard let password = passwordTextField.text else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard error == nil else {
                guard let error = error else {
                    return
                }
                self.errorSignIn(error: error)
                self.stopLoading()
                return
            }
            self.successfulData(authResult: user, error: error)
            self.stopLoading()
        }
    }
    
    func showWarningPassword() {
        UIView.animate(withDuration: Constants.forAnimation.normal) {
            self.constraintPasswordWarning.constant = Constants.forConstraints.showValue
            self.view.layoutIfNeeded()
            self.imageWarningPassword.alpha = Constants.magicNumbers.fullAlpha
            self.warningPasswordTextLabel.alpha = Constants.magicNumbers.fullAlpha
        }
    }
    
    func hideWarningPassword() {
        UIView.animate(withDuration: Constants.forAnimation.normal) {
            self.constraintPasswordWarning.constant = Constants.forConstraints.hideValue
            self.view.layoutIfNeeded()
            self.imageWarningPassword.alpha = Constants.magicNumbers.zeroAlpha
            self.warningPasswordTextLabel.alpha = Constants.magicNumbers.zeroAlpha
        }
    }
    
    func showWarningEmail() {
        UIView.animate(withDuration: Constants.forAnimation.normal) {
            self.constraintEmailWarning.constant = Constants.forConstraints.showValue
            self.view.layoutIfNeeded()
            self.imageWarningEmail.alpha = Constants.magicNumbers.fullAlpha
            self.warningEmailTextLabel.alpha = Constants.magicNumbers.fullAlpha
        }
    }
    
    func hideWarningEmail() {
        UIView.animate(withDuration: Constants.forAnimation.normal) {
            self.constraintEmailWarning.constant = Constants.forConstraints.hideValue
            self.view.layoutIfNeeded()
            self.imageWarningEmail.alpha = Constants.magicNumbers.zeroAlpha
            self.warningEmailTextLabel.alpha = Constants.magicNumbers.zeroAlpha
        }
    }
    
    func showErrorWithMessage() {
        let storyboard = UIStoryboard(name: "SingleButtonAlertMessage", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "singleButtonAlert") as! SingleButtonAlertMessageViewController
        vc.headerLabel.text = "Error"
        vc.messageLabel.text = "Please enter your email and password"
        SwiftEntryKit.display(entry: vc, using: EKAttributes.default)
    }
    
    func showErrorWithMessage1() {
        let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)    
        present(alertController, animated: true, completion: nil)
    }
    
    func userDidSignIn() {
        let storyboard = UIStoryboard(name: "Workspace", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "workspace") as! WorkspaceViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func errorSignIn1(error: Error?) {
        guard let error = error else {
            return
        }
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func errorSignIn(error: Error?) {
        guard let error = error else {
            return
        }
        let storyboard = UIStoryboard(name: "SingleButtonAlertMessage", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "singleButtonAlert") as! SingleButtonAlertMessageViewController
        vc.messageTitle = error.localizedDescription
        SwiftEntryKit.display(entry: vc, using: EKAttributes.default)
    }
    
    func successfulData(authResult: AuthDataResult? ,error: Error?) {
        guard error == nil else {
            return
        }
        guard let authResult = authResult else {
            return
        }
        print("You have successfully signed up")
        let userData:[String: AuthDataResult] = ["user": authResult]
        NotificationCenter.default.post(name: .e_mailSignedIn, object: nil, userInfo: userData)
        self.userDidSignIn()
    }
    
    func isValidEmail() -> Bool {
        guard let txt = emailTextField.text else {
            return false
        }
        let emailTest = NSPredicate(format:"SELF MATCHES %@", Constants.strings.eMailFormat)
        return emailTest.evaluate(with: txt)
    }
    
    func isValidPassword() -> Bool {
        guard let txt = passwordTextField.text else {
            return false
        }
        let count = txt.count
        guard count >= Constants.magicNumbers.minCountPasswordChars else {
            return false
        }
        return true
    }
    
    func shouldEnableButtons() {
        guard isValidPassword() && isValidEmail() else {
            disableButtons()
            return
        }
        enableButtons()
    }
    
    func disableButtons() {
        signUpButton.isEnabled = false
        signUpButton.alpha = Constants.magicNumbers.halfAlpha
        
        LogInButton.isEnabled = false
        LogInButton.alpha = Constants.magicNumbers.halfAlpha
    }
    
    func enableButtons() {
        signUpButton.isEnabled = true
        signUpButton.alpha = Constants.magicNumbers.fullAlpha
        
        LogInButton.isEnabled = true
        LogInButton.alpha = Constants.magicNumbers.fullAlpha
    }
}

extension EmailAuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            if isValidEmail() {
                hideWarningEmail()
            } else {
                showWarningEmail()
            }
        } else if textField == passwordTextField {
            if isValidPassword() {
                hideWarningPassword()
            } else {
                showWarningPassword()
            }
        }
        shouldEnableButtons()
    }
}

extension Notification.Name {
    static let e_mailSignedIn = Notification.Name("e-mailSignedIn")
    static let errorSignIn = Notification.Name("errorSignIn")
}
