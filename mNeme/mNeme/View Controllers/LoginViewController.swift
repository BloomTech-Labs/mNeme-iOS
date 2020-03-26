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
     let deckController = DeckController()
     var signingUp = false
     
     let pleaseWaitAlert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

     
     
     // MARK: - IB Outlets
     @IBOutlet weak var googleLoginButton: UIButton!
     @IBOutlet weak var facebookLoginButton: UIButton!
     @IBOutlet weak var emailLoginButton: UIButton!
     
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
          
          let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
          loadingIndicator.hidesWhenStopped = true
          loadingIndicator.style = UIActivityIndicatorView.Style.medium
          loadingIndicator.startAnimating();
          pleaseWaitAlert.view.addSubview(loadingIndicator)
          
          updateViews()
     }
     
     override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(true)
          if signingUp {
                if Auth.auth().currentUser != nil {
                   try? Auth.auth().signOut()
               }
          } else {
               if Auth.auth().currentUser != nil {
                    self.present(self.pleaseWaitAlert, animated: true, completion: nil)
                    if let uid = Auth.auth().currentUser?.uid {
                         self.signInWithAuthResultUID(uid: uid)
                    }
               }
          }
     }
     
     // MARK: - IB Actions
     @IBAction func backButtonPressed(_ sender: Any) {
          self.dismiss(animated: true)
     }
     
     @IBAction func googleSignInPressed(_ sender: Any) {
          GIDSignIn.sharedInstance().signIn()
          
     }
     
     @IBAction private func facebookSignInPressed() {
          let loginManager = LoginManager()
          loginManager.logIn(
               permissions: [.publicProfile, .email],
               viewController: self) { result in
               self.loginManagerDidComplete(result)
          }
     }
     
     @IBAction func emailSignInPressed(_ sender: Any) {
          toggleAllButtons()
     }
     
     @IBAction func emailLogInButton(_ sender: Any) {
          if signingUp {
               createAccountWithEmail()
               present(pleaseWaitAlert, animated: true, completion: nil)
          } else {
               signInWithEmail()
               present(pleaseWaitAlert, animated: true, completion: nil)
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
     }
     
     private func toggleAllButtons() {
          emailLoginButton.isHidden.toggle()
          googleLoginButton.isHidden.toggle()
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
     
     private func emailButtonText() {
          if signingUp {
               facebookLoginButton.setImage(UIImage(named: "signupFB"), for: .normal)
               googleLoginButton.setImage(UIImage(named: "signupGG"), for: .normal)
               emailLoginButton.setImage(UIImage(named: "signupEM"), for: .normal)
               emailSignInButton.setTitle("Sign Up", for: .normal)
          } else {
               facebookLoginButton.setImage(UIImage(named: "signinFB"), for: .normal)
               googleLoginButton.setImage(UIImage(named: "signinGG"), for: .normal)
               emailLoginButton.setImage(UIImage(named: "signinEM"), for: .normal)
               emailSignInButton.setTitle("Sign In", for: .normal)
               
          }
     }
     
     private func bottomImageViewandLabel() {
          
          bottomImageView.image = UIImage(named: "Banner Illustration")
          if signingUp {
               bottomTextLabel.text = "Join mNeme Today"
          } else {
               bottomTextLabel.text = "The best way to study efficiently 😎"
          }
     }
     
     // MARK: - Private Functions
     
     // Users is successfully signed in and DemoDecks are retrieved from networking
     private func signInWithAuthResultUID(uid: String) {
          let user = User(uid)
          userController.user = user
          userController.getUserPreferences {
               self.deckCardsDispatchGroup.enter()
               self.deckController.getAllDemoDecks { self.deckCardsDispatchGroup.leave() }
               self.deckCardsDispatchGroup.enter()
               self.deckController.fetchArchivedDecks(userID: user.id) { self.deckCardsDispatchGroup.leave() }
               self.deckCardsDispatchGroup.enter()
               self.deckController.fetchDecks(userID: user.id) { self.deckCardsDispatchGroup.leave() }

               self.deckCardsDispatchGroup.notify(queue: .main) {
                    DispatchQueue.main.async {
                         print("done Fetching")
                         self.pleaseWaitAlert.dismiss(animated: false, completion: nil)
                         self.performSegue(withIdentifier: "MainSegue", sender: self)
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
                         self.present(self.pleaseWaitAlert, animated: true, completion: nil)
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
                         self.present(self.pleaseWaitAlert, animated: true, completion: nil)
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
                    self.pleaseWaitAlert.dismiss(animated: true) {
                         NSLog("Error dealing with email sign in: \(error)" )
                         let invalidAlert = UIAlertController(title: "Invalid username or password", message: "Please sign in with an existing account or create a new one", preferredStyle: .alert)
                         
                         invalidAlert.addAction(UIAlertAction(title: "Sign Up", style: .default, handler: { (action) in
                              self.signingUp = true
                              self.emailTextField.text = ""
                              self.passwordTextField.text = ""
                              self.emailButtonText()
                              self.bottomImageViewandLabel()
                         }))
                         
                         invalidAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                              self.passwordTextField.text = ""
                         }))
                         self.present(invalidAlert, animated: true)
                         return
                    }
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
                    destinationVC.demoDeckController = self.deckController
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

