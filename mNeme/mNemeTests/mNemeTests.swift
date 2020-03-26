//
//  mNemeTests.swift
//  mNemeTests
//
//  Created by Dennis Rudolph on 2/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import XCTest
@testable import mNeme

class mNemeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    
    
    
    
    //

    func testLoadingADeck() {
        let viewController = DeckCardViewController()


        let mock = ModckDataLoader()
        mock.data = userWithData
        let deckController = DeckController(networkDataLoader: mock)
        let decoder = JSONDecoder()
        let decodedDeck = try! decoder.decode(DemoDeck.self, from: shortDeck)
        //deckController.demoDecks[0] = decodedDeck
        viewController.demoDeck = decodedDeck
    }
    
    
    
    
    
    
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
