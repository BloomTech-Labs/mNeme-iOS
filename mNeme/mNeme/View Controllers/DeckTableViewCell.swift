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
    
    var DemoDeck: DemoDeck? {
        didSet {
            updateViews()
        }
    }
    var deck: Deck? {
        didSet {
            updateViews()
        }
    }
    
    
    private func updateViews() {
        if let deck = DemoDeck {
            deckNameLabel.text = "\(deck.deckName.capitalized)"
            masteredCardsLabel.text = "Mastered X of \(deck.data?.count ?? 0)"
        } else if let deck = deck {
            deckNameLabel.text = "\(deck.deckInformation.deckName)"
            masteredCardsLabel.text = "Mastered X of \(deck.deckInformation.deckLength)"
        }
    }
}
