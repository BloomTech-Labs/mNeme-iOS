//
//  User.swift
//  mNeme
//
//  Created by Lambda_School_Loaner_204 on 2/21/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

class User {
    let id: String?
    let data: UserData

    init(_ id: String, _ data: UserData) {
        self.id = id
        self.data = data
    }

}

struct UserData {
    let notificationFrequency: String?
    let favSubjects: String?
    let studyFrequency: String?
    let MobileOrDesktop: String?
    let customOrPremade: String?
}
