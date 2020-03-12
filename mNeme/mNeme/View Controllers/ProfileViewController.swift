//
//  ProfileViewController.swift
//  mNeme
//
//  Created by Lambda_School_Loaner_204 on 2/19/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    // MARK: - Properties
    var userController: UserController?

    // MARK: - IBOutlets
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var logoutButton: UIBarButtonItem!

    // MARK: -  View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

        if let userController = userController {
            NotificationCenter.default.post(name: .homeViewHasLoaded, object: nil, userInfo: ["userController": userController] )
        }
    }

    private func updateViews() {
        let textAttribute = [NSAttributedString.Key.foregroundColor: UIColor.white]
        logoutButton.setTitleTextAttributes(textAttribute, for: .normal)
        topView.backgroundColor = UIColor.mNeme.orangeBlaze
    }

    // MARK: - IBActions
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        setupAndDisplayLogoutAlerts()
    }
    
    // MARK: - Private methods - User Preferences Creation and Views for Each Setting
    private func setupAndDisplayLogoutAlerts() { // Log out Alert
        let alert = UIAlertController(title: "Are you sure you want to logout?", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { action in
            do {
                try Auth.auth().signOut()
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }catch {
                let errorAlert = UIAlertController(title: "Error logging out", message: "Please restart the application", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(errorAlert, animated: true)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
