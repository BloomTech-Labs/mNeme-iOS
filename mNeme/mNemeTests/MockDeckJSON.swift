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


let deletedCardData = """
{
  "deckInformation": {
    "icon": "",
    "tags": [
      "Intro"
    ],
    "createdBy": "r4Ok4g9OA5UHtpXnDRqF5XFCduH3",
    "collectionId": "iosTest",
    "deckName": "iosTest",
    "deckLength": 1
  },
  "data": [
    {
      "id": "6bd55cf5-aacb-450b-8906-dd75db99a71f",
      "data": {
        "archived": false,
        "back": "2",
        "front": "2c"
      }
    }
  ]
}
""".data(using: .utf8)!

let updatedDeckNameData = """
{
  "deckInformation": {
    "icon": "",
    "tags": [
      "Intro"
    ],
    "createdBy": "r4Ok4g9OA5UHtpXnDRqF5XFCduH3",
    "exampleCard": "1c",
    "collectionId": "iosTest",
    "deckName": "iosTestChanges",
    "deckLength": 2
  }
}
""".data(using: .utf8)!


let updatedDeckCardData = """
{
  "deckInformation": {
    "collectionId": "iosTest",
    "deckName": "iosTest",
    "deckLength": 2,
    "icon": "",
    "tags": [
      "Intro"
    ],
    "createdBy": "r4Ok4g9OA5UHtpXnDRqF5XFCduH3",
    "exampleCard": "1c"
  },
  "data": [
    {
      "id": "2698039a-7bb7-4534-92c2-f0ad827cda0a",
      "data": {
        "front": "2c",
        "archived": false,
        "back": "2"
      }
    },
    {
      "id": "f2dc2e7b-9c68-4b69-b818-bf65e0ff8f7c",
      "data": {
        "archived": false,
        "back": "1update",
        "front": "1changes"
      }
    }
  ]
}
""".data(using: .utf8)!
