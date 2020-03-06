//
//  Deck.swift
//  mNeme
//
//  Created by Niranjan Kumar on 3/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

// This struct will only hold the decks collection ID for making the network call
struct DeckCollectionId: Codable {
    var collectionId: String
}

// This will be the main structure for holding all deck information
struct Deck: Codable, Equatable {
    let deckInformation: DeckInformation
    let data: [CardData]
}

struct DeckInformation: Codable, Equatable {
    var icon: String
    var tag: [String]?
    var createdBy: String
    var exampleCard: String
    var collectionId: String
    var deckName: String
    var deckLength: Int

//    init(icon: String, tag: [String]) {
//        self.icon = icon
//        self.tag = tag
//    }
}

struct CardData: Codable, Equatable {
    var id: String
    var data: CardInfo

    struct CardInfo: Codable, Equatable {
        var archived: Bool = false
        var back: String
        var front: String
    }
}
