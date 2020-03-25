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
    let networkClient: NetworkClient

    // MARK: - Init
    init(networkDataLoader: NetworkDataLoader = URLSession.shared) {
        self.dataLoader = networkDataLoader
        self.networkClient = NetworkClient(networkDataLoader: networkDataLoader)
    }

    // MARK: - Networking
    // Getting All Demo Decks & their names
    func getAllDemoDecks(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        getDemoDecks {
            for deck in self.demoDecks {
                dispatchGroup.enter()
                self.getDemoDeckCards(deckName: deck.deckName) {
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            print("Finished fetching Demo Decks")
            completion()
        }
    }

    func getDemoDecks(completion: @escaping () -> Void) {

        var request = URLRequest(url: baseURL)
        request.httpMethod = HTTPMethod.get.rawValue

        dataLoader.loadData(using: request) { (data, response, error) in
            if let _ = error { completion(); return }

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

    //Fetch just deck information
    func fetchDeckInfo(userID: String, completion: @escaping ([DeckInformation]?) -> Void) {
        networkClient.fetch(userID, nil) { (results: [DeckInformation]?) in
            guard let results = results else { completion(nil); return }
            completion(results)
            return
        }
    }

    // Fetches the cards for the deck using deck information
    func fetchDeckCardsWithInfo(userID: String, decks: [DeckInformation], completion: @escaping(String) -> Void) {
        let deckGroup = DispatchGroup()
        for deck in decks {
            deckGroup.enter()
            self.networkClient.fetch(userID, deck.collectionId) { (result: Deck?) in
                if let result = result {
                    self.decks.append(result)
                    deckGroup.leave()
                } else { completion("\(deck.collectionId!) cards did not fetch") }
            }
        }
        deckGroup.notify(queue: .main) {
            completion("Finished Fetching decks")
        }
    }
    
    // Fetch decks
    func fetchDecks(userID: String, completion: @escaping () -> Void) {
        fetchDeckInfo(userID: userID) { deckInfos in
            if let decks = deckInfos {
                if !decks.isEmpty {
                    self.fetchDeckCardsWithInfo(userID: userID, decks: decks) { result in
                        print(result)
                        completion()
                    }
                } else {completion()}
            }
        }
    }
    
    // Fetching archived decks
    func fetchArchivedDecks(userID: String, completion: @escaping () -> Void) {
        networkClient.fetch(userID, nil, true) { (results: [DeckInformation]?) in
            if let results = results,
                !results.isEmpty {
                for deck in results {
                    let archivedDeck = Deck(deckInfo: deck)
                    self.archivedDecks.append(archivedDeck)
                }
                completion()
            } else {
                completion()
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
    func editDeckName(deck: Deck, user: User, updatedDeckName: String, completion: @escaping (DeckInformation) -> Void) {
        networkClient.put(user: user, deck: deck, updateDeckName: updatedDeckName, updateCards: nil) { (result: [String: DeckInformation]?) in
            if let deckInfoDict = result {
                if let deckInfo = deckInfoDict["deckInformation"] {
                    completion(deckInfo)
                }
            }
        }
    }
    
    // Network call editing the cards inside of a deck
    func editDeckCards(deck: Deck, user: User, cards: [CardData], completion: @escaping (Deck) -> Void) {
        networkClient.put(user: user, deck: deck, updateDeckName: nil, updateCards: cards) { (result: Deck?) in
            if let deck = result {
                completion(deck)
            }
        }
    }
    
    // Adding cards to the server
    func addCardsToServer(user: User, name: String, cards: [CardData], completion: @escaping (Deck) -> Void) {
        networkClient.post(user: user, deckName: name, icon: "", tags: [""], cards: cards, add: true) { (result: Deck?) in
            if let deck = result {
                completion(deck)
            }
        }
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
    
    // Fetching cards when they are active / unarchived
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
    
    func archiveCard(deck: Deck, user: User, card: CardData, completion: @escaping () -> Void) {
        networkClient.put(user: user, deck: deck, updateDeckName: nil, updateCards: [card]) { (result: Deck?) in
           completion()
        }
    }
    
    
}



