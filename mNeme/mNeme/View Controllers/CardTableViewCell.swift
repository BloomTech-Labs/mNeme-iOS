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

    // MARK: - IB Outlets
    @IBOutlet weak var frontCardTV: UITextView!
    @IBOutlet weak var backCardTV: UITextView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var dividerView: UIView!
    
    // MARK: - Properties
    var index: Int?
    var delegate: CardTableViewCellDelegate?
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        frontCardTV.delegate = self
        backCardTV.delegate = self
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        frontCardTV.centerVertically()
        backCardTV.centerVertically()
    }
}

// MARK: - Extensions
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

extension UITextView {
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}
