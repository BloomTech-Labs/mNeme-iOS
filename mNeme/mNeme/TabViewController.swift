//
//  TabViewController.swift
//  mNeme
//
//  Created by Lambda_School_Loaner_204 on 2/19/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import SOTabBar

class TabViewController: SOTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabViewControllers()

    }

    private func setUpTabViewControllers() {
        let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavController")

        let deckCreateVC = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "DeckCreateNavController")

        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileNavController")

        let homeImage = UIImage(systemName: "house")
        let createImage = UIImage(systemName: "pencil")
        let profileImage = UIImage(systemName: "person")

        homeVC.tabBarItem = UITabBarItem(title: "Home", image: homeImage, selectedImage: homeImage)
        deckCreateVC.tabBarItem = UITabBarItem(title: "Create Deck", image: createImage, selectedImage: createImage)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: profileImage, selectedImage: profileImage)

        viewControllers = [homeVC, deckCreateVC, profileVC]
    }
}
