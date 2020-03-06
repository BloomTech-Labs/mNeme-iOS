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
    func fetch<T: Codable>(_ deckId: String, _ colId: String?, completion: @escaping (T?) -> Void) {
        guard let baseURL = baseURL else { completion(nil); return }

        var requestURL = baseURL.appendingPathComponent(deckId)

        // if collection id is not nil it will return the card data.
        if let colId = colId {
            requestURL = requestURL.appendingPathComponent(colId)
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue

        dataLoader.loadData(using: request) { (data, response, error) in
            if let error = error {
                print("\(error)")
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
                print("Error Decoding deck card data")
                completion(nil)
            }
        }
    }

    func post<T: Codable>(user: User, deckName: String, icon: String, tags: [String], cards: [CardRep], add: Bool = false, completion: @escaping (T?) -> Void) {

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
            let encode: Any = add ? ["cards": cards] : DeckRep(deck: DeckInformationRep(icon: icon, tags: tags), cards: cards)
            // jsonData will then try the decode based upon the passed in BOOL for adding a card.
            // Since casted as 'Any' must type cast to the type of data to encode.
            let jsonData = add ? try jsonEncoder.encode(encode as? [String: [CardRep]]) : try jsonEncoder.encode(encode as? DeckRep)

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
}

struct DeckRep: Codable {
    let deck: DeckInformationRep
    let cards: [CardRep]
}

struct DeckInformationRep: Codable {
    var icon: String
    var tags: [String]
}

struct CardRep: Codable {
    let front: String
    let back: String
}
