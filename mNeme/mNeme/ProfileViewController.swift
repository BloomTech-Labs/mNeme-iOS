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

    // MARK: Views
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }

    private func updateViews() {
        //view.backgroundColor = UIColor.mNeme.orangeBlaze
        buttonViews()
    }

    private func buttonViews() {
        mobileButton.tintColor = UIColor.mNeme.orangeBlaze
        desktopButton.tintColor = UIColor.mNeme.orangeBlaze
        preMadeDeckButton.tintColor = UIColor.mNeme.orangeBlaze
        customDeckButton.tintColor = UIColor.mNeme.orangeBlaze
        mobileButton.accessibilityIdentifier = "mobileButtonID"
        desktopButton.accessibilityIdentifier = "desktopButtonID"
        preMadeDeckButton.accessibilityIdentifier = "preMadeDeckButtonID"
        customDeckButton.accessibilityIdentifier = "customDeckButtonID"
    }

    // MARK: IBActions
    @IBAction private func devicePreferencesTapped(_ sender: UIButton) {
        studyDevicePreferences(sender.accessibilityIdentifier)
    }

    @IBAction private func deckPreferenceTapped(_ sender: UIButton) {
        flashcardDeckPreferences(sender.accessibilityIdentifier)
    }

    // MARK: Private methods
    private func studyDevicePreferences(_ identifier: String?) {
        guard let identifier = identifier else { return }
        if !mobileButton.isSelected && !desktopButton.isSelected {
            if identifier == "mobileButtonID" {
                mobileButton.isSelected.toggle()
            } else if identifier == "desktopButtonID" {
                desktopButton.isSelected.toggle()
            }
        }

        if identifier == "desktopButtonID" {
            if !desktopButton.isSelected {
                desktopButton.isSelected.toggle()
                mobileButton.isSelected.toggle()
            }
        } else if identifier == "mobileButtonID" {
            if !mobileButton.isSelected {
                mobileButton.isSelected.toggle()
                desktopButton.isSelected.toggle()
            }
        }
    }

    private func flashcardDeckPreferences(_ identifier: String?) {
        guard let identifier = identifier else { return }
        if !preMadeDeckButton.isSelected && !customDeckButton.isSelected {
            if identifier == "preMadeDeckButtonID" {
                preMadeDeckButton.isSelected.toggle()
            } else if identifier == "customDeckButtonID" {
                customDeckButton.isSelected.toggle()
            }
        }

        if identifier == "preMadeDeckButtonID" {
            if !preMadeDeckButton.isSelected {
                preMadeDeckButton.isSelected.toggle()
                customDeckButton.isSelected.toggle()
            }
        } else if identifier == "customDeckButtonID" {
            if !customDeckButton.isSelected {
                preMadeDeckButton.isSelected.toggle()
                customDeckButton.isSelected.toggle()
            }
        }
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
