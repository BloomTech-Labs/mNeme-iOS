//
//  DemoDeckController.swift
//  mNeme
//
//  Created by Lambda_School_Loaner_204 on 2/26/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class DemoDeckController {

    // MARK: - Properties

    var demoDecks = [DemoDeck]()
    var decks = [Deck]()
    let dataLoader: NetworkDataLoader
    let baseURL = URL(string: "https://flashcards-be.herokuapp.com/api/demo/I2r2gejFYwCQfqafWlVy")!
    let networkClient = NetworkClient()

    // MARK: - Init
    init(networkDataLoader: NetworkDataLoader = URLSession.shared) {
        self.dataLoader = networkDataLoader
    }

    // MARK: - Networking
    // Getting All Demo Decks & their names
    func getDemoDecks(completion: @escaping () -> Void) {

        var request = URLRequest(url: baseURL)
        request.httpMethod = HTTPMethod.get.rawValue

        dataLoader.loadData(using: request) { (data, response, error) in
            if let error = error {
                print("\(error)")
                completion()
                return
            }

            guard let data = data else { completion(); return }

            do {
                if let deckInfo = try JSONSerialization.jsonObject(with: data, options: []) as? Array<[String: Any]> {
                    for deck in deckInfo {
                        if let deckName = deck["deckName"] as? String {
                            let demoDeck = DemoDeck(deckName: deckName, data: nil)
                            self.demoDecks.append(demoDeck)
                        }
                    }
                }
            } catch {
                print("Error decoding demo decks")
            }
            completion()
        }
    }
    
    // Getting specific cards from Demodecks
    func getDemoDeckCards(deckName: String, completion: @escaping () -> Void) {
        let requestURL = baseURL.appendingPathComponent(deckName)
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue

        dataLoader.loadData(using: request) { (data, response, error) in
            if let error = error {
                print("\(error)")
                completion()
                return
            }

            guard let data = data else { completion(); return }
            let jsonDecoder = JSONDecoder()
            do {
                let demoDeck = try jsonDecoder.decode(DemoDeck.self, from: data)
                if let deckIndex = self.demoDecks.firstIndex(where: { $0.deckName == deckName }) {
                    self.demoDecks[deckIndex].data = demoDeck.data
                }
            } catch {
                print("Error Decoding deck card data")
            }
            completion()
        }
    }
    
    func fetchDecks(userID: String, completion: @escaping () -> Void) {
        networkClient.fetch(userID, nil) { (results: [DeckInformation]?) in
            if let results = results {
                for deck in results {
                    self.networkClient.fetch(userID, deck.collectionId) { (result: Deck?) in
                        self.decks.append(result!)
                    }
                }
                completion()
            } else {
                print("Fetch not working")
            }
        }
    }
    
    func createDeck(user: User, name: String, icon: String, tags: [String], cards: [CardData], completion: @escaping () -> Void) {
        networkClient.post(user: user, deckName: name, icon: icon, tags: tags, cards: cards) { (deck: Deck?) in
            if let deck = deck {
                self.decks.append(deck)
                completion()
            }
        }
    }
    
    func editDeckName(deck: Deck, user: User, name: String, completion: @escaping () -> Void) {
        networkClient.put(user: user, deck: deck, updateDeckName: name, updateCards: nil) { (result: [String: DeckInformation]?) in
            if let result = result, let deckInfo = result["deckInformation"], let index = self.decks.firstIndex(of: deck) {
                self.decks[index].deckInformation = deckInfo
                completion()
            }
        }
    }
        
    func editDeckCards(deck: Deck, user: User, cards: [CardData], completion: @escaping () -> Void) {
        networkClient.put(user: user, deck: deck, updateDeckName: nil, updateCards: cards) { (result: Deck?) in
            if let result = result, let index = self.decks.firstIndex(of: deck) {
                self.decks[index].data = result.data
                completion()
            }
        }
    }
    
    
    func addCardsToServer(user: User, name: String, cards: [CardData], completion: @escaping () -> Void) {
        networkClient.post(user: user, deckName: name, icon: "", tags: [""], cards: cards, add: true) { (deck: Deck?) in
            completion()
        }
    }
    
    func addCardToDeck(deck: Deck, card: CardData) -> [CardData]{
        guard let index = decks.firstIndex(of: deck) else { return [] }
        decks[index].data?.insert(card, at: 0)
        guard let newDeckArray = decks[index].data else { return [] }
        return newDeckArray
    }
    
    
    
    
    
}



