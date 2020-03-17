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
    var cards: [CardData] = []
    var newCards: [CardData] = []
    var deletedCards: [CardData] = []
    var deck: Deck? {
        didSet {
            deckName = deck?.deckInformation.deckName
        }
    }
    var didAddCard: Bool =  false
    var deckName: String?
    var deckController: DemoDeckController? {
        didSet{
            print("It passed in")
        }
    }
    var userController: UserController?
    var indexOfDeck: Int?
    var tags: [String] = []
    var allTagsCollection = TKCollectionView()
    var productTagsCollection = TKCollectionView()

    
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deckNameTF: UITextField!
    @IBOutlet weak var deckIconTF: UITextField!
    @IBOutlet weak var deckTagsTF: TKTextField!
    @IBOutlet weak var saveDeckButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerView2: UIView!
    @IBOutlet weak var tagsLabel: UILabel!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardTableView.delegate = self
        cardTableView.dataSource = self
        setupTags()
        setDeck()
        updateLaunchViews()
        updateDeckViews()
        cardTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        addFrontTV.centerVertically()
        //        addBackTV.centerVertically()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setDeck()
        updateDeckViews()
        print("Number of cards in deck \(cards.count)")
        cardTableView.reloadData()
    }
    
    // MARK: - IB Actions
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveDeckTapped(_ sender: Any) {
        guard let deckName = deckNameTF.text, !deckName.isEmpty, let deckIcon = deckIconTF.text, !deckIcon.isEmpty, let userController = userController, let user = userController.user, let deckController = deckController else { return }
        guard cards.count > 0 else { return }
        
        if let deck = deck {
            
            let didChangName = didChangeName()
            
            //use switch for cleanup
            
            if didChangName == true && didAddCard == true {
                deckController.addCardsToServer(user: user, name: self.deck?.deckInformation.collectionId ?? self.deckName!, cards: newCards) {
                    deckController.editDeckName(deck: deck, user: user, name: deckName) {
                        DispatchQueue.main.async {
                            self.deckController?.changeDeckName(deck: deckController.decks[self.indexOfDeck ?? 0], newName: deckName)
                            self.clearViews()
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            } else if didChangName == true {
                deckController.changeDeckName(deck: deck, newName: deckName)
                deckController.editDeckName(deck: deck, user: user, name: deckName) {
                    DispatchQueue.main.async {
                        self.clearViews()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else if didAddCard == true {
                deckController.addCardsToServer(user: user, name: deck.deckInformation.collectionId ?? "", cards: newCards) {
                    DispatchQueue.main.async {
                        self.clearViews()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                self.dismiss(animated: true, completion: nil)
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
    
    // MARK: - Private Functions
    
    private func updateLaunchViews() {
        // Creating a deck
        if indexOfDeck == nil {
            self.titleLabel.text = "Create a Deck"
//            self.backButton.isHidden = false
            self.backButton.setTitleColor(UIColor.mNeme.orangeBlaze, for: .normal)
            self.saveDeckButton.setTitle("Save", for: .normal)
            self.saveDeckButton.setTitleColor(UIColor.mNeme.orangeBlaze, for: .normal)
            self.tagsLabel.isHidden = true
            
        //Editing a deck
        } else {
            self.titleLabel.text = "Edit Deck"
            self.backButton.isHidden = true
            self.saveDeckButton.setTitle("Done", for: .normal)
            self.saveDeckButton.setTitleColor(UIColor.mNeme.orangeBlaze, for: .normal)
            self.deckIconTF.isUserInteractionEnabled = false
            self.productTagsCollection.action = .noAction
            self.deckTagsTF.isHidden = true
            self.containerView.isHidden = true
        }
        cardTableView.rowHeight = UITableView.automaticDimension
        cardTableView.estimatedRowHeight = 150
        
    }
    
    private func setDeck() {
        guard let deckController = deckController, let indexOfDeck = indexOfDeck else { return }
        deck = deckController.decks[indexOfDeck]
        // Add tags for deck
        self.productTagsCollection.tags = deck?.deckInformation.tags ?? [""]
    }
    
    private func updateDeckViews() {
        if let deck = deck, let cards = deck.data {
            deckNameTF.text = deck.deckInformation.deckName
            deckIconTF.text = deck.deckInformation.icon
            deckTagsTF.text = deck.deckInformation.tags.joined(separator: ", ")
            self.cards = cards
        }
    }
    
    private func clearViews() {
        cards = []
        deckTagsTF.text = ""
        deckNameTF.text = ""
        deckIconTF.text = ""
        cardTableView.reloadData()
    }
    
    private func didChangeName() -> Bool {
        if deckNameTF.text != deckName {
            return true
        } else {
            return false
        }
    }
    
    private func updateCardLocally(index: Int, newFront: String, newBack: String) {
        self.deckController?.decks[self.indexOfDeck ?? 0].data?[index].front = "\(newFront)"
        self.deckController?.decks[self.indexOfDeck ?? 0].data?[index].back = "\(newBack)"
        self.cards[index].front = newFront
        self.cards[index].back = newBack
    }
    
    private func addCardToDeckController(frontText: String, backText: String) {
        
        let cardData = CardData(front: frontText, back: backText)
        
        if let _ = deck {
            let index = self.indexOfDeck
            if let deck = deckController?.decks[index ?? 9], let cards = deckController?.addCardToDeck(deck: deck, card: cardData) {
                self.cards = cards
                self.deck = deck
                self.newCards.append(cardData)
                cardTableView.reloadData()
            }
            
        } else {
            self.cards.insert(cardData, at: 0)
        }
        cardTableView.reloadData()
        didAddCard = true
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
//        deckTagsTF.layer.backgroundColor = UIColor.white.cgColor
        allTagsCollection.customBackgroundColor = UIColor.mNeme.goldenTaioni
        productTagsCollection.customBackgroundColor = UIColor.mNeme.goldenTaioni
      }
    
    // MARK: - Tableview Functions - Refactoring needed for different cells and sections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Add Flashcard"
        } else {
            return "# of Cards in (Deck Name)"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return cards.count
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
                
                cell.addBackTV.delegate = self
                cell.addFrontTV.delegate = self
                
                return cell
            }
        }
        else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as? CardTableViewCell {
                    
                    if !self.cards.isEmpty {
                        cell.frontCardTV.text = self.cards[indexPath.row].front
                        cell.backCardTV.text = self.cards[indexPath.row].back
                    }
                    cell.cardView.layer.cornerRadius = 10
                    cell.cardView.layer.borderColor = UIColor.lightGray.cgColor
                    cell.cardView.layer.borderWidth = 1
                    cell.cardView.layer.backgroundColor = UIColor.white.cgColor
                    cell.frontCardTV.isUserInteractionEnabled = false
                    cell.backCardTV.isUserInteractionEnabled = false
                    
                    return cell
                }
            }
            return UITableViewCell()
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                
                if cards.count == 1 {
                    let cardAlert = UIAlertController(title: "Your deck needs at least one card!", message: "", preferredStyle: .alert)
                    cardAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(cardAlert, animated: true)
                    return
                }
                
                let deleteDeckAlert = UIAlertController(title: "Are you sure you want to delete this card? Would you rather archive?", message: "", preferredStyle: .actionSheet)
                
                
                deleteDeckAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                    guard let user = self.userController?.user, let deck = self.deckController?.decks[self.indexOfDeck ?? 0], let cardToDelete = deck.data?[indexPath.row] else { return }
                    
                    for card in self.newCards {
                        if card == cardToDelete {
                            guard let newCardIndex = self.newCards.firstIndex(of: card) else { return }
                            self.newCards.remove(at: newCardIndex)
                            self.cards.remove(at: indexPath.row)
                            self.deckController?.decks[self.indexOfDeck ?? 0].data?.remove(at: indexPath.row)
                            tableView.reloadData()
                            return
                        }
                    }
                    
                    self.cards.remove(at: indexPath.row)
                    self.deckController?.decks[self.indexOfDeck ?? 0].data?.remove(at: indexPath.row)
                    tableView.reloadData()
                    self.deckController?.deleteCardFromServer(user: user, deck: deck, card: cardToDelete)
                }))
                
                deleteDeckAlert.addAction(UIAlertAction(title: "Archive", style: .default, handler: nil))
                deleteDeckAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(deleteDeckAlert, animated: true)
            }
        }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 0 {
            return .none
        } else {
            return .delete
        }
    }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if indexPath.section == 1 {
                let cell = tableView.cellForRow(at: indexPath) as! CardTableViewCell
                cell.frontCardTV.isUserInteractionEnabled = true
                cell.backCardTV.isUserInteractionEnabled = true
                
                let card = cards[indexPath.row] // for completion handler information
                
                let editAlert = UIAlertController(title: "Edit your Card", message: "", preferredStyle: .alert)
                
                editAlert.addTextField { (frontTextField: UITextField!) in
                    frontTextField.text = card.front
                    frontTextField.placeholder = "Front"
                }
                
                editAlert.addTextField { (backTextField: UITextField!) in
                    backTextField.text = card.back
                    backTextField.placeholder = "Back"
                }
                
                editAlert.addAction(UIAlertAction(title: "Save Changes", style: .default, handler: { (action) in
                    guard let frontTF = editAlert.textFields?[0], let backTF = editAlert.textFields?[1], let newFront = frontTF.text, let newBack = backTF.text else { return }
                    
                    if self.deck != nil {
                        guard let user = self.userController?.user, let deck = self.deckController?.decks[self.indexOfDeck ?? 0], let cardToEdit = deck.data?[indexPath.row] else { return }
                        
                        for card in self.newCards {
                            if card == cardToEdit {
                                guard let newCardIndex = self.newCards.firstIndex(of: card) else { return }
                                self.newCards[newCardIndex].front = "\(newFront)"
                                self.newCards[newCardIndex].front = "\(newBack)"
                                self.updateCardLocally(index: indexPath.row, newFront: newFront, newBack: newBack)
                                tableView.reloadData()
                                return
                            }
                        }
                        
                        self.updateCardLocally(index: indexPath.row, newFront: newFront, newBack: newBack)
                        tableView.reloadData()
                        var newCard = cardToEdit
                        newCard.front = newFront
                        newCard.back = newBack
                        self.deckController?.editDeckCards(deck: deck, user: user, cards: newCard, completion: {
                            DispatchQueue.main.async {
                                editAlert.dismiss(animated: true, completion: nil)
                            }
                        })
                    } else {
                        self.cards[indexPath.row].front = newFront
                        self.cards[indexPath.row].back = newBack
                        tableView.reloadData()
                        editAlert.dismiss(animated: true, completion: nil)
                    }
                    cell.frontCardTV.isUserInteractionEnabled = false
                    cell.backCardTV.isUserInteractionEnabled = false
                }))
                
                editAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    tableView.deselectRow(at: indexPath, animated: true)
                    cell.frontCardTV.isUserInteractionEnabled = false
                    cell.backCardTV.isUserInteractionEnabled = false
                }))
                
                self.present(editAlert, animated: true)
            }
            
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
        
        
        
    }
    
    
    
    extension UITextView {
        
        func centerVertically() {
            let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
            let size = sizeThatFits(fittingSize)
            let topOffset = (bounds.size.height - size.height * zoomScale) / 2
            let positiveTopOffset = max(1, topOffset)
            contentOffset.y = -positiveTopOffset
        }
        
    }
    
    extension CreateDeckViewController: CardTableViewCellDelegate {
        func addCardWasTapped(frontText: String, backtext: String) {
            addCardToDeckController(frontText: frontText, backText: backtext)
        }
}
