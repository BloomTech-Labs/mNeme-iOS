//
//  MockDeckJSON.swift
//  mNemeTests
//
//  Created by Lambda_School_Loaner_204 on 3/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation


let collectionIdDeckData = """
[
    {
      "deckName": "asdsdsa",
      "deckLength": 1,
      "icon": "",
      "tags": [],
      "createdBy": "4tfTrhRdAYMxZNwXmPrcnEoyidE3",
      "exampleCard": "sadsa",
      "collectionId": "asdsdsa"
    }
]
""".data(using: .utf8)!


let deckInfromationData = """
{
  "deckInformation": {
    "icon": "",
    "tags": [],
    "createdBy": "4tfTrhRdAYMxZNwXmPrcnEoyidE3",
    "exampleCard": "xzcz",
    "collectionId": "ssss",
    "deckName": "ssss",
    "deckLength": 1
  },
  "data": [
    {
      "id": "e0a14606-d6dc-48f2-a1ae-ebb21a5d6888",
      "data": {
        "archived": false,
        "back": "xzczxcxzc",
        "front": "xzcz"
      }
    }
  ]
}
""".data(using: .utf8)!
