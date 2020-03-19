//
//  DeckControllerTests.swift
//  mNemeTests
//
//  Created by Lambda_School_Loaner_204 on 3/18/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import XCTest

@testable import mNeme

class DeckControllerTests: XCTestCase {

    func testGetDemoDecks() {
        let mock = ModckDataLoader()
        mock.data = demoDecks
        let deckController = DeckController(networkDataLoader: mock)

        let expect = expectation(description: "Wait for Demo decks to return from API")

        deckController.getDemoDecks {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
        XCTAssertTrue(deckController.demoDecks.count > 0)
    }

    func testGetDemoDeckCards() {
        let mock = ModckDataLoader()
        mock.data = demoDeckMNeme
        let deckController = DeckController(networkDataLoader: mock)
        let demoDeck = DemoDeck(deckName: "mNeme", data: nil)
        deckController.demoDecks.append(demoDeck)

        let expect = expectation(description: "Wait for demo deck cards to return from API")

        deckController.getDemoDeckCards(deckName: "mNeme") {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
        XCTAssertEqual(deckController.demoDecks[0].deckName, "mNeme")
        XCTAssertNotNil(deckController.demoDecks[0].data)
        XCTAssertTrue(deckController.demoDecks[0].data!.count > 0)
    }

    /// TODO: Need to refactor to test fetching decks all logic in one function, hard to make data call.
    func testFetchingDecks() {

//        let mock = ModckDataLoader()
//        mock.data = collectionIdDeckData
//        let deckController = DeckController(networkDataLoader: mock)
//
//        let expect = expectation(description: "Wait for deck information to return from API")
//
//        deckController.fetchDecks(userID: "userID") {
//            expect.fulfill()
//        }
//
//        wait(for: [expect], timeout: 2)
//        XCTAssertTrue(deckController.decks.count > 0)
//        XCTAssertEqual(deckController.decks[0].deckInformation.collectionId, "iosTest")
    }

    func testFetchingArchivedDecks() {
        let mock = ModckDataLoader()
        mock.data = collectionIdDeckData
        let deckController = DeckController(networkDataLoader: mock)

        let expect = expectation(description: "Wait for archived decks information to return from API")

        deckController.fetchArchivedDecks(userID: "user") {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
        XCTAssertTrue(deckController.archivedDecks.count > 0)
        XCTAssertEqual(deckController.archivedDecks[0].deckInformation.collectionId, "iosTest")
    }

    func testCreateDeck() {
        let mock = ModckDataLoader()
        mock.data = createDeckData
        let deckController = DeckController(networkDataLoader: mock)

        let expect = expectation(description: "Wait for create deck information to return from API")
        let user = User("user")
        let cards = [CardData]()
        deckController.createDeck(user: user, name: "iosTest", icon: "", tags: [""], cards: cards) {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
        XCTAssertTrue(deckController.decks.count > 0)
        XCTAssertNotNil(deckController.decks[0].data)
        XCTAssertTrue(deckController.decks[0].data!.count > 0)
    }

    func testEditDeckName() {
        let mock = ModckDataLoader()
        mock.data = updatedDeckNameData
        let deckController = DeckController(networkDataLoader: mock)
        mock.data = deckInfromationData
        let networkClient = NetworkClient(networkDataLoader: mock)

        var deck: Deck?
        let expectDeck = expectation(description: "Wait for deck information to return from API")
        networkClient.fetch("user", "iosTest") { (result: Deck?) in
            deck = result
            expectDeck.fulfill()
        }

        wait(for: [expectDeck], timeout: 2)
        XCTAssertNotNil(deck)

        deckController.decks.append(deck!)

        let expect = expectation(description: "Wait for update deck name information to return from API")
        let user = User("user")

        let nameChange = "iosTestChanges"
        deckController.editDeckName(deck: deck!, user: user, name: nameChange) {
            deckController.changeDeckName(deck: deck!, newName: nameChange)
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
        XCTAssertEqual(deckController.decks[0].deckInformation.deckName, nameChange)
    }

    /// TODO: Need to figure out how to edit cards from deckcontroller
    func testEditDeckCards() {
        
    }

    func testAddCardToDeck() {
        let mock = ModckDataLoader()
        mock.data = addCardData
        let deckController = DeckController(networkDataLoader: mock)
        mock.data = deckInfromationData
        let networkClient = NetworkClient(networkDataLoader: mock)

        var deck: Deck?
        let expectDeck = expectation(description: "Wait for deck information to return from API")
        networkClient.fetch("user", "iosTest") { (result: Deck?) in
            deck = result
            expectDeck.fulfill()
        }

        wait(for: [expectDeck], timeout: 2)
        XCTAssertNotNil(deck)

        deckController.decks.append(deck!)

        let expect = expectation(description: "Wait for add card information to return from API")
        let user = User("user")

        let card1 = CardData(front: "add2", back: "add1")
        let card2 = CardData(front: "add4", back: "add3")
        let cards = [card1, card2]

        let _ = deckController.addCardToDeck(deck: deck!, card: card1)
        let _ = deckController.addCardToDeck(deck: deck!, card: card2)
        deckController.addCardsToServer(user: user, name: "iosTest", cards: cards) {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
        XCTAssertNotNil(deckController.decks[0].data)
        XCTAssertTrue(deckController.decks[0].data!.count > 2)
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

    func testDeleteCardFromDeck() {
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

        wait(for: [expect], timeout: 2)
        XCTAssertEqual(deck.data?.count, 2)
    }

    func testArchiveDeck() {
        let mock = ModckDataLoader()
        let deckController = DeckController(networkDataLoader: mock)

        let user = User("user")
        let deckInfo = DeckInformation(icon: "", tags: [""])
        let deck = Deck(deckInfo: deckInfo)
        deckController.decks.append(deck)
        let expect = expectation(description: "Wait for deck to archive")

        deckController.archiveDeck(user: user, collectionID: "iosTest", index: 0) {
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)
        XCTAssertEqual(deckController.decks.count, 0)
        XCTAssertTrue(deckController.archivedDecks.count > 0)
    }

    func testUnArchiveDeck() {
        let mock = ModckDataLoader()
        mock.data = cardData
        let deckController = DeckController(networkDataLoader: mock)

        //let user = User("user")
        let deckInfo = DeckInformation(icon: "", tags: [""])
        let deck = Deck(deckInfo: deckInfo)
        deckController.archivedDecks.append(deck)
        let expect = expectation(description: "Wait for deck to unarchive")

//        deckController.unarchiveDeck(user: user, collectionID: "iosTest", index: 0) {
//            expect.fulfill()
//        }
        deckController.fetchCardsWhenUnarchived(userID: "user", deckCollectionID: "iosTest", index: 0) { success in
            if success { expect.fulfill() }
        }


        wait(for: [expect], timeout: 2)
        XCTAssertEqual(deckController.archivedDecks.count, 0)
        XCTAssertTrue(deckController.decks.count > 0)
    }
}
