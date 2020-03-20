//
//  MockDemoDeckJSON.swift
//  mNemeTests
//
//  Created by Lambda_School_Loaner_204 on 3/19/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

let demoDecks = """
[
  {
    "deckName": "Biology",
    "demo": true
  },
  {
    "deckName": "mNeme",
    "demo": true
  }
]
""".data(using: .utf8)!

let demoDeckMNeme = """
{
  "deckName": "mNeme",
  "data": [
    {
      "id": "9qzYSx8CK7AgLaOAgZ4a",
      "data": {
        "front": "mNeme Team",
        "back": "Greg Johnston,  Tyler Thompson, William Berlin, Rayven Burns,  Ndawi Eke, Patrick Chow, Sarina Garg, Kyla Sweeney,"
      }
    },
    {
      "id": "DUXAdcb2lM2US70hJWeE",
      "data": {
        "back": "Spaced repetition is an evidence-based learning technique that is usually performed with flashcards",
        "front": "Spaced Repetition"
      }
    },
    {
      "id": "K6iATp6sFPPF7Jl6VGR1",
      "data": {
        "back": "a card containing a small amount of information; an aid to learning.",
        "front": "Flashcard"
      }
    },
    {
      "id": "fJH6rn46Pfm7srNg1fSp",
      "data": {
        "back": "A widely used method of efficiently using flashcards that was proposed by the German science journalist Sebastian Leitner in the 1970s. It is a simple implementation of the principle of spaced repetition, where cards are reviewed at increasing intervals.",
        "front": "Leitner System"
      }
    },
    {
      "id": "jg2H8vAvjpWrBCYrlvl5",
      "data": {
        "back": "comprehensive knowledge or skill in a subject or accomplishment",
        "front": "Self-Rating"
      }
    },
    {
      "id": "nhedkm0mwE21gtd0eyGn",
      "data": {
        "back": "The act of thinking about how well you know given content",
        "front": "Metacognition"
      }
    },
    {
      "id": "p8MObalaiZLBS1MZw2Oo",
      "data": {
        "front": "Active Recall",
        "back": "Attempting to remember a concept from scratch"
      }
    },
    {
      "id": "q7plyvCoe4dK7BqF3TgL",
      "data": {
        "back": "a small digital image or icon used to express an idea, emotion, etc.",
        "front": "Emoji"
      }
    },
    {
      "id": "wRAXBGC66Si1UUHjjVr4",
      "data": {
        "back": "In Greek mythology, mNeme /ˈniːmi/ (Greek: Μνήμη Mnḗmē) was one of the three original (Boeotian) muses. mNeme is the muse of memory",
        "front": "mNeme"
      }
    },
    {
      "id": "xJIUd7La13CI78XgSpKg",
      "data": {
        "back": "comprehensive knowledge or skill in a subject or accomplishment",
        "front": "Mastery"
      }
    }
  ]
}
""".data(using: .utf8)!
