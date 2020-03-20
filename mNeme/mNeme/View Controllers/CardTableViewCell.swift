//
//  CardTableViewCell.swift
//  mNeme
//
//  Created by Dennis Rudolph on 3/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

protocol CardTableViewCellDelegate {
    func cardWasEdited(index: Int, text: String, side: frontOrBack)
}

enum frontOrBack {
    case front
    case back
}

class CardTableViewCell: UITableViewCell {

    @IBOutlet weak var frontCardTV: UITextView!
    @IBOutlet weak var backCardTV: UITextView!
    @IBOutlet weak var cardView: UIView!
    var index: Int?
    
    var delegate: CardTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        frontCardTV.delegate = self
        backCardTV.delegate = self
    }
    
}

extension CardTableViewCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text, let index = index else { return }
        if textView == frontCardTV {
            delegate?.cardWasEdited(index: index, text: text, side: .front)
        } else {
            delegate?.cardWasEdited(index: index, text: text, side: .back)
        }
    }
}
