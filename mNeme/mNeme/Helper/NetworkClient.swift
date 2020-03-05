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

//    func fetchDeck() {
//        fetch("", nil) { (deck: [Deck]?) in
//            <#code#>
//        }
//    }

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
                completion(decodedData)
            } catch {
                print("Error Decoding deck card data")
                completion(nil)
            }
        }
    }
}
