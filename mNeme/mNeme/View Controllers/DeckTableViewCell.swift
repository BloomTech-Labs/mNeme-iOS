//
//  DeckTableViewCell.swift
//  mNeme
//
//  Created by Niranjan Kumar on 2/26/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class DeckTableViewCell: UITableViewCell {

    // MARK: - IB Outlets
    @IBOutlet weak var deckNameLabel: UILabel!
    @IBOutlet weak var masteredCardsLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    // MARK: - Properties
    var archived = false
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
    
    // MARK: - Private Functions
    private func updateViews() {
        if let deck = DemoDeck {
            deckNameLabel.text = "\(deck.deckName.capitalized)"
            masteredCardsLabel.text = "Mastered X of \(deck.data?.count ?? 0)"
        } else if let deck = deck, let name = deck.deckInformation.deckName {
            deckNameLabel.text = "\(name)"
            if archived {
                let length = deck.deckInformation.deckLength ?? 0
                masteredCardsLabel.text = "Mastered X of \(length)"
            } else {
                let length = deck.data?.count ?? 0
                masteredCardsLabel.text = "Mastered X of \(length)"
            }
        }
    }
}
