//
//  User.swift
//  mNeme
//
//  Created by Lambda_School_Loaner_204 on 2/21/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class User: Codable {
    let id: String
    //var changes: UserData?
    var changes: UserData?
    var data: UserData?

    init(_ id: String) {
        self.id = id
    }

}

struct UserData: Equatable, Codable {
    var id: String
    var notificationFrequency: String
    var favSubjects: String
    var studyFrequency: String
    var MobileOrDesktop: String
    var customOrPremade: String
}
