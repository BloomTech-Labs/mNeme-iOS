//
//  DemoDeckController.swift
//  mNeme
//
//  Created by Lambda_School_Loaner_204 on 2/26/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class DeckController {

    // MARK: - Properties
    var demoDecks = [DemoDeck]()
    var decks = [Deck]()
    var archivedDecks = [Deck]()
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
    
    // Fetching decks
    func fetchDecks(userID: String, completion: @escaping () -> Void) {
        let deckGroup = DispatchGroup()
        networkClient.fetch(userID, nil) { (results: [DeckInformation]?) in
            if let results = results {
                if !results.isEmpty {
                    for deck in results {
                        deckGroup.enter()
                        self.networkClient.fetch(userID, deck.collectionId) { (result: Deck?) in
                            self.decks.append(result!)
                            deckGroup.leave()
                        }
                    }
                    deckGroup.notify(queue: .main) {
                        completion()
                    }
                } else {
                    completion()
                }
            } else {
                print("Fetch not working")
            }
        }
    }
    
    // Fetching archived decks
    func fetchArchivedDecks(userID: String, completion: @escaping () -> Void) {
        networkClient.fetch(userID, nil, true) { (results: [DeckInformation]?) in
            if let results = results {
                if !results.isEmpty {
                    for deck in results {
                        let archivedDeck = Deck(deckInfo: deck)
                        self.archivedDecks.append(archivedDeck)
                    }
                    completion()
                } else {
                    completion()
                }
            } else {
                print("Fetch not working")
            }
        }
    }
    
    // Creating decks
    func createDeck(user: User, name: String, icon: String, tags: [String], cards: [CardData], completion: @escaping () -> Void) {
        networkClient.post(user: user, deckName: name, icon: icon, tags: tags, cards: cards) { (deck: Deck?) in
            if let deck = deck {
                self.decks.append(deck)
                completion()
            }
        }
    }
    
    // Network call editing only the deck name
    func editDeckName(deck: Deck, user: User, name: String, completion: @escaping () -> Void) {
        networkClient.put(user: user, deck: deck, updateDeckName: name, updateCards: nil) { (result: [String: DeckInformation]?) in
            completion()
        }
    }
    
    // Network call editing the cards inside of a deck
    func editDeckCards(deck: Deck, user: User, cards: [CardData], completion: @escaping () -> Void) {
        networkClient.put(user: user, deck: deck, updateDeckName: nil, updateCards: cards) { (result: Deck?) in
           completion()
        }
    }
    
    // Adding cards to the server
    func addCardsToServer(user: User, name: String, cards: [CardData], completion: @escaping () -> Void) {
        networkClient.post(user: user, deckName: name, icon: "", tags: [""], cards: cards, add: true) { (deck: Deck?) in
            completion()
        }
    }
    
    // Adding cards locally to the DeckController
    func addCardToDeck(deck: Deck, card: CardData) -> [CardData]{
        guard let index = decks.firstIndex(of: deck) else { return [] }
        decks[index].data?.insert(card, at: 0)
        guard let newDeckArray = decks[index].data else { return [] }
        return newDeckArray
    }
    
    // Changing the deck name locally in DeckController
    func changeDeckName(deck: Deck, newName: String) {
        guard let index = decks.firstIndex(of: deck) else { return }
        self.decks[index].deckInformation.deckName = newName
    }
    
    // Deleting deck from server
    func deleteDeckFromServer(user: User, deck: Deck) {
        networkClient.delete(user: user, deck: deck, deleteCards: nil) { (result) in
            print("Deck Deleted")
        }
    }
    
    // Deleting card from server
    func deleteCardFromServer(user: User, deck: Deck, card: CardData) {
        networkClient.delete(user: user, deck: deck, deleteCards: [card]) { (result) in
            print("Card Deleted")
        }
    }
    
    // Archiving a deck w/ the network
    func archiveDeck(user: User, collectionID: String, index: Int, completion: @escaping () -> Void) {
        networkClient.archivePost(user: user, deckName: collectionID, archive: true) {
            let deck = self.decks[index]
            self.archivedDecks.insert(deck, at: 0)
            self.decks.remove(at: index)
            completion()
        }
    }
    
    // Unarchiving deck w/ the network
    func unarchiveDeck(user: User, collectionID: String, index: Int, completion: @escaping () -> Void) {
        networkClient.archivePost(user: user, deckName: collectionID, archive: false) {
            print(collectionID)
            self.fetchCardsWhenUnarchived(userID: user.id, deckCollectionID: collectionID, index: index) { (success) in
                if success {
                    print("cards fetched")
                } else {
                    print("cards not fetched")
                }
                completion()
            }
        }
    }
    
    func fetchCardsWhenUnarchived(userID: String, deckCollectionID: String, index: Int, completion: @escaping(Bool) -> Void) {
        print(deckCollectionID)
        // Check for card data return
        self.networkClient.fetch(userID, deckCollectionID) { (deckData: [String: [CardData]]?) in
            if let deckData = deckData {
                var deck = self.archivedDecks[index]
                deck.data = deckData["data"]
                self.decks.append(deck)
                self.archivedDecks.remove(at: index)
                completion(true)
                return
            } else {
                // Sometimes happens, but the fetch actually returns a deck. Need this for odd cases
                self.networkClient.fetch(userID, deckCollectionID) { (result: Deck?) in
                    if let deck = result {
                        self.decks.append(deck)
                        self.archivedDecks.remove(at: index)
                        completion(true)
                        return
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }

    func deleteArchivedDeck(user: User, deck: Deck) {
        networkClient.delete(user: user, deck: deck, deleteCards: nil, archived: true) { (_) in
        }
    }
    
    func archiveCard(deck: Deck, user: User, cards: CardData, completion: @escaping () -> Void) {
        networkClient.put(user: user, deck: deck, updateDeckName: nil, updateCards: [cards]) { (result: Deck?) in
           completion()
        }
    }
    
    
}



