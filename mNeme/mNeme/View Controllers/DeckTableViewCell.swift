//
//  DeckTableViewCell.swift
//  mNeme
//
//  Created by Niranjan Kumar on 2/26/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class DeckTableViewCell: UITableViewCell {

    @IBOutlet weak var deckNameLabel: UILabel!
    @IBOutlet weak var masteredCardsLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var deck: MockDemoDeck?
    var controller: MockDemoDeckController?
    
    
    private func updateViews() {
        guard let deck = deck else { return }
    
        deckNameLabel.text = "\(deck.deckName.capitalized)"
        masteredCardsLabel.text = "Mastered X of \(deck.data.count)"
    
    }

}
