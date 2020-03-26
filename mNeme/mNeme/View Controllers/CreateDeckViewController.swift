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
    
    // Card Properties
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
    
    // Deck Properties
    var indexOfDeck: Int?
    var deck: Deck? {
        didSet {
            updatedDeck = deck
        }
    }
    
    var updatedDeck: Deck? {
        didSet {
            cards = updatedDeck?.data ?? []
            
            //updating this deck will update the deck controller
            deckController?.decks[indexOfDeck ?? 0].data = self.updatedDeck?.data
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
    @IBOutlet weak var privateCheckBoxButton: UIButton!
    @IBOutlet weak var publicCheckboxButton: UIButton!
    @IBOutlet weak var noTagsLabel: UILabel!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cardTableView.delegate = self
        cardTableView.dataSource = self
        setupTags()
        cardTableView.reloadData()
        privateCheckBoxButton.isSelected = true // set automatically for current release canvas
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setDeck()
        updateLaunchViews()
        updateDeckViews()
        cardTableView.reloadData()
    }
    
    // MARK: - IB Actions
    
    @IBAction func privateDeckButtonTapped(_ sender: Any) {
        //for future release
    }
    
    @IBAction func publicDeckButtonTapped(_ sender: Any) {
        //for future release
    }
    
    
    @IBAction func backTapped(_ sender: Any) {
        if (indexOfDeck != nil) {
            return
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        
        guard let deckName = deckNameTF.text, !deckName.isEmpty, let deckIcon = deckIconTF.text, !deckIcon.isEmpty, let userController = userController, let user = userController.user, let deckController = deckController else {
            
            let deckRequirementsAlert = UIAlertController(title: "More info needed!", message: "Your deck needs a name, icon, and at least 1 card!", preferredStyle: .alert)
            deckRequirementsAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(deckRequirementsAlert, animated: true)
            return
        }
        
        guard cards.count > 0 else {
            let cardRequirementAlert = UIAlertController(title: "Add a card to your deck!", message: "", preferredStyle: .alert)
            cardRequirementAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(cardRequirementAlert, animated: true)
            return
        }
        
        if let deck = deck { //If editing a deck
            
            let didChangName = didChangeName(textFieldString: deckName)
        
            if didChangName == true && didAddCard == true {
                
                deckController.editDeckCards(deck: deck, user: user, cards: self.cards) { (deck) in
                    print("\(String(describing: deck.deckInformation.deckName)) has updated cards in server")
                }
                
                deckController.addCardsToServer(user: user, name: deck.deckInformation.collectionId ?? "", cards: newCards) { (deck) in
                    print("\(String(describing: deck.deckInformation.deckName)) has added cards to server")
                    //update controller with new cards
                
                    deckController.decks[self.indexOfDeck!] = deck
                    
                    deckController.editDeckName(deck: deck, user: user, updatedDeckName: deckName) { (deckInfo) in
                        //update controller with new name
                        self.deckController?.decks[self.indexOfDeck ?? 0].deckInformation = deckInfo
                        
                        DispatchQueue.main.async {
                            self.clearViews()
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            } else if didChangName == true {
                
                deckController.editDeckCards(deck: deck, user: user, cards: self.cards) { (deck) in
                    print("\(String(describing: deck.deckInformation.deckName)) has updated cards in server")
                }
                
                deckController.editDeckName(deck: deck, user: user, updatedDeckName: deckName) { (deckInfo) in
                    //update controller with new name
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
                    //update controller with new cards
                    deckController.decks[self.indexOfDeck!] = deck
                    
                    DispatchQueue.main.async {
                        self.clearViews()
                        self.dismiss(animated: true, completion: nil)
                    }
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
        } else { //If creating a deck
            
             //This fixes edit card problem, need to find better solution
            self.deckNameTF.becomeFirstResponder()
            
            deckController.createDeck(user: user, name: deckName, icon: deckIcon, tags: tags, cards: cards) {
                DispatchQueue.main.async {
                    self.clearViews()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - Setting up Views Private Functions
    
    private func updateLaunchViews() {
        
        let textAttribute = [NSAttributedString.Key.foregroundColor: UIColor.white]
        doneBarButton.setTitleTextAttributes(textAttribute, for: .normal)
        backBarButton.setTitleTextAttributes(textAttribute, for: .normal)
        topView.layer.backgroundColor = UIColor.mNeme.orangeBlaze.cgColor
        navBar.barTintColor = UIColor.mNeme.orangeBlaze
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        privateCheckBoxButton.tintColor = UIColor.mNeme.orangeBlaze
        publicCheckboxButton.tintColor = UIColor.mNeme.orangeBlaze
        cardTableView.keyboardDismissMode = .onDrag
        
        // Creating a deck
        if indexOfDeck == nil {
            navBar.topItem?.title = "Create a deck"
            self.tagsLabel.isHidden = true
            self.noTagsLabel.isHidden = true
            
        //Editing a deck
        } else {
            navBar.topItem?.title = "Edit deck"
            doneBarButton.title = "Done"
            let textAttribute = [NSAttributedString.Key.foregroundColor: UIColor.mNeme.orangeBlaze]
            backBarButton.setTitleTextAttributes(textAttribute, for: .normal)
            self.deckIconTF.isUserInteractionEnabled = false
            self.productTagsCollection.action = .noAction
            self.deckTagsTF.isHidden = true
            self.containerView.isHidden = true
            if deck?.deckInformation.tags.count == 0 {
                self.noTagsLabel.isHidden = false
            } else {
                self.noTagsLabel.isHidden = true
            }
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
//        cards = []
        newCards = []
        deckTagsTF.text = ""
        deckNameTF.text = ""
        deckIconTF.text = ""
        cardTableView.reloadData()
    }
    
    // MARK: - Logic Private Functions
    
    private func setDeck() {
        guard let deckController = deckController, let indexOfDeck = indexOfDeck else { return }
        var deck = deckController.decks[indexOfDeck]
        
        //Arrange cards
        guard let archivedCards = deck.data?.filter({ $0.archived == true}) else { return }
        guard let unarchivedCards = deck.data?.filter({ $0.archived == false || $0.archived == nil }) else { return }
        deck.data = unarchivedCards + archivedCards
        
        // Add tags for deck
        self.productTagsCollection.tags = deck.deckInformation.tags
        
        //Set deck
        self.deck = deck
        deckController.decks[indexOfDeck].data = deck.data
    }
    
    //Checks if the user changed the deck name
    private func didChangeName(textFieldString: String) -> Bool {
        if deck?.deckInformation.deckName != textFieldString {
            return true
        } else {
            return false
        }
    }
    
    private func parseAllCards() {
        self.archivedCards = cards.filter({ $0.archived == true})
        self.unarchivedCards = cards.filter({ $0.archived == false || $0.archived == nil })
        
        print("\(unarchivedCards.count) unarchived cards")
        print("\(archivedCards.count) archived cards")
        print("\(cards.count) cards (full set)")
    }
    
    // MARK: - Updating Local Deck Methods
    
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
        } else { // So that the user has space for keyboard when editing bottom card
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
                
                cell.addCardButton.setTitleColor(UIColor.mNeme.orangeBlaze, for: .normal)
                
                return cell
            }
        } else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as? CardTableViewCell {
                
                cell.frontCardTV.text = self.cards[indexPath.row].front
                cell.backCardTV.text = self.cards[indexPath.row].back
                
                cell.index = indexPath.row
                cell.delegate = self
                cell.cardView.layer.cornerRadius = 10
                cell.cardView.layer.borderColor = UIColor.lightGray.cgColor
                cell.cardView.layer.borderWidth = 1
                cell.cardView.layer.backgroundColor = UIColor.white.cgColor
                cell.frontCardTV.backgroundColor = .white
                cell.backCardTV.backgroundColor = .white
                
                if self.cards[indexPath.row].archived == true {
                    cell.frontCardTV.textColor = UIColor.lightGray
                    cell.backCardTV.textColor = UIColor.lightGray
                    cell.dividerView.layer.backgroundColor = UIColor.lightGray.cgColor
                } else {
                    cell.frontCardTV.textColor = UIColor.black
                    cell.backCardTV.textColor = UIColor.black
                    cell.dividerView.layer.backgroundColor = UIColor.black.cgColor
                }
                
                return cell
            }
        } else {
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 || indexPath.section == 2 { // No swipe functions for these sections
            return nil
        } else {
            var archived = false
            var archive = "Archive"
            
            if self.cards[indexPath.row].archived == true {
                archive = "Unarchive"
                archived = true
            } else {
                archive = "Archive"
                archived = false
            }
            
            let archiveButton = UIContextualAction(style: .normal, title: archive) { (action, sourceView, completionHandler) in
                
                //Creating archive alert
                let cannotArchiveAlert = UIAlertController(title: "Can't archive a new card", message: "", preferredStyle: .alert)
                cannotArchiveAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                guard let user = self.userController?.user, let deck = self.updatedDeck else {
                    //If they try to archive a card when creating a deck
                    self.present(cannotArchiveAlert, animated: true)
                    tableView.reloadData()
                    return
                }
                
                if self.updatedDeck?.data?[indexPath.row].archived == nil {
                    //New cards dont have an archived property yet, need to send to server before archiving
                    self.present(cannotArchiveAlert, animated: true)
                    tableView.reloadData()
                    return
                }
                
                var cardToArchive: CardData?
                
                if archived { //Updating local deck with new archived/unarchived card info
                    self.updatedDeck?.data?[indexPath.row].archived?.toggle()
                    guard let cardBeingUnarchived = self.updatedDeck?.data?.remove(at: indexPath.row) else { return }
                    self.updatedDeck?.data?.insert(cardBeingUnarchived, at: self.unarchivedCards.count)
                    cardToArchive = self.updatedDeck?.data?[indexPath.row]
                } else {
                    self.updatedDeck?.data?[indexPath.row].archived?.toggle()
                    guard let cardBeingArchived = self.updatedDeck?.data?.remove(at: indexPath.row) else { return }
                    self.updatedDeck?.data?.append(cardBeingArchived)
                    cardToArchive = self.updatedDeck?.data?.last
                }
                
                guard let card = cardToArchive else { return }
                
                //Sending new card archived data to server
                self.deckController?.archiveCard(deck: deck, user: user, card: card, completion: {
                    self.deckController?.decks[self.indexOfDeck ?? 0].data? = self.updatedDeck!.data!
                    
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                })
            }
            archiveButton.backgroundColor = UIColor.mNeme.goldenTaioni
            
            let deleteButton = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
                // Logic for deleting a card
                if self.indexOfDeck == nil {
                    self.cards.remove(at: indexPath.row)
                    return
                }
                
                guard let user = self.userController?.user, let deck = self.deckController?.decks[self.indexOfDeck ?? 0], let cardToDelete = deck.data?[indexPath.row] else { return }
                
                let deleteDeckAlert = UIAlertController(title: "Are you sure you want to delete this card?", message: "", preferredStyle: .actionSheet)
                deleteDeckAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                    if self.cards.count > 1 {
                    
                        for card in self.newCards { // Taking deleted card out of new card array and updating locally
                            if card == cardToDelete {
                                guard let newCardIndex = self.newCards.firstIndex(of: card) else { return }
                                self.newCards.remove(at: newCardIndex)
                                self.updatedDeck?.data?.remove(at: indexPath.row)
                                tableView.reloadData()
                                return
                            }
                        }
                        
                        self.updatedDeck?.data?.remove(at: indexPath.row)
                        tableView.reloadData()
                        self.deckController?.deleteCardFromServer(user: user, deck: deck, card: cardToDelete)
                        deleteDeckAlert.dismiss(animated: true, completion: nil)
                    } else {
                        //Decks need at least one card in them
                        deleteDeckAlert.dismiss(animated: true) {
                            let minimumCardAlert = UIAlertController(title: "Your deck needs at least one card!", message: "", preferredStyle: .alert)
                            minimumCardAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                                DispatchQueue.main.async {
                                    tableView.reloadData()
                                }
                            }))
                            self.present(minimumCardAlert, animated: true)
                        }
                    }
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

//Updates local deck whenever card is edited
extension CreateDeckViewController: CardTableViewCellDelegate {
    func cardWasEdited(index: Int, text: String, side: frontOrBack) {
        if side == .front {
            if indexOfDeck != nil { // If editing
                updatedDeck?.data?[index].front = text
            } else if !cards.isEmpty{ // If creating
                self.cards[index].front = text
            }
        } else {
            if indexOfDeck != nil { // If editing
                updatedDeck?.data?[index].back = text
            } else if !cards.isEmpty{ // If creating
                self.cards[index].back = text
            }
        }
    }
}
