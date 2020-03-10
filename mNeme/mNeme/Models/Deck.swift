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
struct Deck: Equatable, Codable {
    var deckInformation: DeckInformation
    var data: [CardData]?

    enum DeckCodingKeys: String, CodingKey {
        case deckInformation
        case data
    }

    init(deckInfo: DeckInformation) {
        self.deckInformation = deckInfo
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DeckCodingKeys.self)
        deckInformation = try container.decode(DeckInformation.self, forKey: .deckInformation)
        data = try container.decode([CardData].self, forKey: .data)
    }
}

struct DeckInformation: Equatable, Codable {
    var icon: String
    var tag: [String]?
    var createdBy: String
    var exampleCard: String
    var collectionId: String
    var deckName: String
    var deckLength: Int
}

struct CardData: Equatable, Codable {
    var id: String? = nil
    var archived: Bool? = nil
    var back: String
    var front: String

    enum CardDataKeys: String, CodingKey {
        case id
        case data
    }

    enum CardInfoKeys: String, CodingKey {
        case archived
        case front
        case back
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CardDataKeys.self)
        id = try container.decode(String.self, forKey: .id)
        let dataContainer = try container.nestedContainer(keyedBy: CardInfoKeys.self, forKey: .data)
        archived = try dataContainer.decode(Bool.self, forKey: .archived)
        front = try dataContainer.decode(String.self, forKey: .front)
        back = try dataContainer.decode(String.self, forKey: .back)
    }
}
