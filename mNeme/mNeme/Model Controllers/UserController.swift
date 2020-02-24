//
//  UserController.swift
//  mNeme
//
//  Created by Lambda_School_Loaner_204 on 2/24/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class UserController {

    let dataLoader: NetworkDataLoader

    init(networkDataLoader: NetworkDataLoader = URLSession.shared) {
        self.dataLoader = networkDataLoader
    }

    let baseURL = URL(string: "https://flashcards-be.herokuapp.com/api/users/")!
    func getUserPreferences(_ user: User, completion: @escaping () -> Void ) {
        guard let id = user.id else {
            completion()
            return
        }

        let requestURL = baseURL.appendingPathComponent(id)
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue

        dataLoader.loadData(using: request) { data, response, error in


            completion()
        }
    }
}
