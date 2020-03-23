//
//  DeckCreateViewController.swift
//  mNeme
//
//  Created by Lambda_School_Loaner_204 on 2/19/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import TaggerKit

class CreateDeckViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, TKCollectionViewDelegate {
    
    // MARK: - Properties
    
    // Controllers
    var deckController: DeckController?
    var userController: UserController?
    
    // Cards
    var cards: [CardData] = [] {
        didSet {
            parseAllCards()
            DispatchQueue.main.async {
                self.cardTableView.reloadData()
            }
        }
    }
    
    var unarchivedCards: [CardData] = []
    var archivedCards: [CardData] = []
    var newCards: [CardData] = []
    var deletedCards: [CardData] = []
    var didAddCard: Bool =  false
    
    // Decks
    var indexOfDeck: Int?
    var deck: Deck? {
        didSet {
            updatedDeck = deck
        }
    }
    var updatedDeck: Deck? {
        didSet {
            cards = updatedDeck?.data ?? []
        }
    }
    
    
    // Tags
    var tags: [String] = []
    var allTagsCollection = TKCollectionView()
    var productTagsCollection = TKCollectionView()
    
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var deckNameTF: UITextField!
    @IBOutlet weak var deckIconTF: UITextField!
    @IBOutlet weak var deckTagsTF: TKTextField!
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerView2: UIView!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cardTableView.delegate = self
        cardTableView.dataSource = self
        setupTags()
        cardTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setDeck()
        updateLaunchViews()
        updateDeckViews()
        cardTableView.reloadData()
    }
    
    // MARK: - IB Actions
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        guard let deckName = deckNameTF.text, !deckName.isEmpty, let deckIcon = deckIconTF.text, !deckIcon.isEmpty, let userController = userController, let user = userController.user, let deckController = deckController else { return }
        guard cards.count > 0 else { return }
        
        if let deck = deck {
            
            let didChangName = didChangeName(textFieldString: deckName)
            
            //use switch for cleanup
            
            if didChangName == true && didAddCard == true {
                
                deckController.addCardsToServer(user: user, name: deck.deckInformation.collectionId ?? "", cards: newCards) { (deck) in
                    print("\(String(describing: deck.deckInformation.deckName)) has added cards to server")
                }
                
                deckController.editDeckCards(deck: deck, user: user, cards: self.cards) { (deck) in
                    print("\(String(describing: deck.deckInformation.deckName)) has updated cards in server")
                }
                
                deckController.editDeckName(deck: deck, user: user, updatedDeckName: deckName) { (deckInfo) in
                    //update controller
                    deckController.decks[self.indexOfDeck!].data = self.updatedDeck?.data
                    deckController.decks[self.indexOfDeck!].deckInformation = deckInfo
                    
                    DispatchQueue.main.async {
                        self.clearViews()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else if didChangName == true {
                
                deckController.editDeckCards(deck: deck, user: user, cards: self.cards) { (deck) in
                    print("\(String(describing: deck.deckInformation.deckName)) has updated cards in server")
                }
                
                deckController.editDeckName(deck: deck, user: user, updatedDeckName: deckName) { (deckInfo) in
                    //update controller
                    deckController.decks[self.indexOfDeck!].data = self.updatedDeck?.data
                    deckController.decks[self.indexOfDeck!].deckInformation = deckInfo
                    
                    DispatchQueue.main.async {
                        self.clearViews()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else if didAddCard == true {
                
                deckController.editDeckCards(deck: deck, user: user, cards: self.cards) { (deck) in
                    print("\(String(describing: deck.deckInformation.deckName)) has updated cards in server")
                }
                
                deckController.addCardsToServer(user: user, name: deck.deckInformation.collectionId ?? "", cards: newCards) { (deck) in
                    print("\(String(describing: deck.deckInformation.deckName)) has added cards to server")
                }
                
                // update controller
                guard let updatedDeck = self.updatedDeck else { return }
                deckController.decks[self.indexOfDeck!] = updatedDeck
                
                DispatchQueue.main.async {
                    self.clearViews()
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                deckController.editDeckCards(deck: deck, user: user, cards: self.cards) { (updatedDeck) in
                    print("\(String(describing: deck.deckInformation.deckName)) has updated cards in server")
                }
                //update Controller
                guard let updatedDeck = self.updatedDeck else { return }
                deckController.decks[self.indexOfDeck!] = updatedDeck
                
                DispatchQueue.main.async {
                    self.clearViews()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            deckController.createDeck(user: user, name: deckName, icon: deckIcon, tags: tags, cards: cards) {
                DispatchQueue.main.async {
                    self.clearViews()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - Setting up Views Functions
    
    private func updateLaunchViews() {
        
        let textAttribute = [NSAttributedString.Key.foregroundColor: UIColor.white]
        doneBarButton.setTitleTextAttributes(textAttribute, for: .normal)
        backBarButton.setTitleTextAttributes(textAttribute, for: .normal)
        topView.layer.backgroundColor = UIColor.mNeme.orangeBlaze.cgColor
        navBar.barTintColor = UIColor.mNeme.orangeBlaze
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        cardTableView.keyboardDismissMode = .onDrag
        
        // Creating a deck
        if indexOfDeck == nil {
            navBar.topItem?.title = "Create a deck"
            self.tagsLabel.isHidden = true
            
            //Editing a deck
        } else {
            navBar.topItem?.title = "Edit deck"
            self.deckIconTF.isUserInteractionEnabled = false
            self.productTagsCollection.action = .noAction
            self.deckTagsTF.isHidden = true
            self.containerView.isHidden = true
        }
        cardTableView.rowHeight = UITableView.automaticDimension
        cardTableView.estimatedRowHeight = 215
        
    }
    
    private func updateDeckViews() {
        if let deck = deck {
            deckNameTF.text = deck.deckInformation.deckName
            deckIconTF.text = deck.deckInformation.icon
            deckTagsTF.text = deck.deckInformation.tags.joined(separator: ", ")
        }
    }
    
    private func setupTags() {
        allTagsCollection.tags = []
        add(allTagsCollection, toView: containerView)
        add(productTagsCollection, toView: containerView2)
        allTagsCollection.action = .addTag
        allTagsCollection.receiver = productTagsCollection
        productTagsCollection.action = .removeTag
        deckTagsTF.sender = allTagsCollection
        deckTagsTF.receiver = productTagsCollection
        allTagsCollection.delegate = self
        productTagsCollection.delegate = self
        
        //Customization
        deckTagsTF.backgroundColor = UIColor.white
        deckTagsTF.layer.cornerRadius = 0
        allTagsCollection.customBackgroundColor = UIColor.mNeme.goldenTaioni
        productTagsCollection.customBackgroundColor = UIColor.mNeme.goldenTaioni
    }
    
    private func clearViews() {
        cards = []
        deckTagsTF.text = ""
        deckNameTF.text = ""
        deckIconTF.text = ""
        cardTableView.reloadData()
    }
    
    private func parseAllCards() {
        self.archivedCards = cards.filter({ $0.archived == true && $0.archived != nil })
        self.unarchivedCards = cards.filter({ $0.archived == false || $0.archived == nil })
        print("\(unarchivedCards.count) unarchived cards")
        print("\(archivedCards.count) archived cards")
        print("\(cards.count) cards (full set)")

    }
    
    // MARK: - Logic Private Functions
    
    private func setDeck() {
        guard let deckController = deckController, let indexOfDeck = indexOfDeck else { return }
        deck = deckController.decks[indexOfDeck]
        // Add tags for deck
        self.productTagsCollection.tags = deck?.deckInformation.tags ?? [""]
    }
    
    private func didChangeName(textFieldString: String) -> Bool {
        if deck?.deckInformation.deckName != textFieldString {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Updating Local Deck
    
    private func addCardToLocalDeck(frontText: String, backText: String) {
        let cardData = CardData(front: frontText, back: backText)
        
        if let _ = deck {
            
            updatedDeck?.data?.insert(cardData, at: 0)
            
            self.newCards.append(cardData)
            cardTableView.reloadData()
        }else {
            self.cards.insert(cardData, at: 0)
        }
        cardTableView.reloadData()
        didAddCard = true
    }
    
    func tagIsBeingAdded(name: String?) {
        guard let name = name else { return }
        tags.append(name)
        print("added \(name)")
    }
    
    func tagIsBeingRemoved(name: String?) {
        guard let name = name else { return }
        for tag in tags {
            if name == tag {
                if let index = tags.firstIndex(of: tag) {
                    tags.remove(at: index)
                }
            }
        }
        
        print("removed \(name)")
        
    }
    
    
    
    // MARK: - Tableview Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return unarchivedCards.count + archivedCards.count
        } else if section == 2{
            return 10
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CreateCardCell", for: indexPath) as? CreateCardTableViewCell {
                cell.delegate = self
                cell.addFlashcardView.layer.cornerRadius = 10
                cell.addFlashcardView.layer.borderColor = UIColor.lightGray.cgColor
                cell.addFlashcardView.layer.borderWidth = 1
                cell.addFlashcardView.layer.backgroundColor = UIColor.white.cgColor
                
                cell.addFrontTV.delegate = self
                cell.addFrontTV.layer.backgroundColor = UIColor.white.cgColor
                cell.addFrontTV.text = "Write on the front!"
                cell.addFrontTV.textColor = UIColor.lightGray
                
                cell.addBackTV.delegate = self
                cell.addBackTV.layer.backgroundColor = UIColor.white.cgColor
                cell.addBackTV.text = "Write on the back!"
                cell.addBackTV.textColor = UIColor.lightGray
                
                return cell
            }
        }
        else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as? CardTableViewCell {
                
                if !self.unarchivedCards.isEmpty {
                    cell.frontCardTV.text = self.unarchivedCards[indexPath.row].front
                    cell.backCardTV.text = self.unarchivedCards[indexPath.row].back
                }
                cell.index = indexPath.row
                cell.delegate = self
                cell.cardView.layer.cornerRadius = 10
                cell.cardView.layer.borderColor = UIColor.lightGray.cgColor
                cell.cardView.layer.borderWidth = 1
                cell.cardView.layer.backgroundColor = UIColor.white.cgColor
                cell.frontCardTV.backgroundColor = .white
                cell.backCardTV.backgroundColor = .white
                
                return cell
            }
        } else if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as? CardTableViewCell {
                
                if !self.archivedCards.isEmpty {
                    cell.frontCardTV.text = self.archivedCards[indexPath.row].front
                    cell.backCardTV.text = self.archivedCards[indexPath.row].back
                }
                cell.index = indexPath.row
                cell.delegate = self
                cell.cardView.layer.cornerRadius = 10
                cell.cardView.layer.borderColor = UIColor.lightGray.cgColor
                cell.cardView.layer.borderWidth = 1
                cell.cardView.layer.backgroundColor = UIColor.white.cgColor
                cell.frontCardTV.textColor = UIColor.lightGray
                cell.backCardTV.textColor = UIColor.lightGray
                cell.dividerView.layer.backgroundColor = UIColor.lightGray.cgColor
                
                return cell
            }
            
        } else {
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 || indexPath.section == 3 {
            return nil
        } else {
            let archived = (indexPath.section == 2 ? true : false)
            let archive = (indexPath.section == 2 ? "Unarchive" : "Archive")
            let archiveButton = UIContextualAction(style: .normal, title: archive) { (action, sourceView, completionHandler) in
                // logic for archive
                guard let user = self.userController?.user, let deck = self.updatedDeck, var cardToArchive = deck.data?[indexPath.row] else { return }
                
                if archived {
                    self.updatedDeck?.data?[indexPath.row + self.unarchivedCards.count].archived?.toggle()
                } else {
                    self.updatedDeck?.data?[indexPath.row].archived?.toggle()
                }
                
                cardToArchive.archived?.toggle()
                
                self.deckController?.archiveCard(deck: deck, user: user, card: cardToArchive, completion: {
                    
                    if archived {
                        self.deckController?.decks[self.indexOfDeck ?? 0].data?[indexPath.row + self.unarchivedCards.count].archived?.toggle()
                    } else {
                        self.deckController?.decks[self.indexOfDeck ?? 0].data?[indexPath.row].archived?.toggle()
                    }
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                })
            }
            archiveButton.backgroundColor = UIColor.mNeme.goldenTaioni
            
            let deleteButton = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
                // logic for delete
                guard let user = self.userController?.user, let deck = self.deckController?.decks[self.indexOfDeck ?? 0], let cardToDelete = deck.data?[indexPath.row] else { return }
                
                let deleteDeckAlert = UIAlertController(title: "Are you sure you want to delete this deck?", message: "", preferredStyle: .actionSheet)
                deleteDeckAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                    for card in self.newCards {
                        if card == cardToDelete {
                            guard let newCardIndex = self.newCards.firstIndex(of: card) else { return }
                            self.newCards.remove(at: newCardIndex)
                            self.updatedDeck?.data?.remove(at: indexPath.row)
                            self.deckController?.decks[self.indexOfDeck ?? 0].data?.remove(at: indexPath.row)
                            tableView.reloadData()
                            return
                        }
                    }
                    self.updatedDeck?.data?.remove(at: indexPath.row)
                    self.deckController?.decks[self.indexOfDeck ?? 0].data?.remove(at: indexPath.row)
                    tableView.reloadData()
                    self.deckController?.deleteCardFromServer(user: user, deck: deck, card: cardToDelete)
                    deleteDeckAlert.dismiss(animated: true, completion: nil)
                }))
                deleteDeckAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    tableView.reloadData()
                }))
                self.present(deleteDeckAlert, animated: true)
                
            }
            deleteButton.backgroundColor = UIColor.red
            let swipeActions = UISwipeActionsConfiguration(actions: [deleteButton,archiveButton])
            return swipeActions
        }
    }
    

    
    // MARK: - TextView Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}

// MARK: - Extensions

extension CreateDeckViewController: CreateCardTableViewCellDelegate {
    func addCardWasTapped(frontText: String, backtext: String) {
        addCardToLocalDeck(frontText: frontText, backText: backtext)
    }
}

extension CreateDeckViewController: CardTableViewCellDelegate {
    func cardWasEdited(index: Int, text: String, side: frontOrBack) {
        if side == .front {
            updatedDeck?.data?[index].front = text
        } else {
            updatedDeck?.data?[index].back = text
        }
    }
}
