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

let createDeckData = """
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
    "exampleCard": "front1"
  },
  "data": [
    {
      "id": "2698039a-7bb7-4534-92c2-f0ad827cda0a",
      "data": {
        "front": "front1",
        "archived": false,
        "back": "back1"
      }
    },
    {
      "id": "f2dc2e7b-9c68-4b69-b818-bf65e0ff8f7c",
      "data": {
        "archived": false,
        "back": "back2",
        "front": "front2"
      }
    }
  ]
}
""".data(using: .utf8)!

let addCardData = """
{
  "deckInformation": {
    "deckName": "iosTest",
    "deckLength": 4,
    "icon": "",
    "tags": [
      "Intro"
    ],
    "createdBy": "r4Ok4g9OA5UHtpXnDRqF5XFCduH3",
    "exampleCard": "1c",
    "collectionId": "iosTest"
  },
  "data": [
    {
      "id": "a5405cd3-eb08-4ba4-8da8-1526bb70025e",
      "data": {
        "archived": false,
        "back": "add3",
        "front": "add4"
      }
    },
    {
      "id": "c080f871-1643-4f5e-8d42-60a8a4cf6e1b",
      "data": {
        "archived": false,
        "back": "add1",
        "front": "add2"
      }
    },
    {
      "id": "d9ebbf4e-8392-47fc-8b80-573eb573eee5",
      "data": {
        "archived": false,
        "back": "2",
        "front": "2c"
      }
    },
    {
      "id": "e3a21807-b560-4531-8a92-b49c8e7ddf18",
      "data": {
        "archived": false,
        "back": "1",
        "front": "1c"
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
