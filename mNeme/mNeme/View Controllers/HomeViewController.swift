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
    var deckController: DeckController?
    var userController: UserController?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        deckTableView.delegate = self
        deckTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        
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

    // Function to help the tableview delete a deck from the deckController. Bool passed in determines
    // whether or its from the archived section.
    private func deleteDeck(fromArchive: Bool, user: User, index: Int) {
        if fromArchive {
            if let deck = self.deckController?.archivedDecks[index] {
                self.deckController?.archivedDecks.remove(at: index)
                self.deckController?.deleteArchivedDeck(user: user, deck: deck)
            }
        } else {
            if let deck = self.deckController?.decks[index] {
                self.deckController?.decks.remove(at: index)
                self.deckController?.deleteDeckFromServer(user: user, deck: deck)
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DeckSegue" {
            if let deckCardVC = segue.destination as? DeckCardViewController, let indexPath = deckTableView.indexPathForSelectedRow {
                if indexPath.section == 0 {
                    deckCardVC.indexOfDeck = indexPath.row
                    deckCardVC.userController = userController
                    deckCardVC.deckController = deckController
                    deckCardVC.demo = true
                } else {
                    deckCardVC.indexOfDeck = indexPath.row
                    deckCardVC.userController = userController
                    deckCardVC.deckController = deckController
                }
            }
        } else if segue.identifier == "CreateADeckSegue" {
            if let createVC = segue.destination as? CreateDeckViewController {
                createVC.userController = userController
                createVC.deckController = deckController
            }
        }
    }
    
    // MARK: - TableView Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return deckController?.demoDecks.count ?? 0
        } else if section == 1 {
            return deckController?.decks.count ?? 0
        } else {
            return deckController?.archivedDecks.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DemoDeckCell", for: indexPath) as? DeckTableViewCell {
                
                cell.DemoDeck = deckController?.demoDecks[indexPath.row]
                cell.progressBar.progressTintColor = UIColor.mNeme.orangeBlaze
                return cell
            }  else {
                return UITableViewCell()
            }
        } else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DemoDeckCell", for: indexPath) as? DeckTableViewCell {
                
                cell.deck = deckController?.decks[indexPath.row]
                cell.deckNameLabel.textColor = .black
                cell.progressBar.progressTintColor = UIColor.mNeme.orangeBlaze
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DemoDeckCell", for: indexPath) as? DeckTableViewCell {
                cell.archived = true
                cell.deck = deckController?.archivedDecks[indexPath.row]
                cell.deckNameLabel.textColor = .lightGray
                cell.progressBar.progressTintColor = .darkGray
                
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            var archived = false
            var archive = ""
            
            let deleteDeckAlert = UIAlertController(title: "Are you sure you want to delete this deck? Would you rather archive?", message: "", preferredStyle: .actionSheet)
            
            guard let user = self.userController?.user else { return }


            switch indexPath.section {
            case 1:
                guard let deck = self.deckController?.decks[indexPath.row] else { return }
                archive = "Archive"
                deleteDeckAlert.addAction(UIAlertAction(title: archive, style: .default, handler: { (action) in
                    tableView.reloadData()
                    self.deckController?.archiveDeck(user: user, collectionID: deck.deckInformation.collectionId ?? "", index: indexPath.row, completion: {
                        DispatchQueue.main.async {
                            deleteDeckAlert.dismiss(animated: true, completion: nil)
                            tableView.reloadData()
                        }
                    })
                }))
            case 2:
                guard let deck = self.deckController?.archivedDecks[indexPath.row], let deckID = deck.deckInformation.collectionId else { return }
                archive = "Unarchive"
                archived = true
                deleteDeckAlert.addAction(UIAlertAction(title: archive, style: .default, handler: { (action) in
                    tableView.reloadData()
                    self.deckController?.unarchiveDeck(user: user, collectionID: deckID, index: indexPath.row, completion: {
                        DispatchQueue.main.async {
                            tableView.reloadData()
                            deleteDeckAlert.dismiss(animated: true, completion: nil)
                        }
                    })
                }))
            default:
                break
            }

            deleteDeckAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                guard let user = self.userController?.user else { return }

                self.deleteDeck(fromArchive: archived, user: user, index: indexPath.row)
                tableView.reloadData()
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
            guard let deck = self.deckController?.archivedDecks[indexPath.row], let user = self.userController?.user else { return }
            archiveAlert.addAction(UIAlertAction(title: "Unarchive", style: .default, handler: { (action) in
                self.deckController?.unarchiveDeck(user: user, collectionID: deck.deckInformation.collectionId ?? "", index: indexPath.row, completion: {
                    DispatchQueue.main.async {
                        tableView.reloadData()
                        archiveAlert.dismiss(animated: true, completion: nil)
                    }
                })
            }))
            
            archiveAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                tableView.deselectRow(at: indexPath, animated: true)
            }))
            self.present(archiveAlert, animated: true)
        }
    }
}
