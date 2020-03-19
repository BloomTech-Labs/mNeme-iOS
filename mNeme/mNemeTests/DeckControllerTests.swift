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

    func testEditDeckCards() {
        
    }
}
