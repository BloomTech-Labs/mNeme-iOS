//
//  DeckTests.swift
//  mNemeTests
//
//  Created by Lambda_School_Loaner_204 on 3/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import XCTest

@testable import mNeme

class DeckTests: XCTestCase {

    func testGetDeckCollectionID() {
        let mock = ModckDataLoader()
        mock.data = collectionIdDeckData

        let client = NetworkClient(networkDataLoader: mock)

        var deckData = [Deck]()
        let expect = expectation(description: "Wait for Deck data to return from API")

        client.fetch("", nil) { (decksInfo: [DeckInformation]?) in
            if let decks = decksInfo {
                for deck in decks {
                    deckData.append(Deck(deckInfo: deck))
                }
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)

        XCTAssertEqual(deckData.count, 1)
        XCTAssertEqual(deckData[0].deckInformation.collectionId, "asdsdsa")
    }

    func testGetDeckInformation() {
        let mock = ModckDataLoader()
        mock.data = deckInfromationData

        let client = NetworkClient(networkDataLoader: mock)

        var cardData: [CardData]?
        let expect = expectation(description: "Wait for Deck data to return from API")

        client.fetch("", "") { (deck: Deck?) in
            cardData = deck?.data
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)

        XCTAssertNotNil(cardData)
        XCTAssertEqual(cardData?[0].back, "xzczxcxzc")
        XCTAssertEqual(cardData?[0].front, "xzcz")
    }

    func testPostDeck() {
        let mock = ModckDataLoader()
        mock.data = createDeckData
        let client = NetworkClient(networkDataLoader: mock)

        var deckData: Deck?
        let card1 = CardData(front: "front1", back: "back1")
        let card2 = CardData(front: "front2", back: "back2")
        let cards: [CardData] = [ card1, card2 ]
        let user = User("r4Ok4g9OA5UHtpXnDRqF5XFCduH3")
        let expect = expectation(description: "Wait for deck to create and return")

        client.post(user: user, deckName: "iosTest", icon: "", tags: ["test"], cards: cards) { (deck: Deck?) in
            deckData = deck
            expect.fulfill()
        }

        wait(for: [expect], timeout: 100)

        XCTAssertNotNil(deckData)
        XCTAssertEqual(deckData?.deckInformation.exampleCard, "front1")
        XCTAssertEqual(deckData?.deckInformation.deckName, "iosTest")
        XCTAssertEqual(deckData?.deckInformation.deckLength, 2)
        XCTAssertEqual(deckData?.data?[0].back, "back1")
        XCTAssertEqual(deckData?.data?[0].front, "front1")
        XCTAssertEqual(deckData?.data?[1].back, "back2")
        XCTAssertEqual(deckData?.data?[1].front, "front2")
    }

    func testAddCardsToDeck() {
        let mock = ModckDataLoader()
        mock.data = addCardData
        let client = NetworkClient(networkDataLoader: mock)

        var deckData: Deck?
        let card1 = CardData(front: "testadd1", back: "testadd2")
        let card2 = CardData(front: "testadd3", back: "testadd4")
        let cards: [CardData] = [ card1, card2 ]
        let user = User("r4Ok4g9OA5UHtpXnDRqF5XFCduH3")
        let expect = expectation(description: "Wait for deck to add cards")

        client.post(user: user, deckName: "iosTest", icon: "", tags: [""], cards: cards, add: true) { (deck: Deck?) in
            deckData = deck
            expect.fulfill()
        }

        wait(for: [expect], timeout: 100)

        XCTAssertNotNil(deckData)
        XCTAssertEqual(deckData?.deckInformation.deckLength, 4)
    }

    func testDeleteDeck() {
        let mock = ModckDataLoader()

        let client = NetworkClient(networkDataLoader: mock)

        var deckInfo1 = DeckInformation(icon: "", tags: [""])
        deckInfo1.collectionId = "iosTest1"
        var deckInfo2 = DeckInformation(icon: "", tags: [""])
        deckInfo2.collectionId = "iosTest2"
        let deck1 = Deck(deckInfo: deckInfo1, data: [])
        let deck2 = Deck(deckInfo: deckInfo2, data: [])
        var decks = [deck1, deck2]
        let user = User("r4Ok4g9OA5UHtpXnDRqF5XFCduH3")
        let expect = expectation(description: "Wait for deck to delete")

        client.delete(user: user, deck: decks[0], deleteCards: nil) { deck in
            if let deck = deck,
                let index = decks.firstIndex(of: deck) {
                decks.remove(at: index)
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
        XCTAssertEqual(decks.count, 1)
    }

    func testDeleteCards() {
        let mock = ModckDataLoader()
        mock.data = deletedCardData
        let client = NetworkClient(networkDataLoader: mock)

        var deckInfo1 = DeckInformation(icon: "", tags: [""])
        deckInfo1.collectionId = "iosTest"
        var card1info = CardData(front: "testadd3", back: "testadd4")
        card1info.id = "8d960d4c-dc98-4e80-aba4-22d2e712cf22"
        card1info.archived = false
        var card2info = CardData(front: "testadd3", back: "testadd4")
        card2info.id = "1a5e0b5e-1af3-48cb-87a5-aa49d4b3897f"
        card2info.archived = false
        let cards = [card1info, card2info]
        var deck = Deck(deckInfo: deckInfo1, data: [])

        let user = User("r4Ok4g9OA5UHtpXnDRqF5XFCduH3")
        let expect = expectation(description: "Wait for deck to delete")

        client.delete(user: user, deck: deck, deleteCards: cards) { updateDeck in
            if let updatedDeck = updateDeck {
                deck = updatedDeck
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 100)
        XCTAssertEqual(deck.data?.count, 2)
    }

    func testUpdateDeckName() {
        let mock = ModckDataLoader()
        mock.data = updatedDeckNameData
        let client = NetworkClient(networkDataLoader: mock)

        var deckInfo1 = DeckInformation(icon: "", tags: [""])
        deckInfo1.collectionId = "iosTest"
        deckInfo1.deckName = "iosTest"
        var deck = Deck(deckInfo: deckInfo1, data: [])

        let user = User("r4Ok4g9OA5UHtpXnDRqF5XFCduH3")
        let expect = expectation(description: "Wait for deck to update deck name")

        client.put(user: user, deck: deck, updateDeckName: "iosTestChanges", updateCards: nil) { (updatedDeckInfoDictionary: [String: DeckInformation]?) in
            if let updatedDeckInfoDictionary = updatedDeckInfoDictionary,
                let deckInformation = updatedDeckInfoDictionary["deckInformation"] {
                deck.deckInformation = deckInformation
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
        XCTAssertEqual(deck.deckInformation.deckName, "iosTestChanges")
    }

    func testUpdateCardInDeck() {
        let mock = ModckDataLoader()
        mock.data = updatedDeckCardData
        let client = NetworkClient(networkDataLoader: mock)

        var deckInfo1 = DeckInformation(icon: "", tags: [""])
        deckInfo1.collectionId = "iosTest"
        deckInfo1.deckName = "iosTest"
        var deck = Deck(deckInfo: deckInfo1, data: [])

        var card1info = CardData(front: "1changes", back: "1update")
        card1info.id = "1adf546f-428b-490f-b503-a753a95cb59c"
        card1info.archived = false

        let user = User("r4Ok4g9OA5UHtpXnDRqF5XFCduH3")
        let expect = expectation(description: "Wait for deck to update card")

        client.put(user: user, deck: deck, updateDeckName: nil, updateCards: [card1info]) { (updatedDeck: Deck?) in
            if let updatedDeck = updatedDeck {
                deck.data = updatedDeck.data
            }
            expect.fulfill()
        }

        wait(for: [expect], timeout: 100)
        XCTAssertEqual(deck.data?[1].back, "1update")
        XCTAssertEqual(deck.data?[1].front, "1changes")
    }

}
