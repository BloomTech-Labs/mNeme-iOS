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

    // MARK: - Properties
    var userController: UserController?
    var demoDeckController: DeckController?

    // MARK: - View Lifecycle
    // Changes the settings for the tab bar
    override func loadView() {
        super.loadView()
        SOTabBarSetting.tabBarTintColor = UIColor.mNeme.orangeBlaze
        SOTabBarSetting.tabBarAnimationDurationTime = 0.25
        SOTabBarSetting.tabBarHeight = 60
        SOTabBarSetting.tabBarCircleSize = CGSize(width: 60.0, height: 60.0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabViewControllers()
    }

    // MARK: - Private Functions
    private func setUpTabViewControllers() {
        // instantiating each navcontroller for view controller on tab bar
        let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")

        let deckSearchVC = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "DeckSearchViewController")

        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController")

        // Constants for tab bar icons/selected
        let homeImage = UIImage(systemName: "house")?.withTintColor(UIColor.mNeme.orangeBlaze, renderingMode: .alwaysOriginal)
        let homeImageSelected = UIImage(systemName: "house")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)

        let searchImage = UIImage(systemName: "magnifyingglass")?.withTintColor(UIColor.mNeme.orangeBlaze, renderingMode: .alwaysOriginal)
        let searchImageSelected = UIImage(systemName: "magnifyingglass")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)

        let profileImage = UIImage(systemName: "person")?.withTintColor(UIColor.mNeme.orangeBlaze, renderingMode: .alwaysOriginal)
        let profileImageSelected = UIImage(systemName: "person")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)

        // Setting up tab bar items for each view controller
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: homeImage, selectedImage: homeImageSelected)
        deckSearchVC.tabBarItem = UITabBarItem(title: "Search Decks", image: searchImage, selectedImage: searchImageSelected)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: profileImage, selectedImage: profileImageSelected)

        viewControllers = [homeVC, deckSearchVC, profileVC]
        tabBarViewControllerProperties()
    }

    // set up the view controllers on the tab bars with property data as needed
    private func tabBarViewControllerProperties() {
        guard let homeVC = self.viewControllers[0] as? HomeViewController,
            let _ = self.viewControllers[1] as? DeckSearchViewController,
            let profileVC = self.viewControllers[2] as? ProfileViewController else { return }
        
        
        profileVC.userController = self.userController
        homeVC.deckController = self.demoDeckController
        homeVC.userController = self.userController
    }
}
