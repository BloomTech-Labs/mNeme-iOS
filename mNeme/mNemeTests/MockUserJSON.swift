//
//  MockUserJSON.swift
//  mNemeTests
//
//  Created by Lambda_School_Loaner_204 on 2/24/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

let userWithData = """
{
  "id": "r4Ok4g9OA5UHtpXnDRqF5XFCduH3",
  "data": {
    "id": "r4Ok4g9OA5UHtpXnDRqF5XFCduH3",
    "notificationFrequency": "Don't send me notifications",
    "favSubjects": "Math, Science",
    "studyFrequency": "Once a day",
    "MobileOrDesktop": "Desktop",
    "customOrPremade": "pre-made"
  }
}
""".data(using: .utf8)!

let userWithoutData = """
{
  "id": "r4Ok4g9OA5UHtpXnDRqF5XFCduH3",
  "data": {
  }
}
""".data(using: .utf8)!
