//
//  ProfileViewController.swift
//  mNeme
//
//  Created by Lambda_School_Loaner_204 on 2/19/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet private weak var studyFrequencyButton: UIButton!
    @IBOutlet private weak var mobileButton: UIButton!
    @IBOutlet private weak var desktopButton: UIButton!
    @IBOutlet private weak var preMadeDeckButton: UIButton!
    @IBOutlet private weak var customDeckButton: UIButton!
    @IBOutlet private weak var notificationButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }

    private func updateViews() {
        view.backgroundColor = UIColor.mNeme.orangeBlaze
        buttonViews()
    }

    private func buttonViews() {

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
