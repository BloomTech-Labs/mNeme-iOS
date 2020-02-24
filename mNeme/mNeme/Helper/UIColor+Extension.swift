//
//  UIColor+Extension.swift
//  mNeme
//
//  Created by Lambda_School_Loaner_204 on 2/19/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    // Can use hex code to create colors
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }

    // Structure to hold all the unique hex colors for the mNeme app
    struct mNeme {
        static let orangeBlaze = UIColor(rgb: 0xf66e00)
        static let jaffa = UIColor(rgb: 0xf58d39)
        static let goldenTaioni = UIColor(rgb: 0xffd164)
        static let pinecone = UIColor(rgb: 0x6a5c55)
        static let dawnPink = UIColor(rgb: 0xf3ece3)
        static let merlin = UIColor(rgb: 0x453c38)
    }

}
