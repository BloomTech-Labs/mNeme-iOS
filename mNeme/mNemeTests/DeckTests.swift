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

        var deckData: [DeckCollectionId]?
        let expect = expectation(description: "Wait for Deck data to return from API")

        client.fetch("", nil) { (deck: [DeckCollectionId]?) in
            deckData = deck
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)

        XCTAssertNotNil(deckData?[0])
        XCTAssertEqual(deckData?[0].collectionId, "asdsdsa")
    }

    func testGetDeckInformation() {
        let mock = ModckDataLoader()
        mock.data = deckInfromationData

        let client = NetworkClient(networkDataLoader: mock)

        var deckData: Deck?
        let expect = expectation(description: "Wait for Deck data to return from API")

        client.fetch("", "") { (deck: Deck?) in
            deckData = deck
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)

        XCTAssertNotNil(deckData)
        XCTAssertEqual(deckData?.deckInformation.exampleCard, "xzcz")
        XCTAssertEqual(deckData?.data[0].data.back, "xzczxcxzc")
    }

    func testPostDeck() {
        let client = NetworkClient()

        var deckData: Deck?
        let card1 = CardRep(front: "front1", back: "back1")
        let card2 = CardRep(front: "front2", back: "back2")
        let cards: [CardRep] = [ card1, card2 ]
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
        XCTAssertEqual(deckData?.data[0].data.back, "back1")
    }

}
