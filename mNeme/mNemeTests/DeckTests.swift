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
//
//    func testPostDeck() {
//        let client = NetworkClient()
//
//        var deckData: Deck?
//        let card1 = CardRep(id: nil, archived: nil, front: "front1", back: "back1")
//        let card2 = CardRep(id: nil, archived: nil, front: "front2", back: "back2")
//        let cards: [CardRep] = [ card1, card2 ]
//        let user = User("r4Ok4g9OA5UHtpXnDRqF5XFCduH3")
//        let expect = expectation(description: "Wait for deck to create and return")
//
//        client.post(user: user, deckName: "iosTest", icon: "", tags: ["test"], cards: cards) { (deck: Deck?) in
//            deckData = deck
//            expect.fulfill()
//        }
//
//        wait(for: [expect], timeout: 100)
//
//        XCTAssertNotNil(deckData)
//        XCTAssertEqual(deckData?.deckInformation.exampleCard, "front1")
//        XCTAssertEqual(deckData?.deckInformation.deckName, "iosTest")
//        XCTAssertEqual(deckData?.deckInformation.deckLength, 2)
//        XCTAssertEqual(deckData?.data?[0].data.back, "back1")
//    }
//
//    func testAddCardsToDeck() {
//        let client = NetworkClient()
//
//        var deckData: Deck?
//        let card1 = CardRep(id: nil, archived: nil, front: "testadd1", back: "testadd2")
//        let card2 = CardRep(id: nil, archived: nil, front: "testadd3", back: "testadd4")
//        let cards: [CardRep] = [ card1, card2 ]
//        let user = User("r4Ok4g9OA5UHtpXnDRqF5XFCduH3")
//        let expect = expectation(description: "Wait for deck to add cards")
//
//        client.post(user: user, deckName: "iosTest", icon: "", tags: [""], cards: cards, add: true) { (deck: Deck?) in
//            deckData = deck
//            expect.fulfill()
//        }
//
//        wait(for: [expect], timeout: 100)
//
//        XCTAssertNotNil(deckData)
//        XCTAssertEqual(deckData?.deckInformation.deckLength, 4)
//    }
//
//    func testDeleteDeck() {
//        let mock = ModckDataLoader()
//
//        let client = NetworkClient(networkDataLoader: mock)
//
//        let deckInfo1 = DeckInformation(icon: "", tag: [""], createdBy: "", exampleCard: "", collectionId: "iosTest", deckName: "iosTest", deckLength: 0)
//        let deckInfo2 = DeckInformation(icon: "", tag: [""], createdBy: "", exampleCard: "", collectionId: "iosTest2", deckName: "iosTest2", deckLength: 0)
//        let deck1 = Deck(deckInformation: deckInfo1, data: [])
//        let deck2 = Deck(deckInformation: deckInfo2, data: [])
//
//        var decks = [deck1, deck2]
//
//
//        let user = User("r4Ok4g9OA5UHtpXnDRqF5XFCduH3")
//        let expect = expectation(description: "Wait for deck to delete")
//
//        client.delete(user: user, deck: decks[0], deleteCards: nil) { deck in
//            if let deck = deck,
//                let index = decks.firstIndex(of: deck) {
//                decks.remove(at: index)
//            }
//            expect.fulfill()
//        }
//
//        wait(for: [expect], timeout: 2)
//        XCTAssertEqual(decks.count, 1)
//    }
//
//    func testDeleteCards() {
//        let mock = ModckDataLoader()
//        mock.data = deletedCardData
//        let client = NetworkClient(networkDataLoader: mock)
//
//        let deckInfo1 = DeckInformation(icon: "", tag: [""], createdBy: "", exampleCard: "", collectionId: "iosTest", deckName: "iosTest", deckLength: 0)
//
//        let card1info = CardData.CardInfo(back: "1", front: "1c")
//        let card2info = CardData.CardInfo(back: "2", front: "2c")
//        let card1 = CardData(id: "2a558d81-bb8b-4505-9bdc-2c1ce6857b68", data: card1info)
//        let card2 = CardData(id: "eff236b7-273b-47d8-897e-dc9d2ca02928", data: card2info)
//
//        var deck = Deck(deckInformation: deckInfo1, data: [card1, card2])
//
//        let user = User("r4Ok4g9OA5UHtpXnDRqF5XFCduH3")
//        let expect = expectation(description: "Wait for deck to delete")
//
//        client.delete(user: user, deck: deck, deleteCards: [card1]) { updateDeck in
//            if let updatedDeck = updateDeck {
//                deck = updatedDeck
//            }
//            expect.fulfill()
//        }
//
//        wait(for: [expect], timeout: 2)
//        XCTAssertEqual(deck.data?.count, 1)
//        XCTAssertEqual(deck.data?[0].id, "6bd55cf5-aacb-450b-8906-dd75db99a71f")
//        XCTAssertEqual(deck.data?[0].data.back, "2")
//    }
//
//    func testUpdateDeckName() {
//        let mock = ModckDataLoader()
//        mock.data = updatedDeckNameData
//
//        let client = NetworkClient(networkDataLoader: mock)
//
//        let deckInfo1 = DeckInformation(icon: "", tag: [""], createdBy: "", exampleCard: "", collectionId: "iosTest", deckName: "iosTest", deckLength: 0)
//
//        var deck = Deck(deckInformation: deckInfo1, data: [])
//
//        let user = User("r4Ok4g9OA5UHtpXnDRqF5XFCduH3")
//        let expect = expectation(description: "Wait for deck to update deck name")
//
//        client.put(user: user, deck: deck, updateDeckName: "iosTestChanges", updateCards: nil) { (updatedDeck: Deck?) in
//            if let updatedDeck = updatedDeck {
//                deck.deckInformation = updatedDeck.deckInformation
//            }
//            expect.fulfill()
//        }
//
//        wait(for: [expect], timeout: 2)
//        XCTAssertEqual(deck.deckInformation.deckName, "iosTestChanges")
//    }
//
//    func testUpdateCardInDeck() {
//        let mock = ModckDataLoader()
//        mock.data = updatedDeckCardData
//        let client = NetworkClient(networkDataLoader: mock)
//
//        let deckInfo1 = DeckInformation(icon: "", tag: [""], createdBy: "", exampleCard: "", collectionId: "iosTest", deckName: "iosTest", deckLength: 0)
//
//        var deck = Deck(deckInformation: deckInfo1, data: [])
//
//        let card1info = CardData.CardInfo(back: "1update", front: "1changes")
//
//        let updatedCards = CardData(id: "f2dc2e7b-9c68-4b69-b818-bf65e0ff8f7c", data: card1info)
//
//        let user = User("r4Ok4g9OA5UHtpXnDRqF5XFCduH3")
//        let expect = expectation(description: "Wait for deck to update card")
//
//        client.put(user: user, deck: deck, updateDeckName: nil, updateCards: [updatedCards]) { (updatedDeck: Deck?) in
//            if let updatedDeck = updatedDeck {
//                deck.data = updatedDeck.data
//            }
//            expect.fulfill()
//        }
//
//        wait(for: [expect], timeout: 100)
//        XCTAssertEqual(deck.data?[1].data.back, "1update")
//        XCTAssertEqual(deck.data?[1].data.front, "1changes")
//    }

}
