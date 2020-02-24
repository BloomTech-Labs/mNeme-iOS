//
//  UserPreferencesTests.swift
//  mNemeTests
//
//  Created by Lambda_School_Loaner_204 on 2/24/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import XCTest

@testable import mNeme

class UserPreferencesTests: XCTestCase {

    func testGetUserWithData() {
        let mock = ModckDataLoader()
        mock.data = userWithData

        let expect = expectation(description: "Wait for User Preferences to return from API")

        wait(for: [expect], timeout: 2)
    }

}
