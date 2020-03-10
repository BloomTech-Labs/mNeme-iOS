//
//  CreateDeckScrollViewController.swift
//  mNeme
//
//  Created by Dennis Rudolph on 3/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateDeckScrollViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cards: [CardData] = []
    var cardReps: [CardRep] = []
    var deck: Deck?
    
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
    @IBOutlet weak var addFrontTF: UITextField!
    @IBOutlet weak var addBackTF: UITextField!
    @IBOutlet weak var addCardButton: UIButton!
    @IBOutlet weak var saveDeckButton: UIButton!
    @IBOutlet weak var cardTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardTableView.delegate = self
        cardTableView.dataSource = self
        updateDeckViews()
        cardTableView.reloadData()
    }
    
    @IBAction func addCardTapped(_ sender: UIButton) {
        guard let frontText = addFrontTF.text, !frontText.isEmpty, let backText = addBackTF.text, !backText.isEmpty, let userController = userController else { return }

        if let deck = deck {
            let cardRep = CardRep(front: frontText, back: backText)
            
            deckController?.addCard(user: userController.user!, name: deck.deckInformation.deckName, cards: [cardRep], completion: { (result) in
                if let result = result {
                    
                    DispatchQueue.main.async {
                        self.cards = result
                        // Need to sort cards
                        self.cardTableView.reloadData()
                        self.clearCardViews()
                    }
                    
                }
            })
            
        } else {
            let cardRep = CardRep(front: frontText, back: backText)
            cardReps.insert(cardRep, at: 0)
            cardTableView.reloadData()
            clearCardViews()
        }
    }
    @IBAction func saveDeckTapped(_ sender: UIButton) {
        guard let deckName = deckNameTF.text, !deckName.isEmpty, let deckIcon = deckIconTF.text, !deckIcon.isEmpty, let userController = userController, let user = userController.user, let deckController = deckController else { return }
        guard cardReps.count > 0 else { return }
        
        if let deck = deck { // FIX TAGS PARAMETER ONCE
//            deckController.editDeck(deck: deck, user: user, name: deckName, icon: deckIcon, tags: [""], cards: cards) {
//                DispatchQueue.main.async {
//                    self.clearViews()
//                    self.dismiss(animated: true, completion: nil)
//                }
//            }
        } else {
            deckController.createDeck(user: user, name: deckName, icon: deckIcon, tags: [""], cards: cardReps) {
                DispatchQueue.main.async {
                    self.clearViews()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    private func updateDeckViews() {
        if let deck = deck {
            deckNameTF.text = deck.deckInformation.deckName
            deckIconTF.text = deck.deckInformation.icon
            deckTagsTF.text = deck.deckInformation.tag?.joined(separator: ", ")
            cards = deck.data
        }
    }
    
    private func clearViews() {
        cards = []
        cardReps = []
        deckTagsTF.text = ""
        deckNameTF.text = ""
        deckIconTF.text = ""
        addFrontTF.text = ""
        addBackTF.text = ""
        cardTableView.reloadData()
    }
    
    private func clearCardViews() {
        addFrontTF.text = ""
        addBackTF.text = ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if deck != nil {
            return cards.count
        } else {
            return cardReps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as? CardTableViewCell else { return UITableViewCell() }
        
        if deck != nil {
            cell.frontLabel.text = self.cards[indexPath.row].data.front
            cell.backLabel.text = self.cards[indexPath.row].data.back
        } else {
            cell.frontLabel.text = cardReps[indexPath.row].front
            cell.backLabel.text = cardReps[indexPath.row].back
        }
        return cell
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
