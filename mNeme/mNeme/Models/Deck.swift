//
//  Deck.swift
//  mNeme
//
//  Created by Niranjan Kumar on 3/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

// This will be the main structure for holding all deck information
struct Deck: Equatable, Codable {
    var deckInformation: DeckInformation
    var data: [CardData]?

    enum DeckDecodingKeys: String, CodingKey {
        case deckInformation
        case data
    }

    enum DeckEncodingKeys: String, CodingKey {
        case deck
        case cards
    }

    init(deckInfo: DeckInformation, data: [CardData]? = nil) {
        self.deckInformation = deckInfo
        self.data = data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DeckDecodingKeys.self)
        deckInformation = try container.decode(DeckInformation.self, forKey: .deckInformation)
        data = try container.decode([CardData].self, forKey: .data)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DeckEncodingKeys.self)
        try container.encode(deckInformation, forKey: .deck)
        try container.encode(data, forKey: .cards)
    }
}

struct DeckInformation: Equatable, Codable {
    var icon: String
    var tags: [String]
    var createdBy: String?
    var exampleCard: String?
    var collectionId: String?
    var deckName: String?
    var deckLength: Int?

    init(icon: String, tags: [String]) {
        self.icon = icon
        self.tags = tags
    }
}

struct CardData: Equatable, Codable {
    var id: String?
    var archived: Bool?
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

    init(front: String, back: String) {
        self.back = back
        self.front = front
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

struct DemoDeck: Codable {
    var deckName: String
    var data: [CardData]?

    struct CardData: Codable {
        var id: String
        var data: CardInfo

        struct CardInfo: Codable {
            var back, front: String
        }
    }
}
