//
//  MockDeck.swift
//  mNeme
//
//  Created by Niranjan Kumar on 2/25/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

// MARK: File is for testing data and the MockDeck JSON structure

struct MockDemoDeck: Codable {
    var deckName: String
    var data: [MockCardData]
    
}

struct MockCardData: Codable {
    var id: String
    var data: MockCardInfo
}

struct MockCardInfo: Codable {
    var back, front: String
}

class MockDemoDeckController {
    
    var deck: MockDemoDeck?
    
    let shortDeck = """
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
        },
        {
          "id": "K6iATp6sFPPF7Jl6VGR1",
          "data": {
            "front": "Flashcard",
            "back": "a card containing a small amount of information; an aid to learning."
          }
        }
      ]
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
        },
        {
          "id": "K6iATp6sFPPF7Jl6VGR1",
          "data": {
            "front": "Flashcard",
            "back": "a card containing a small amount of information; an aid to learning."
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
            "back": "Attempting to remember a concept from scratch",
            "front": "Active Recall"
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
            "front": "Mastery",
            "back": "comprehensive knowledge or skill in a subject or accomplishment"
          }
        }
      ]
    }
    """.data(using: .utf8)!
    
    let dataLoader: NetworkDataLoader
    
    init(networkDataLoader: NetworkDataLoader = URLSession.shared) {
        self.dataLoader = networkDataLoader
    }
    enum deckLength {
        case short
        case long
    }
    
    // Decoding the JSON Mock DemoDeck
    func decodeMockData(deckLength: deckLength) -> MockDemoDeck? {
        var deckToUse = self.deckData
        if deckLength == .long {
            deckToUse = self.deckData
        } else if deckLength == .short {
            deckToUse = self.shortDeck
        }
        let decoder = JSONDecoder()
        do {
            let decodedMockData = try decoder.decode(MockDemoDeck.self, from: deckToUse)
            return decodedMockData
        } catch {
            NSLog("Did not work decoding mock data deck")
            return nil
        }
    }
    
}
