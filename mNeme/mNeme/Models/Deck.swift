//
//  Deck.swift
//  mNeme
//
//  Created by Niranjan Kumar on 3/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct Deck: Codable {
    var icon: String
    var tag: [String]?
    var createdBy: String
    var exampleCard: String
    var collectionId: [CardData]
    var deckName: String
    var deckLength: Int
    
}

struct CardData: Codable {
    var id: String
    var data: [CardInfo]
}

struct CardInfo: Codable {
    var archived: Bool = false
    var back: String
    var front: String
}
