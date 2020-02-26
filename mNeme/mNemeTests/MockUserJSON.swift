//
//  MockUserJSON.swift
//  mNemeTests
//
//  Created by Lambda_School_Loaner_204 on 2/24/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

let userWithData = """
{
  "id": "r4Ok4g9OA5UHtpXnDRqF5XFCduH3",
  "data": {
    "id": "r4Ok4g9OA5UHtpXnDRqF5XFCduH3",
    "notificationFrequency": "Don't send me notifications",
    "favSubjects": "Math, Science",
    "studyFrequency": "Once a day",
    "MobileOrDesktop": "Desktop",
    "customOrPremade": "pre-made"
  }
}
""".data(using: .utf8)!

let deckData = """
{
"deckName": "mNeme",
"data": [
  {
    "id": "9qzYSx8CK7AgLaOAgZ4a",
    "data": {
      "back": "Greg Johnston,  Tyler Thompson, William Berlin, Rayven Burns,  Ndawi Eke, Patrick Chow, Sarina Garg, Kyla Sweeney,",
      "front": "mNeme Team"
    }
  },
  {
    "id": "DUXAdcb2lM2US70hJWeE",
    "data": {
      "back": "Spaced repetition is an evidence-based learning technique that is usually performed with flashcards",
      "front": "Spaced Repetition"
    }
  }
}
""".data(using: .utf8)!

let userWithoutData = """
{
  "id": "r4Ok4g9OA5UHtpXnDRqF5XFCduH3",
  "data": {
  }
}
""".data(using: .utf8)!
