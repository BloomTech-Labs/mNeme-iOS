//
//  NetworkClient.swift
//  mNeme
//
//  Created by Lambda_School_Loaner_204 on 3/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class NetworkClient {

    private let baseURL = URL(string: "https://flashcards-be.herokuapp.com/api/deck")
    private let dataLoader: NetworkDataLoader

    // MARK: - Init
    init(networkDataLoader: NetworkDataLoader = URLSession.shared) {
        self.dataLoader = networkDataLoader
    }

    // Use this method to get deck data and card data.
    // Collection ID is optional -> nameofdeck == collectionID
    func fetch<T: Codable>(_ userId: String, _ colId: String?, _ archive: Bool = false, completion: @escaping (T?) -> Void) {
        guard let baseURL = baseURL else { completion(nil); return }

        var requestURL = archive ? baseURL.appendingPathComponent(userId).appendingPathComponent("archive") : baseURL.appendingPathComponent(userId)

        // if collection id is not nil it will return the card data.
        if let colId = colId {
            requestURL = archive ? requestURL.appendingPathComponent(colId).appendingPathComponent("archive") : requestURL.appendingPathComponent(colId)
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue

        dataLoader.loadData(using: request) { (data, response, error) in
            if let _ = error { completion(nil); return }

            guard let data = data else { completion(nil); return }
            print(String(data: data, encoding: .utf8)!)
            let jsonDecoder = JSONDecoder()
            do {
                let decodedData = try jsonDecoder.decode(T.self, from: data)
                print(decodedData)
                completion(decodedData)
            } catch {
                print("Error Decoding deck card data")
                completion(nil)
            }
        }
    }

    // Used to create decks and add cards to a deck
    func post<T: Codable>(user: User, deckName: String, icon: String, tags: [String], cards: [CardData], add: Bool = false, completion: @escaping (T?) -> Void) {

        guard let baseURL = baseURL else { completion(nil); return }

        var createDeckURL = baseURL.appendingPathComponent(user.id).appendingPathComponent(deckName)

        if add {
            createDeckURL = createDeckURL.appendingPathComponent("add")
        }

        var request = URLRequest(url: createDeckURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonEncoder = JSONEncoder()
        do {
            // Sets the encoded data based upon if the user passes in true to adding a card.
            // If true then sets it as a dictionary "cards", if not then init a DeckRep
            let encode: Any = add ? ["cards": cards] : Deck(deckInfo: DeckInformation(icon: icon, tags: tags), data: cards)
            // jsonData will then try the decode based upon the passed in BOOL for adding a card.
            // Since casted as 'Any' must type cast to the type of data to encode.
            let jsonData = add ? try jsonEncoder.encode(encode as? [String: [CardData]]) : try jsonEncoder.encode(encode as? Deck)
            request.httpBody = jsonData
        } catch {
            print("Error encoding deck object: \(error)")
            completion(nil)
            return
        }

        dataLoader.loadData(using: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                print("collection not found")
                completion(nil)
                return
            }

            if let error = error {
                print("Error with request: \(error)")
                completion(nil)
                return
            }

            guard let data = data else { completion(nil); return }

            let jsonDecoder = JSONDecoder()
            do {
                let decodedData = try jsonDecoder.decode(T.self, from: data)
                completion(decodedData)
            } catch {
                print("error decoding data")
                completion(nil)
                return
            }
        }
    }

    // Function will archive the deck if passed in archive is true, will move out of archive if archive set to false.
    func archivePost(user: User, deckName: String, archive: Bool, completion: @escaping () -> Void) {
        guard let baseURL = baseURL else { completion(); return }

        var archiveDeckURL = archive ? baseURL.appendingPathComponent("archive") : baseURL.appendingPathComponent("remove-archive")

        archiveDeckURL = archiveDeckURL.appendingPathComponent(user.id).appendingPathComponent(deckName)

        var request = URLRequest(url: archiveDeckURL)
        request.httpMethod = HTTPMethod.post.rawValue

        dataLoader.loadData(using: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 500 {
                print("collection not found")
                completion()
                return
            }

            if let error = error {
                print("Error with request: \(error)")
                completion()
                return
            }
            completion()
        }
    }

    // Used to delete cards and delete decks, pass in cards to delete cards for a deck
    func delete(user: User, deck: Deck, deleteCards: [CardData]?, archived: Bool = false, completion: @escaping (Deck?) -> Void) {
        guard let baseURL = baseURL,
            let collectionId = deck.deckInformation.collectionId else { completion(nil); return }

        var deleteDeckURL = baseURL.appendingPathComponent(user.id).appendingPathComponent(collectionId)

        if archived {
            deleteDeckURL.appendPathComponent("delete-archived-deck")
        } else {
            if deleteCards != nil {
                deleteDeckURL = deleteDeckURL.appendingPathComponent("delete-cards")
            } else {
                deleteDeckURL = deleteDeckURL.appendingPathComponent("delete-deck")
            }
        }

        var request = URLRequest(url: deleteDeckURL)
        request.httpMethod = HTTPMethod.delete.rawValue

        if let deleteCards = deleteCards {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                let cardsDictionary = ["cards": deleteCards]
                let jsonData = try JSONEncoder().encode(cardsDictionary)
                request.httpBody = jsonData
            } catch {
                print("Error encoding deck card information")
                completion(nil)
                return
            }
        }

        dataLoader.loadData(using: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 404 {
                print("collection not found")
                completion(nil)
                return
            }
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }

            // If this happens it will return an updated deck cards that were deleted
            if deleteCards != nil {
                guard let data = data else { completion(nil); return }
                do {
                    let decodedData = try JSONDecoder().decode(Deck.self, from: data)
                    completion(decodedData)
                    return
                } catch {
                    print("Error decoding data: \(error)")
                    completion(nil)
                    return
                }
            }

            // return the deck that was passed in for deletion from the deck array
            completion(deck)
        }
    }

    func put<T: Codable>(user: User, deck: Deck, updateDeckName: String?, updateCards: [CardData]?,  completion: @escaping(T?) -> Void) {
        guard let baseURL = baseURL,
            let collectionId = deck.deckInformation.collectionId else { completion(nil); return }

        var updateURL: URL?
        if let _ = updateDeckName {
            updateURL = baseURL.appendingPathComponent("update-deck-name")
        } else if let _ = updateCards {
            updateURL = baseURL.appendingPathComponent("update")
        }

        guard var requestURL = updateURL else { completion(nil); return }

        requestURL.appendPathComponent(user.id)
        requestURL.appendPathComponent(collectionId)

        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            var jsonData: Data?

            if let updateCards = updateCards {
                let changesDictionary = ["changes": updateCards]
                print(changesDictionary)
                jsonData = try JSONEncoder().encode(changesDictionary)
            } else if let updateDeckName = updateDeckName {
                let updateDeckNameDictionary = ["deckName": updateDeckName]
                let changesDictionary = ["changes": updateDeckNameDictionary]
                jsonData = try JSONSerialization.data(withJSONObject: changesDictionary, options: [])
                print(String(data: jsonData!, encoding: .utf8)!)
            }
            request.httpBody = jsonData

        } catch {
            print("Cannot encode json data")
            completion(nil)
            return
        }


        dataLoader.loadData(using: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 404 {
                print("collection not found")
                completion(nil)
                return
            }

            if let error = error {
                print("Error with request: \(error)")
                completion(nil)
                return
            }

            guard let data = data else { completion(nil); return }

            let jsonDecoder = JSONDecoder()
            do {
                let decodedData = try jsonDecoder.decode(T.self, from: data)
                print(decodedData)
                completion(decodedData)
            } catch {
                print("error decoding data")
                completion(nil)
                return
            }
        }
    }
}
