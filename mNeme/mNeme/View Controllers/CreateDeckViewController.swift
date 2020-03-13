//
//  DeckCreateViewController.swift
//  mNeme
//
//  Created by Lambda_School_Loaner_204 on 2/19/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class CreateDeckViewController: UIViewController {
    
    var deckController: DemoDeckController?
    var userController: UserController?
    var indexOfDeck: Int?

    // MARK: IBOutlets
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var titleItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    private func updateViews() {
        topView.backgroundColor = UIColor.mNeme.orangeBlaze
        if indexOfDeck == nil {
          self.titleItem.title = "Create a Deck"
        } else {
          self.titleItem.title = "Edit Deck"
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateContainerSegue" {
            if let containerVC = segue.destination as? CreateDeckScrollViewController {
                containerVC.deckController = deckController
                containerVC.userController = userController
                containerVC.indexOfDeck = indexOfDeck
            }
        }
    }
}
