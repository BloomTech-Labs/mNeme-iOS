//
//  PreLoginViewController.swift
//  mNeme
//
//  Created by Dennis Rudolph on 2/20/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class PreLoginViewController: UIViewController {

    @IBOutlet weak var bottomColorView: UIView!
    @IBOutlet weak var mNemeLogoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        bottomColorView.backgroundColor = UIColor.mNeme.orangeBlaze
        mNemeLogoLabel.textColor = UIColor.mNeme.orangeBlaze
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
