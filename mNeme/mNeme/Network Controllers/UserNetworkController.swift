//
//  UserNetworkController.swift
//  mNeme
//
//  Created by Lambda_School_Loaner_204 on 2/24/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class UserNetworkController {

    let baseURL = URL(string: "https://flashcards-be.herokuapp.com/api/users/")!
    func getUserFromServer(_ user: User, completion: @escaping (Error?) -> Void ) {
        guard let id = user.id else {
            completion (NSError())
            return
        }

        let requestURL = baseURL.appendingPathComponent(id)
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in


            completion(nil)


        }.resume()

    }
}
