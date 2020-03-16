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
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return demoDeckController?.demoDecks.count ?? 0
        } else if section == 1 {
            return demoDeckController?.decks.count ?? 0
        } else {
            return demoDeckController?.archivedDecks.count ?? 0
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
                cell.deckNameLabel.textColor = .black
                cell.progressBar.progressTintColor = UIColor.mNeme.orangeBlaze
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DemoDeckCell", for: indexPath) as? DeckTableViewCell {
                
                cell.deck = demoDeckController?.archivedDecks[indexPath.row]
                cell.deckNameLabel.textColor = .lightGray
                cell.archived = true
                cell.progressBar.progressTintColor = .darkGray
                
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
    
    private func setArchiveAlertAction() {
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            var archive = ""
            
            let deleteDeckAlert = UIAlertController(title: "Are you sure you want to delete this deck? Would you rather archive?", message: "", preferredStyle: .actionSheet)
            
            guard let user = self.userController?.user else { return }
            
            if indexPath.section == 1 {
                guard let deck = self.demoDeckController?.decks[indexPath.row] else { return }
                archive = "Archive"
                deleteDeckAlert.addAction(UIAlertAction(title: archive, style: .default, handler: { (action) in
                    tableView.reloadData()
                    self.demoDeckController?.archiveDeck(user: user, collectionID: deck.deckInformation.collectionId ?? "", index: indexPath.row, completion: {
                        DispatchQueue.main.async {
                            deleteDeckAlert.dismiss(animated: true, completion: nil)
                            tableView.reloadData()
                        }
                    })
                }))
            } else if indexPath.section == 2 {
                 guard let deck = self.demoDeckController?.archivedDecks[indexPath.row], let deckID = deck.deckInformation.collectionId else { return }
                archive = "Unarchive"
                deleteDeckAlert.addAction(UIAlertAction(title: archive, style: .default, handler: { (action) in
                    tableView.reloadData()
                    self.demoDeckController?.unarchiveDeck(user: user, collectionID: deckID, index: indexPath.row, completion: {
                        self.demoDeckController?.fetchCardsWhenUnarchived(userID: user.id, deckCollectionID: deckID)
                        DispatchQueue.main.async {
                            tableView.reloadData()
                            deleteDeckAlert.dismiss(animated: true, completion: nil)
                        }
                    })
                }))
            }
            
            deleteDeckAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                guard let user = self.userController?.user, let deck = self.demoDeckController?.decks[indexPath.row] else { return }
                self.demoDeckController?.decks.remove(at: indexPath.row)
                tableView.reloadData()
                self.demoDeckController?.deleteDeckFromServer(user: user, deck: deck)
                deleteDeckAlert.dismiss(animated: true, completion: nil)
            }))
            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.performSegue(withIdentifier: "DeckSegue", sender: self)
        } else if indexPath.section == 1 {
            self.performSegue(withIdentifier: "DeckSegue", sender: self)
        } else {
            let archiveAlert = UIAlertController(title: "Please unarchive this deck to view it", message: "", preferredStyle: .alert)
            guard let deck = self.demoDeckController?.archivedDecks[indexPath.row], let user = self.userController?.user else { return }
            archiveAlert.addAction(UIAlertAction(title: "Unarchive", style: .default, handler: { (action) in
                self.demoDeckController?.unarchiveDeck(user: user, collectionID: deck.deckInformation.collectionId ?? "", index: indexPath.row, completion: {
                    DispatchQueue.main.async {
                        tableView.reloadData()
                        archiveAlert.dismiss(animated: true, completion: nil)
                    }
                })
            }))
            
            archiveAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(archiveAlert, animated: true)
        }
    }
}
