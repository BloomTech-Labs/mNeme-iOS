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
}
