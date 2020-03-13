//
//  HomeViewController.swift
//  mNeme
//
//  Created by Lambda_School_Loaner_204 on 2/19/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var deckCreateButton: UIButton!
    @IBOutlet private weak var deckTableView: UITableView!
    @IBOutlet weak var masteredCountLabel: UILabel!
    @IBOutlet weak var studiedCountLabel: UILabel!
    @IBOutlet weak var studiedLabel: UILabel!
    @IBOutlet weak var masteredLabel: UILabel!
    
    // MARK: - Properties
    var demoDeckController: DemoDeckController?
    var userController: UserController?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        deckTableView.delegate = self
        deckTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(true)
        
        deckTableView.reloadData()
    }
    
    // MARK: - Set Up Views
    private func updateViews() {
        setupOutlets()
    }
    
    private func setupOutlets() {
        // setup colors for labels
        masteredCountLabel.textColor = UIColor.mNeme.orangeBlaze.withAlphaComponent(0.25)
        masteredCountLabel.isOpaque = false
        masteredLabel.textColor = UIColor.mNeme.orangeBlaze
        studiedCountLabel.textColor = UIColor.mNeme.orangeBlaze
        studiedLabel.textColor = UIColor.mNeme.orangeBlaze
        // segmented control
        segmentedControl.selectedSegmentTintColor = UIColor.mNeme.orangeBlaze
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
        // deck create button
        deckCreateButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DeckSegue" {
            if let deckCardVC = segue.destination as? DeckCardViewController, let indexPath = deckTableView.indexPathForSelectedRow {
                if indexPath.section == 0 {
                    deckCardVC.indexOfDeck = indexPath.row
                    deckCardVC.userController = userController
                    deckCardVC.deckController = demoDeckController
                    deckCardVC.demo = true
                } else {
                    deckCardVC.indexOfDeck = indexPath.row
                    deckCardVC.userController = userController
                    deckCardVC.deckController = demoDeckController
                }
            }
        } else if segue.identifier == "CreateADeckSegue" {
            if let createVC = segue.destination as? CreateDeckViewController {
                createVC.userController = userController
                createVC.deckController = demoDeckController
            }
        }
    }
    
    // MARK: - TableView Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return demoDeckController?.demoDecks.count ?? 0
        } else {
            return demoDeckController?.decks.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DemoDeckCell", for: indexPath) as? DeckTableViewCell {
                
                cell.DemoDeck = demoDeckController?.demoDecks[indexPath.row]
                return cell
            }  else {
                return UITableViewCell()
            }
        } else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DemoDeckCell", for: indexPath) as? DeckTableViewCell {
                
                cell.deck = demoDeckController?.decks[indexPath.row]
                
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let deleteDeckAlert = UIAlertController(title: "Are you sure you want to delete this deck? Would you rather archive?", message: "", preferredStyle: .actionSheet)
            
            
            deleteDeckAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                guard let user = self.userController?.user, let deck = self.demoDeckController?.decks[indexPath.row] else { return }
                self.demoDeckController?.decks.remove(at: indexPath.row)
                tableView.reloadData()
                self.demoDeckController?.deleteDeckFromServer(user: user, deck: deck)
                deleteDeckAlert.dismiss(animated: true, completion: nil)
            }))
                
                deleteDeckAlert.addAction(UIAlertAction(title: "Archive", style: .default, handler: nil))
                deleteDeckAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            let noDeletionAlert = UIAlertController(title: "Cannot delete Demo Deck", message: "", preferredStyle: .alert)
            noDeletionAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            if indexPath.section == 0 {
                self.present(noDeletionAlert, animated: true)
            } else {
                self.present(deleteDeckAlert, animated: true)
            }
            
        }
    }
    
}
