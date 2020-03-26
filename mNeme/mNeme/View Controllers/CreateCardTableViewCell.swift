//
//  CreateCardTableViewCell.swift
//  mNeme
//
//  Created by Niranjan Kumar on 3/13/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

protocol CreateCardTableViewCellDelegate {
    func addCardWasTapped(frontText: String, backtext: String)
}

class CreateCardTableViewCell: UITableViewCell, UITextViewDelegate {
    
    // MARK: - IB Outlet & Properties
    @IBOutlet weak var addFrontTV: UITextView!
    @IBOutlet weak var addBackTV: UITextView!
    @IBOutlet weak var addCardButton: UIButton!
    @IBOutlet weak var addFlashcardView: UIView!
    
    var delegate: CreateCardTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addFrontTV.delegate = self
        addBackTV.delegate = self
    }

    // MARK: - IB Actions & Private Functions
    @IBAction func addCardButtonTapped(_ sender: Any) {
        if let frontTV = addFrontTV.text, !frontTV.isEmpty, frontTV != "Write on the front!", let backTV = addBackTV.text, !backTV.isEmpty, backTV != "Write on the back!" {
            delegate?.addCardWasTapped(frontText: frontTV, backtext: backTV)
        } else {
            let alert = UIAlertController(title: "Your card needs a front and back!", message: "Add some info to each section.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            parentViewController?.present(alert, animated: true)
        }
    }
    
    private func clearCardViews() {
        addFrontTV.text = "Write here!"
        addBackTV.text = "Write here!"
        addFrontTV.textColor = UIColor.lightGray
        addBackTV.textColor = UIColor.lightGray
    }
}


// MARK: - Extensions
// This allows us to present an alert in the parent controller of this cell

extension UIView {
    var parentViewController: CreateDeckViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is CreateDeckViewController {
                return parentResponder as? CreateDeckViewController
            }
        }
        return nil
    }
}

