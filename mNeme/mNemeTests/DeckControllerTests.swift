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
}
