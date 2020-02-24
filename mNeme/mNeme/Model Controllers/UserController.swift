//
//  UserController.swift
//  mNeme
//
//  Created by Lambda_School_Loaner_204 on 2/24/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class UserController {

    var user: User?
    let dataLoader: NetworkDataLoader

    init(networkDataLoader: NetworkDataLoader = URLSession.shared) {
        self.dataLoader = networkDataLoader
    }

    let baseURL = URL(string: "https://flashcards-be.herokuapp.com/api/users/")!
    func getUserPreferences(completion: @escaping () -> Void ) {
        guard let user = user else {
            completion()
            return
        }

        let requestURL = baseURL.appendingPathComponent(user.id)
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue

        dataLoader.loadData(using: request) { data, response, error in
            if let error = error {
                NSLog("Error fetching data: \(error)")
            }

            guard let data = data else { completion(); return }

            do {
                let jsonDecoder = JSONDecoder()
                let userPreferences = try jsonDecoder.decode(User.self, from: data)
                user.data = userPreferences.data
            } catch {
                print("Unable to decode data into user preferences \(error)")
            }
            completion()
        }
    }
}
