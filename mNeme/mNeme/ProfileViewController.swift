//
//  ProfileViewController.swift
//  mNeme
//
//  Created by Lambda_School_Loaner_204 on 2/19/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    private var studyFrequency = ["Once a day",
                                  "Twice a day",
                                  "Once a week",
                                  "Three times a week",
                                  "Everyday",
                                  "Other"]
    private var notificationFrequency = ["When I haven't met my goal in a day",
                                         "When I haven't met my goal in a week",
                                         "Everyday",
                                         "Don't send me notifications"]
    var selectedStudyFrequency: String?
    var selectedNotificationFrequency: String?

    // MARK: IBOutlets
    @IBOutlet private weak var studyFrequencyTextField: UITextField!
    @IBOutlet private weak var mobileButton: UIButton!
    @IBOutlet private weak var desktopButton: UIButton!
    @IBOutlet private weak var preMadeDeckButton: UIButton!
    @IBOutlet private weak var customDeckButton: UIButton!
    @IBOutlet private weak var notificationFrequencyTextField: UITextField!
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
        createStudyFrequencyPicker()
        createNotificationFrequencyPicker()
        createToolBar()
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

    private func createStudyFrequencyPicker() {
        let studyFrequencyPicker = UIPickerView()
        studyFrequencyPicker.accessibilityIdentifier = "studyPickerID"
        studyFrequencyPicker.delegate = self

        studyFrequencyTextField.inputView = studyFrequencyPicker
    }

    private func createNotificationFrequencyPicker() {
        let notificationFrequencyPicker = UIPickerView()
        notificationFrequencyPicker.accessibilityIdentifier = "notificaionPickerID"
        notificationFrequencyPicker.delegate = self

        notificationFrequencyTextField.inputView = notificationFrequencyPicker
    }

    private func createToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))

        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        studyFrequencyTextField.inputAccessoryView = toolbar
        notificationFrequencyTextField.inputAccessoryView = toolbar
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let identifier = pickerView.accessibilityIdentifier {
            if identifier == "studyPickerID" {
                return studyFrequency.count
            } else if identifier == "notificaionPickerID" {
                return notificationFrequency.count
            }
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let identifier = pickerView.accessibilityIdentifier {
            if identifier == "studyPickerID" {
                return studyFrequency[row]
            } else if identifier == "notificaionPickerID" {
                return notificationFrequency[row]
            }
        }
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let identifier = pickerView.accessibilityIdentifier {
            if identifier == "studyPickerID" {
                selectedStudyFrequency = studyFrequency[row]
                studyFrequencyTextField.text = selectedStudyFrequency
            } else if identifier == "notificaionPickerID" {
                selectedNotificationFrequency = notificationFrequency[row]
                notificationFrequencyTextField.text = selectedNotificationFrequency
            }
        }

    }



}
