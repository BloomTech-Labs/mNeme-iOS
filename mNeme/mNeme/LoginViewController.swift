//
//  LoginViewController.swift
//  mNeme
//
//  Created by Dennis Rudolph on 2/19/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

class LoginViewController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet weak var googleSignButton: GIDSignInButton!
    @IBOutlet weak var facebookLoginButton: FBLoginButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailSignInButton: UIButton!
    @IBOutlet weak var emailCancelButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideEmailButtons()
        
        emailButton.titleLabel?.text = "Log In with Email"
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        facebookLoginButton.delegate = self
        
    }
    
    @IBAction func emailButtonPressed(_ sender: Any) {
        toggleAllButtons()
        
    }
    
    @IBAction func emailSignInButton(_ sender: Any) {
        createAccountWithEmail()
        
    }
    
    @IBAction func emailCancelButton(_ sender: Any) {
        toggleAllButtons()
    }
    
    
    @IBAction func googleSignInPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let auth = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Login Successful.")
                //                self.performSegue(withIdentifier: "LoginSegue", sender: self)
            }
        }
    }
    
    private func createAccountWithEmail() {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                NSLog("Error dealing with email login creation: \(error)" )
                return
            }
            
            if let authResult = authResult {
                print("Auth Result has succeeded \(String(describing: authResult.credential))")
            }
        }
        
        // TODO: Create password length requirement
        
    }
    
    private func toggleAllButtons() {
        emailButton.isHidden.toggle()
        googleSignButton.isHidden.toggle()
        facebookLoginButton.isHidden.toggle()
        emailTextField.isHidden.toggle()
        passwordTextField.isHidden.toggle()
        emailSignInButton.isHidden.toggle()
        emailCancelButton.isHidden.toggle()

    }
    
    private func hideEmailButtons() {
        emailTextField.isHidden = true
        passwordTextField.isHidden = true
        emailSignInButton.isHidden = true
        emailCancelButton.isHidden = true
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                print("Login Successful")
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    
}

extension LoginViewController: UITextFieldDelegate {
    
}