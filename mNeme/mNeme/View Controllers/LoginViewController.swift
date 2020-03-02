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
    
    // MARK: - Properties
    let userController = UserController()
    let deckCardsDispatchGroup = DispatchGroup()
    let demoDeckController = DemoDeckController()
    var signingUp = false
    

    // MARK: - IB Outlets
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var googleImageButton: UIImageView!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var googleLoginLabel: UILabel!

    @IBOutlet weak var facebookView: UIView!
    @IBOutlet weak var facebookImageButton: UIImageView!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var facebookLoginLabel: UILabel!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailImageButton: UIImageView!
    @IBOutlet weak var emailLoginLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailSignInButton: UIButton!
    @IBOutlet weak var emailCancelButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var largeNavView: UIView!
    
    @IBOutlet weak var bottomTextLabel: UILabel!
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var bottomNavView: UIView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() { 
        super.viewDidLoad()
        updateViews()
        setUpButtonTap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Auth.auth().currentUser != nil {
            if let uid = Auth.auth().currentUser?.uid {
                self.signInWithAuthResultUID(uid: uid)
            }
        }
    }
    
    // MARK: - IB Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func googleSignInPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.googleView.backgroundColor = .darkGray
            self.googleView.backgroundColor = .white
        }
        GIDSignIn.sharedInstance().signIn()

    }
    
    @IBAction private func facebookSignInPressed() {
        UIView.animate(withDuration: 0.3) {
            self.facebookView.backgroundColor = .darkGray
            self.facebookView.backgroundColor = UIColor(red: 23, green: 120, blue: 242)
        }
        
        let loginManager = LoginManager()
        loginManager.logIn(
            permissions: [.publicProfile, .email],
            viewController: self
        ) { result in
            self.loginManagerDidComplete(result)
        }
    }
    
    @IBAction func emailSignInPressed(_ sender: Any) {
        toggleAllButtons()
    }

    @IBAction func emailLogInButton(_ sender: Any) {
        if signingUp {
            createAccountWithEmail()
        } else {
            signInWithEmail()
        }
    }
    
    @IBAction func emailCancelButton(_ sender: Any) {
        toggleAllButtons()
    }
    
    // MARK: - Set Up Views Functions
    private func updateViews() {
        hideEmailButtons()
        emailButtonText()
        largeNavView.backgroundColor = UIColor.mNeme.orangeBlaze
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        bottomNavView.backgroundColor = UIColor.mNeme.orangeBlaze
        bottomImageViewandLabel()
        
        googleView.backgroundColor = .white
        googleView.layer.cornerRadius = 5
        googleView.layer.shadowRadius = CGFloat(integerLiteral: 5)
        googleView.layer.shadowColor = UIColor.gray.cgColor
        googleView.layer.shadowOpacity = 1
        googleView.layer.shadowOffset = .zero
        
        facebookView.backgroundColor = UIColor(red: 23, green: 120, blue: 242)
        facebookView.layer.cornerRadius = 5
        facebookView.layer.shadowRadius = CGFloat(integerLiteral: 5)
        facebookView.layer.shadowColor = UIColor.gray.cgColor
        facebookView.layer.shadowOpacity = 1
        facebookView.layer.shadowOffset = .zero

        emailView.backgroundColor = UIColor.mNeme.orangeBlaze
        emailView.layer.cornerRadius = 5
        emailView.layer.shadowRadius = CGFloat(integerLiteral: 5)
        emailView.layer.shadowColor = UIColor.gray.cgColor
        emailView.layer.shadowOpacity = 1
        emailView.layer.shadowOffset = .zero
    }
    
    private func toggleAllButtons() {
        emailButton.isHidden.toggle()
        googleLoginButton.isHidden.toggle()
        facebookLoginButton.isHidden.toggle()
        emailTextField.isHidden.toggle()
        passwordTextField.isHidden.toggle()
        emailSignInButton.isHidden.toggle()
        emailCancelButton.isHidden.toggle()
        facebookView.isHidden.toggle()
        googleView.isHidden.toggle()
        emailView.isHidden.toggle()
    }
    
    private func hideEmailButtons() {
        emailTextField.isHidden = true
        passwordTextField.isHidden = true
        emailSignInButton.isHidden = true
        emailCancelButton.isHidden = true
    }
    
    private func emailButtonText() {
        if signingUp {
            facebookLoginButton.setTitle("Sign up with Facebook", for: .normal)
            googleLoginButton.setTitle("Sign up with Google", for: .normal)
            emailButton.setTitle("Sign up with Email", for: .normal)
            emailSignInButton.setTitle("Sign Up", for: .normal)
        } else {
            facebookLoginButton.setTitle("Sign in with Facebook", for: .normal)
            googleLoginButton.setTitle("Sign in with Google", for: .normal)
            emailButton.setTitle("Sign in with Email", for: .normal)
            emailSignInButton.setTitle("Sign In", for: .normal)
            
        }
    }
    
    private func bottomImageViewandLabel() {
        if signingUp {
            bottomImageView.image = UIImage(named: "Basketball-Mastery-Illustrations")
            bottomTextLabel.text = "Join mNeme Today"
        } else {
            bottomImageView.image = UIImage(named: "Banner Illustration")
            bottomTextLabel.text = "The best way to study efficiently 😎"
        }
    }
    
    // MARK: - Tap Gestures Creation
    
    private func setUpButtonTap() {
        let googleViewTap = UITapGestureRecognizer(target: self, action: #selector(googleButtonTapped))
        googleViewTap.numberOfTapsRequired = 1
        googleView.addGestureRecognizer(googleViewTap)
        
        let googleImageViewTap = UITapGestureRecognizer(target: self, action: #selector(googleButtonTapped))
        googleImageViewTap.numberOfTapsRequired = 1
        googleImageButton.addGestureRecognizer(googleImageViewTap)
        
        let facebookViewTap = UITapGestureRecognizer(target: self, action: #selector(facebookButtonTapped))
        facebookViewTap.numberOfTapsRequired = 1
        facebookView.addGestureRecognizer(facebookViewTap)

        let facebookImageTap = UITapGestureRecognizer(target: self, action: #selector(facebookButtonTapped))
        facebookImageTap.numberOfTapsRequired = 1
        facebookImageButton.addGestureRecognizer(facebookImageTap)

        let emailViewTap = UITapGestureRecognizer(target: self, action: #selector(emailButtonTapped))
        emailViewTap.numberOfTapsRequired = 1
        emailView.addGestureRecognizer(emailViewTap)
        
        let emailImageTap = UITapGestureRecognizer(target: self, action: #selector(emailButtonTapped))
        emailImageTap.numberOfTapsRequired = 1
        emailImageButton.addGestureRecognizer(emailImageTap)
    }
    
    @objc func googleButtonTapped() {
        UIView.animate(withDuration: 0.3) {
            self.googleView.backgroundColor = .darkGray
            self.googleView.backgroundColor = .white
        }
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func facebookButtonTapped() {
        UIView.animate(withDuration: 0.3) {
            self.facebookView.backgroundColor = .darkGray
            self.facebookView.backgroundColor = UIColor(red: 23, green: 120, blue: 242)
        }
        facebookSignInPressed()
    }
    
    @objc func emailButtonTapped() {
        UIView.animate(withDuration: 0.3) {
            self.emailView.backgroundColor = .darkGray
            self.emailView.backgroundColor = UIColor.mNeme.orangeBlaze
        }
        toggleAllButtons()
    }
    
    // MARK: - Private Functions
    
    // Users is successfully signed in and DemoDecks are retrieved from networking
    private func signInWithAuthResultUID(uid: String) {
        userController.user = User(uid)
        userController.getUserPreferences {
            self.demoDeckController.getDemoDecks {
                for decks in self.demoDeckController.demoDecks {
                    self.deckCardsDispatchGroup.enter()
                    self.demoDeckController.getDemoDeckCards(deckName: decks.deckName) {
                        self.deckCardsDispatchGroup.leave()
                    }
                }
                self.deckCardsDispatchGroup.notify(queue: .main) {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "MainSegue", sender: self)
                    }
                }

            }
        }
    }

    // Facebook Login Authentication Success // Error Handling
    func loginManagerDidComplete(_ result: LoginResult) {
        switch result {
        case .cancelled:
            print("cancelled")

        case .failed:
            print("failed")

        case .success:
            print("success")
            guard let accessToken = AccessToken.current?.tokenString else { return
                print("no token")
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    print(authResult?.credential as Any)
                    if let uid = authResult?.user.uid {
                        self.signInWithAuthResultUID(uid: uid)
                    }
                    print("Login Successful")
                }
            }
        }
    }


    // Google Sign In Authentication Function
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
                if let uid = authResult?.user.uid {
                    self.signInWithAuthResultUID(uid: uid)
                }
            }
        }
    }

    // Email Account Creation
    private func createAccountWithEmail() {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }

        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                NSLog("Error dealing with email login creation: \(error)" )
                return
            }

            if let authResult = authResult {
                print("Sign up Auth Result has succeeded \(String(describing: authResult.credential))")
                let uid = authResult.user.uid
                self.signInWithAuthResultUID(uid: uid)
            }
        }
        // TODO: Create password length requirement / type password again
        // TODO: Create Alerts and notification

    }

    private func signInWithEmail() {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }

        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                NSLog("Error dealing with email sign in: \(error)" )
                let alert = UIAlertController(title: "Invalid username or password", message: "Please sign in with an existing account or create a new one", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                return
            }

            if let authResult = authResult {
                print("Sign in Auth Result has succeeded \(String(describing: authResult.credential))")
                let uid = authResult.user.uid
                self.signInWithAuthResultUID(uid: uid)
            }
        }
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "MainSegue" {
            if let destinationVC = segue.destination as? TabViewController {
                destinationVC.userController = self.userController
                destinationVC.demoDeckController = self.demoDeckController
            }
        }
    }

}

// MARK: - Extensions
extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }

        guard let accessToken = AccessToken.current?.tokenString else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
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

