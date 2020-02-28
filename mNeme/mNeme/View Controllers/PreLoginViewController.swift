//
//  PreLoginViewController.swift
//  mNeme
//
//  Created by Dennis Rudolph on 2/20/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class PreLoginViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var bottomColorView: UIView!
    @IBOutlet weak var mNemeLogoLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        bottomColorView.backgroundColor = UIColor.mNeme.orangeBlaze
        mNemeLogoLabel.textColor = UIColor.mNeme.orangeBlaze
        signInButton.setTitleColor(UIColor.mNeme.orangeBlaze, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.signingUp = true
            }
        } else if segue.identifier == "SignInSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.signingUp = false
            }
        }
    }
}
