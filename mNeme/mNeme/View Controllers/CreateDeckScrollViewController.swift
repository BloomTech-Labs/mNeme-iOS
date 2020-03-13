//
//  CreateDeckScrollViewController.swift
//  mNeme
//
//  Created by Dennis Rudolph on 3/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol CreateDeckDelegate {
    func saveDeckWasTapped(deck: Deck)
}

class CreateDeckScrollViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cards: [CardData] = []
    var newCards: [CardData] = []
    var deletedCards: [CardData] = []
    var delegate: CreateDeckDelegate?
    var deck: Deck? {
        didSet {
            deckName = deck?.deckInformation.deckName
        }
    }
    var indexOfDeck: Int?
    var didAddCard: Bool =  false
    var deckName: String?
    var userController : UserController?
    var deckController: DemoDeckController? {
        didSet{
            print("It passed in")
        }
    }
    
    @IBOutlet weak var deckNameTF: UITextField!
    @IBOutlet weak var deckIconTF: UITextField!
    @IBOutlet weak var deckTagsTF: UITextField!
    @IBOutlet weak var addFlashcardView: UIView!
    @IBOutlet weak var flashCardDividerView: UIView!
    @IBOutlet weak var addFrontTV: UITextView!
    @IBOutlet weak var addBackTV: UITextView!
    @IBOutlet weak var addCardButton: UIButton!
    @IBOutlet weak var saveDeckButton: UIButton!
    @IBOutlet weak var cardTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardTableView.delegate = self
        cardTableView.dataSource = self
        setDeck()
        updateLaunchViews()
        updateDeckViews()
        cardTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setDeck()
        updateDeckViews()
        print("Number of cards in deck \(cards.count)")
        cardTableView.reloadData()
    }
    
    private func setDeck() {
        guard let deckController = deckController, let indexOfDeck = indexOfDeck else { return }
        deck = deckController.decks[indexOfDeck]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addFrontTV.centerVertically()
        addBackTV.centerVertically()
    }
    
    @IBAction func addCardTapped(_ sender: UIButton) {
        guard let frontText = addFrontTV.text, !frontText.isEmpty, let backText = addBackTV.text, !backText.isEmpty else { return }
        
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
        clearCardViews()
    }
    
    @IBAction func saveDeckTapped(_ sender: UIButton) {
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
//                            NotificationCenter.default.post(name: .savedDeck, object: nil, userInfo: ["controller": deckController])
                            self.clearViews()
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            } else if didChangName == true {
                deckController.changeDeckName(deck: deck, newName: deckName)
//                NotificationCenter.default.post(name: .savedDeck, object: nil, userInfo: ["controller": deckController])
                deckController.editDeckName(deck: deck, user: user, name: deckName) {
                    DispatchQueue.main.async {
                        self.clearViews()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else if didAddCard == true {
//                NotificationCenter.default.post(name: .savedDeck, object: nil, userInfo: ["controller": deckController])
                deckController.addCardsToServer(user: user, name: deck.deckInformation.collectionId ?? "", cards: newCards) {
                    DispatchQueue.main.async {
                        self.clearViews()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else {

            }
        } else {
            deckController.createDeck(user: user, name: deckName, icon: deckIcon, tags: [""], cards: cards) {
                DispatchQueue.main.async {
                    self.clearViews()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    private func didChangeName() -> Bool {
        if deckNameTF.text != deckName {
            return true
        } else {
            return false
        }
    }
    
    private func updateLaunchViews() {
        addFlashcardView.layer.cornerRadius = 10
        addFlashcardView.layer.borderWidth = 1
        addFlashcardView.layer.borderColor = UIColor.lightGray.cgColor
        addFlashcardView.layer.backgroundColor = UIColor.white.cgColor
        
        flashCardDividerView.layer.backgroundColor = UIColor.lightGray.cgColor
        flashCardDividerView.layer.cornerRadius = 10
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
        addFrontTV.text = ""
        addBackTV.text = ""
        cardTableView.reloadData()
    }
    
    private func clearCardViews() {
        addFrontTV.text = ""
        addBackTV.text = ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as? CardTableViewCell else { return UITableViewCell() }
        
        cell.frontCardTV.text = self.cards[indexPath.row].front
        cell.backCardTV.text = self.cards[indexPath.row].back
        cell.cardView.layer.cornerRadius = 10
        cell.cardView.layer.borderColor = UIColor.lightGray.cgColor
        cell.cardView.layer.borderWidth = 1
        cell.cardView.layer.backgroundColor = UIColor.white.cgColor
        
        return cell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = cards[indexPath.row] // for completion handler information
        
        let editAlert = UIAlertController(title: "Edit your Card", message: "", preferredStyle: .alert)
        
        editAlert.addAction(UIAlertAction(title: "Save Changes", style: .default, handler: nil)) // Add Completion handler to ensure card updates are pushed
    
        editAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        editAlert.addTextField { (frontTextField: UITextField!) in
            frontTextField.text = card.front
            frontTextField.placeholder = "Front"
        }
        
        editAlert.addTextField { (backTextField: UITextField!) in
            backTextField.text = card.back
            backTextField.placeholder = "Back"
        }
        
        self.present(editAlert, animated: true)
        
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - Extensions

extension UITextView {

    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }

}

