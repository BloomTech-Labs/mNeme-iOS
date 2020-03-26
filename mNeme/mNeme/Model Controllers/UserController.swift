//
//  UserController.swift
//  mNeme
//
//  Created by Lambda_School_Loaner_204 on 2/24/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class UserController {

    // MARK: - Properties
    var user: User?
    let dataLoader: NetworkDataLoader
    let baseURL = URL(string: "https://flashcards-be.herokuapp.com/api/users/")!

    // MARK: - Init
    init(networkDataLoader: NetworkDataLoader = URLSession.shared) {
        self.dataLoader = networkDataLoader
    }

    // MARK: - Network methods
    func getUserPreferences(completion: @escaping () -> Void ) {
        guard let user = user else { completion(); return }

        let requestURL = baseURL.appendingPathComponent(user.id)
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue

        dataLoader.loadData(using: request) { data, response, error in
            if let _ = error { completion(); return }

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

    func putUserPreferences(_ changes: [String: UserData?], completion: @escaping () -> Void) {
        guard let user = user else { completion(); return }

        let requestURL = baseURL.appendingPathComponent(user.id)
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonEncoder = JSONEncoder()
            request.httpBody = try jsonEncoder.encode(changes)
        } catch {
            print("Error entry!")
            completion()
            return
        }

        dataLoader.loadData(using: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 500 {
                    print("Internal server error")
                    completion()
                    return
                } else if response.statusCode == 404 {
                    print("User not found")
                    completion()
                    return
                }
            }

            if let error = error {
                print("Error saving user preferences to server: \(error)")
                completion()
                return
            }

            completion()
        }
    }

    // MARK:  - CRUD Methods
    // this function will return true if the user updates any fields that are not the same
    func shouldUpdateUserWith(subjects: String?, studyFrequency: String?,
                    mobileOrDesktop: String?, customOrPremade: String?,
                    notificationFrequency: String?) -> Bool {
        guard let user = user else { return false }

        // must have an optional value and not be set to nil when updated data to return to the server
        let updatedUserData = UserData(id: user.id,
                                       notificationFrequency: notificationFrequency ?? "",
                                       favSubjects: subjects ?? "",
                                       studyFrequency: studyFrequency ?? "",
                                       MobileOrDesktop: mobileOrDesktop ?? "",
                                       customOrPremade: customOrPremade ?? "")

        if updatedUserData != user.data {
            user.data = updatedUserData
            return true
        } else { return false }
    }
}
